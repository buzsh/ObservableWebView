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
  
  private var urlObservation: NSKeyValueObservation?
  private var canGoBackObservation: NSKeyValueObservation?
  private var canGoForwardObservation: NSKeyValueObservation?
  private var progressObservation: NSKeyValueObservation?
  private var hasOnlySecureContentObservation: NSKeyValueObservation?
  
  init(_ webView: ObservableWebView) {
    self.observableWebView = webView
    super.init()
    setupEssentialWebKitObservations()
    setupNonEssentialWebKitObservations()
  }
  
  deinit {
    urlObservation?.invalidate()
    canGoBackObservation?.invalidate()
    canGoForwardObservation?.invalidate()
    progressObservation?.invalidate()
    hasOnlySecureContentObservation?.invalidate()
  }
  
  func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
    observableWebView.manager.loadState = .isLoading
    observableWebView.manager.favicon = nil
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

// MARK: Essential WebKit Observers
extension ObservableWebViewCoordinator {
  private func setupEssentialWebKitObservations() {
    setupNavigationObservations()
    setupProgressObservation()
  }
  
  private func setupProgressObservation() {
    progressObservation = observableWebView.manager.webView.observe(\.estimatedProgress, options: .new) { [weak self] webView, change in
      guard let self = self else { return }
      
      if let newProgress = change.newValue {
        let roundedProgress = (newProgress * 100).roundTo(decimalPlaces: 2)
        self.observableWebView.manager.progress = roundedProgress
      }
    }
  }
  
  private func setupNavigationObservations() {
    urlObservation = observableWebView.manager.webView.observe(\.url, options: .new) { [weak self] webView, _ in
      self?.observableWebView.manager.updateUrlString(withUrl: webView.url)
    }
    
    canGoBackObservation = observableWebView.manager.webView.observe(\.canGoBack, options: .new) { [weak self] webView, _ in
      self?.observableWebView.manager.canGoBack = webView.canGoBack
    }
    
    canGoForwardObservation = observableWebView.manager.webView.observe(\.canGoForward, options: .new) { [weak self] webView, _ in
      self?.observableWebView.manager.canGoForward = webView.canGoForward
    }
    
    hasOnlySecureContentObservation = observableWebView.manager.webView.observe(\.hasOnlySecureContent, options: .new) { [weak self] webView, _ in
      self?.observableWebView.manager.isSecurePage = webView.hasOnlySecureContent
    }
  }
}
  
// MARK: Non-Essential WebKit Observers
extension ObservableWebViewCoordinator {
  private func setupNonEssentialWebKitObservations() {
    
  }
}
  
extension ObservableWebViewCoordinator {
  private func fetchFavicon() {
    let faviconService = ObservableFaviconService(webView: observableWebView.manager.webView)
    
    faviconService.fetchFavicon { [weak self] image in
      self?.observableWebView.manager.favicon = image
    }
  }
}

extension Double {
  /// Rounds the double to a specified number of decimal places.
  func roundTo(decimalPlaces places: Int) -> Double {
    let divisor = pow(10.0, Double(places))
    return (self * divisor).rounded() / divisor
  }
}
