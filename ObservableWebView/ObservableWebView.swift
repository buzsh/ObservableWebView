//
//  ObservableWebView.swift
//  ObservableWebView
//
//  Created by Justin Bush on 3/15/24.
//

import SwiftUI
import WebKit

struct ObservableWebView: NSViewRepresentable {
  private var webViewManager: WebViewManager
  
  init(webViewManager: WebViewManager) {
    self.webViewManager = webViewManager
  }
  
  func makeNSView(context: Context) -> WKWebView {
    webViewManager.getWebView()
  }
  
  func updateNSView(_ nsView: WKWebView, context: Context) {
  }
}
