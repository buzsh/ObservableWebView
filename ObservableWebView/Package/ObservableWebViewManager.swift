//
//  ObservableWebViewManager.swift
//  ObservableWebView
//
//  Created by Justin Bush on 3/15/24.
//

import SwiftUI
import WebKit
import Observation

extension ObservableWebViewManager {
  private struct Constants {
    static let aboutBlank = "about:blank"
    static let aboutBlankUrl = URL(string: Constants.aboutBlank)!
  }
}

@Observable
class ObservableWebViewManager {
  var webView: WKWebView = WKWebView()
  /// The current state of the WKWebView object.
  var loadState: ObservableWebViewLoadState = .idle
  var progress: Double = 0
  var urlString: String = ""
  
  var canGoBack: Bool {
    webView.canGoBack
  }
  
  var canGoForward: Bool {
    webView.canGoForward
  }
  
  func goBack() {
    webView.goBack()
  }
  
  func goForward() {
    webView.goForward()
  }
  
  init(urlString: String = Constants.aboutBlank) {
    self.webView = WKWebView()
    self.urlString = urlString
    load(urlString)
  }
  
  func load(_ urlString: String) {
    updateUrlString(withString: urlString)
    let url = URL(string: urlString) ?? Constants.aboutBlankUrl
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
