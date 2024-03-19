//
//  ObservableWebViewManager.swift
//  ObservableWebView
//
//  Created by Justin Bush on 3/15/24.
//

import SwiftUI
import WebKit
import Observation

@Observable
class ObservableWebViewManager {
  var webView: WKWebView = WKWebView()
  /// The current state of the WKWebView object.
  var loadState: ObservableWebViewLoadState = .idle
  var progress: Double = 0
  var urlString: String?
  
  var canGoBack: Bool = false
  var canGoForward: Bool = false
  
  func goBack() {
    webView.goBack()
  }
  
  func goForward() {
    webView.goForward()
  }
  
  init(urlString: String? = nil) {
    self.webView = WKWebView()
    self.urlString = urlString
    if let urlString = urlString, !urlString.isEmpty {
      load(urlString)
    }
  }
  
  func load(_ urlString: String) {
    updateUrlString(withString: urlString)
    guard let url = URL(string: urlString) else { return }
    let request = URLRequest(url: url)
    webView.load(request)
  }
  
  func getWebView() -> WKWebView {
    return webView
  }
}

extension ObservableWebViewManager {
  func updateUrlString(withString string: String) {
    self.urlString = string
  }
  
  func updateUrlString(withUrl url: URL?) {
    guard let url = url else { return }
    updateUrlString(withString: url.absoluteString)
  }
}
