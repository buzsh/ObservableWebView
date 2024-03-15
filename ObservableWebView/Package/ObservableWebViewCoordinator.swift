//
//  ObservableWebViewCoordinator.swift
//  ObservableWebView
//
//  Created by Justin Bush on 3/15/24.
//

import WebKit

class ObservableWebViewCoordinator: NSObject, WKNavigationDelegate {
  var parent: ObservableWebView
  
  init(_ webView: ObservableWebView) {
    self.parent = webView
  }
  
  func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
    parent.manager.loadState = .isLoading
  }
  
  func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
    // webview is beginning to receive and display content
  }
  
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    parent.manager.loadState = .isFinished
  }
  
  func webView(_ webView: WKWebView,
               didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
    parent.manager.loadState = .error(error)
  }
}
