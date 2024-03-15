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
  var loadState: ObservableWebViewLoadState = .idle {
    didSet {
      updateProgress(for: loadState)
    }
  }
  var progress: Double = 0
  var urlString: String = ""
  
  init(urlString: String = Constants.aboutBlank) {
    self.webView = WKWebView()
    self.urlString = urlString
    load(urlString)
  }
  
  func load(_ urlString: String) {
    print("Attempting to load URL:", urlString)
    self.urlString = urlString
    let url = URL(string: urlString) ?? Constants.aboutBlankUrl
    let request = URLRequest(url: url)
    webView.load(request)
  }
  
  func getWebView() -> WKWebView {
    return webView
  }
  
  private func updateProgress(for state: ObservableWebViewLoadState) {
    switch state {
    case .idle:         progress = 0
    case .isPreparing:  progress = 0
    case .isLoading:    progress = 0
    case .isFinished:   progress = 100
    case .error(_):     progress = 0
    }
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
