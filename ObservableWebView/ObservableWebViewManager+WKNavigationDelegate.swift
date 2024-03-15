//
//  ObservableWebViewManager+WKNavigationDelegate.swift
//  ObservableWebView
//
//  Created by Justin Bush on 3/15/24.
//

import WebKit

extension ObservableWebViewManager: WKNavigationDelegate {
  func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
    print("didStartProvisionalNavigation")
    loadState = .isLoading
  }
  
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    print("didFinish")
    loadState = .finishedLoading
  }
  
  func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
    print("didFail")
    loadState = .error(error)
  }
}
