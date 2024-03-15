//
//  ObservableWebViewManager+WKNavigationDelegate.swift
//  ObservableWebView
//
//  Created by Justin Bush on 3/15/24.
//

import WebKit

extension ObservableWebViewManager: WKNavigationDelegate {
  func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
    loadState = .isLoading
  }
  
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    loadState = .finishedLoading
  }
  
  func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
    loadState = .error(error)
  }
}
