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
  private var pageTitleObservation: NSKeyValueObservation?
  private var canGoBackObservation: NSKeyValueObservation?
  private var canGoForwardObservation: NSKeyValueObservation?
  private var progressObservation: NSKeyValueObservation?
  private var hasOnlySecureContentObservation: NSKeyValueObservation?
  
  init(_ webView: ObservableWebView) {
    self.observableWebView = webView
    super.init()
    setupWebKitObservers()
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
  }
  
  func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
    // webview is beginning to receive and display content
   
  }
  
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    observableWebView.manager.loadState = .isFinished
    observableWebView.manager.updateUrlString(withUrl: webView.url)
  }
  
  func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
    observableWebView.manager.loadState = .error(error)
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
  private func setupWebKitObservers() {
    setupNavigationObservations()
    setupProgressObservation()
  }
  
  private func setupProgressObservation() {
    progressObservation = observableWebView.manager.webView.observe(\.estimatedProgress, options: .new) { [weak self] webView, change in
      guard let self = self else { return }
      
      if let newProgress = change.newValue {
        let roundedProgress = (newProgress * 100).roundTo(decimalPlaces: 2)
        self.observableWebView.manager.updateProgress(roundedProgress)
      }
    }
  }
  
  private func setupNavigationObservations() {
    urlObservation = observableWebView.manager.webView.observe(\.url, options: .new) { [weak self] webView, _ in
      self?.observableWebView.manager.updateUrlString(withUrl: webView.url)
    }
    
    pageTitleObservation = observableWebView.manager.webView.observe(\.title, options: .new) { [weak self] webView, change in
      self?.observableWebView.manager.pageTitle = webView.title
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

extension Double {
  /// Rounds the double to a specified number of decimal places.
  func roundTo(decimalPlaces places: Int) -> Double {
    let divisor = pow(10.0, Double(places))
    return (self * divisor).rounded() / divisor
  }
}
