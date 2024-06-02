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
  
  //private
  var scriptMessageHandlers: [String: ScriptMessageHandler] = [:]
  
  // MARK: User Settings
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
  func addScriptMessageHandler(_ handler: ScriptMessageHandler, forName name: String) {
    webView.configuration.userContentController.add(ObservableWebViewScriptMessageProxy(handler: handler), name: name)
    scriptMessageHandlers[name] = handler
  }
  
  func removeScriptMessageHandler(forName name: String) {
    webView.configuration.userContentController.removeScriptMessageHandler(forName: name)
    scriptMessageHandlers.removeValue(forKey: name)
  }
}

private class ObservableWebViewScriptMessageProxy: NSObject, WKScriptMessageHandler {
  weak var handler: ScriptMessageHandler?
  
  init(handler: ScriptMessageHandler) {
    self.handler = handler
  }
  
  func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
    handler?.didReceiveScriptMessage(message)
  }
}
