//
//  ObservableWebViewCoordinator.swift
//  ObservableWebView
//
//  Created by Justin Bush on 3/15/24.
//

import SwiftUI
import WebKit

class ObservableWebViewCoordinator: NSObject, WKNavigationDelegate {
  var observableWebView: ObservableWebView
  
  private var progressObservation: NSKeyValueObservation?
  private var canGoBackObservation: NSKeyValueObservation?
  private var canGoForwardObservation: NSKeyValueObservation?
  private var hasOnlySecureContentObservation: NSKeyValueObservation?
  
  init(_ webView: ObservableWebView) {
    self.observableWebView = webView
    super.init()
    setupProgressObservation()
    setupCanGoBackAndForwardObservations()
    setupEssentialWebKitObservations()
    setupNonEssentialWebKitObservations()
  }
  
  deinit {
    progressObservation?.invalidate()
    canGoBackObservation?.invalidate()
    canGoForwardObservation?.invalidate()
  }
  
  func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
    observableWebView.manager.loadState = .isLoading
  }
  
  func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
    // webview is beginning to receive and display content
    Task { await updateWebViewContentThemeColor(canSetClearColor: false) }
  }
  
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    observableWebView.manager.loadState = .isFinished
    observableWebView.manager.updateUrlString(withUrl: webView.url)
    
    Task { await updateWebViewContentThemeColor() }
    fetchFavicon()
  }
  
  func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
    observableWebView.manager.loadState = .error(error)
  }
  
  /// Provides the option for `canSetClearColor` so that the color does not get cleared on didCommit calls.
  @MainActor
  private func updateWebViewContentThemeColor(canSetClearColor: Bool = true) async {
    let themeColorScript = "document.querySelector('meta[name=\\\"theme-color\\\"]').getAttribute('content');"
    
    do {
      if let themeColorString = try await observableWebView.manager.webView.evaluateJavaScript(themeColorScript) as? String,
         let themeColor = PlatformColor(hex: themeColorString) {
        observableWebView.manager.themeColor = Color(themeColor)
      }
    } catch {
      if canSetClearColor {
        observableWebView.manager.themeColor = Color.clear
      }
    }
  }
}

extension ObservableWebViewCoordinator {
  private func setupProgressObservation() {
    progressObservation = observableWebView.manager.webView.observe(\.estimatedProgress, options: .new) { [weak self] webView, change in
      guard let self = self else { return }
      
      if let newProgress = change.newValue {
        let roundedProgress = (newProgress * 100).roundTo(decimalPlaces: 2)
        self.observableWebView.manager.progress = roundedProgress
      }
    }
  }
  
  private func setupCanGoBackAndForwardObservations() {
    canGoBackObservation = observableWebView.manager.webView.observe(\.canGoBack, options: .new) { [weak self] webView, _ in
      self?.observableWebView.manager.canGoBack = webView.canGoBack
    }
    
    canGoForwardObservation = observableWebView.manager.webView.observe(\.canGoForward, options: .new) { [weak self] webView, _ in
      self?.observableWebView.manager.canGoForward = webView.canGoForward
    }
  }
  
  private func setupEssentialWebKitObservations() {
    hasOnlySecureContentObservation = observableWebView.manager.webView.observe(\.hasOnlySecureContent, options: .new) { [weak self] webView, _ in
      self?.observableWebView.manager.isSecurePage = webView.hasOnlySecureContent
    }
  }
  
  private func setupNonEssentialWebKitObservations() {
    
  }
}
  
extension ObservableWebViewCoordinator {
  private func fetchFavicon() {
    let faviconScript = """
      (function() {
          var links = document.getElementsByTagName('link');
          var icons = Array.from(links).filter(function(link) {
              return link.getAttribute('rel') === 'icon' || link.getAttribute('rel').includes('icon');
          });
          return icons.length > 0 ? icons[0].href : '';
      })();
      """
    
    Task {
      let result = await executeJavaScript(faviconScript)
      switch result {
      case .success(let url):
        if let urlString = url as? String, let faviconUrl = URL(string: urlString) {
          // Await the download and cache function, then set the favicon
          let faviconImage = await downloadAndCacheFavicon(from: faviconUrl)
          await MainActor.run {
            self.observableWebView.manager.favicon = faviconImage
          }
        } else {
          // No valid URL found
          await MainActor.run {
            self.observableWebView.manager.favicon = nil
          }
        }
      case .failure:
        // JavaScript execution failed
        await MainActor.run {
          self.observableWebView.manager.favicon = nil
        }
      }
    }
  }
  
  @MainActor
  private func executeJavaScript(_ script: String) async -> Result<Any?, Error> {
    do {
      let result = try await observableWebView.manager.webView.evaluateJavaScript(script)
      return .success(result)
    } catch {
      return .failure(error)
    }
  }
}

extension ObservableWebViewCoordinator {
  func downloadAndCacheFavicon(from url: URL) async -> Image? {
    do {
      let (data, _) = try await URLSession.shared.data(from: url)

      #if os(iOS)
      if let uiImage = UIImage(data: data) {
        return Image(uiImage: uiImage)
      }
      #elseif os(macOS)
      if let nsImage = NSImage(data: data) {
        return Image(nsImage: nsImage)
      }
      #endif
    } catch {
      print("Error downloading favicon: \(error)")
    }
    return nil
  }
}

extension Double {
  /// Rounds the double to a specified number of decimal places.
  func roundTo(decimalPlaces places: Int) -> Double {
    let divisor = pow(10.0, Double(places))
    return (self * divisor).rounded() / divisor
  }
}
