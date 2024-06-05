//
//  WebViewModel.swift
//  ObservableWebView
//
//  Created by Justin Bush on 6/2/24.
//

import SwiftUI
import WebKit

@Observable
class WebViewModel {
  var manager = ObservableWebViewManager()
  
  init() {
    manager.load("https://duckduckgo.com")
    webViewConfig()
  }
  
  func webViewConfig() {
    manager.webView.allowsBackForwardNavigationGestures = true
  }
}
