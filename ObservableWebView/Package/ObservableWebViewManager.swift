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
  /// The current percent-value of the page load, ranging from 0 to 100.
  var progress: Double = 0
  /// The current URL value of the loaded WebView content as a string.
  var urlString: String?
  var pageTitle: String?
  var canGoBack: Bool = false
  var canGoForward: Bool = false
  var isSecurePage: Bool = false
  // Non-Essential
  var favicon: Image? = nil
  var themeColor: Color = .clear
  
  // MARK: User Settings
  /// When set to true, ObservableWebView will provide non-essential browsing features such as web page theme color, favicon image, etc.
  var shouldUseNonEssentialFeatures: Bool = true
  /// Sets `progress = 0` when `loadState` is equal to `.isFinished`
  var resetProgressOnPageLoad: Bool = true
  
  func goBack() {
    webView.goBack()
  }
  
  func goForward() {
    webView.goForward()
  }
  
  func reload() {
    webView.reload()
  }
  
  func forceReload() {
    webView.reloadFromOrigin()
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


extension ObservableWebViewManager {
  func updateProgress(_ value: Double) {
    progress = value
    
    if resetProgressOnPageLoad && value >= 100 {
      updateProgress(0, withDelay: 0.1)
    }
  }
  
  private func updateProgress(_ value: Double, withDelay delay: Double) {
    Delay.by(delay) {
      self.updateProgress(value)
    }
  }
}

extension ObservableWebViewManager {
  private struct Delay {
    /// Perform an action after a set amount of seconds.
    static func by(_ seconds: Double, closure: @escaping () -> Void) {
      Timer.scheduledTimer(withTimeInterval: seconds, repeats: false) { _ in
        closure()
      }
    }
  }
}
