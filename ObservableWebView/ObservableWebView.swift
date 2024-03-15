//
//  ObservableWebView.swift
//  ObservableWebView
//
//  Created by Justin Bush on 3/15/24.
//

import SwiftUI
import WebKit

struct ObservableWebView {
  var webViewManager: ObservableWebViewManager
  
  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }
  
  func makeWebView(context: Context) -> WKWebView {
    let webView = webViewManager.getWebView()
    webView.navigationDelegate = context.coordinator
    return webView
  }
  
  class Coordinator: NSObject, WKNavigationDelegate {
    var parent: ObservableWebView
    
    init(_ webView: ObservableWebView) {
      self.parent = webView
    }
    
    // Implement WKNavigationDelegate methods as needed
  }
}

#if os(macOS)
extension ObservableWebView: NSViewRepresentable {
  func makeNSView(context: Context) -> WKWebView {
    makeWebView(context: context)
  }
  
  func updateNSView(_ nsView: WKWebView, context: Context) {
  }
}
#else
// For iOS
extension ObservableWebView: UIViewRepresentable {
  func makeUIView(context: Context) -> WKWebView {
    makeWebView(context: context)
  }
  
  func updateUIView(_ uiView: WKWebView, context: Context) {
  }
}
#endif
