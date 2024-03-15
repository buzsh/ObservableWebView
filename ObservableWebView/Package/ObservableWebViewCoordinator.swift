//
//  ObservableWebViewCoordinator.swift
//  ObservableWebView
//
//  Created by Justin Bush on 3/15/24.
//

import WebKit

class ObservableWebViewCoordinator: NSObject, WKNavigationDelegate {
  var observableWebView: ObservableWebView
  private var progressObservation: NSKeyValueObservation?
  
  init(_ webView: ObservableWebView) {
    self.observableWebView = webView
    super.init()
    setupProgressObservation()
  }
  
  func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
    observableWebView.manager.loadState = .isLoading
  }
  
  func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
    // webview is beginning to receive and display content
  }
  
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    observableWebView.manager.loadState = .isFinished
  }
  
  func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
    observableWebView.manager.loadState = .error(error)
  }
  
  private func setupProgressObservation() {
    progressObservation = observableWebView.manager.webView.observe(\.estimatedProgress, options: .new) { [weak self] webView, change in
      guard let self = self else { return }
      
      if let newProgress = change.newValue {
        let roundedProgress = round(newProgress * 100 * 100) / 100
        self.observableWebView.manager.progress = roundedProgress
      }
    }
  }
  
  deinit {
    progressObservation?.invalidate()
  }
}
