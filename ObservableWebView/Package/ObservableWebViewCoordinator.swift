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
  
  init(_ webView: ObservableWebView) {
    self.observableWebView = webView
    super.init()
    setupProgressObservation()
    setupCanGoBackAndForwardObservation()
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
  
  private func setupCanGoBackAndForwardObservation() {
    canGoBackObservation = observableWebView.manager.webView.observe(\.canGoBack, options: .new) { [weak self] webView, _ in
      self?.observableWebView.manager.canGoBack = webView.canGoBack
    }
    
    canGoForwardObservation = observableWebView.manager.webView.observe(\.canGoForward, options: .new) { [weak self] webView, _ in
      self?.observableWebView.manager.canGoForward = webView.canGoForward
    }
  }
  
  private func setupNonEssentialWebKitObservations() {
    
  }
}

extension Double {
  /// Rounds the double to a specified number of decimal places.
  func roundTo(decimalPlaces places: Int) -> Double {
    let divisor = pow(10.0, Double(places))
    return (self * divisor).rounded() / divisor
  }
}
