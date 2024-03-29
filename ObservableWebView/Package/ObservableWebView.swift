//
//  ObservableWebView.swift
//  ObservableWebView
//
//  Created by Justin Bush on 3/15/24.
//

import SwiftUI
import WebKit

struct ObservableWebView: View {
  var manager: ObservableWebViewManager
  
  func makeCoordinator() -> ObservableWebViewCoordinator {
    ObservableWebViewCoordinator(self)
  }
}

#if os(macOS)
extension ObservableWebView: NSViewRepresentable {
  func makeNSView(context: Context) -> WKWebView {
    let webView = manager.getWebView()
    webView.navigationDelegate = context.coordinator
    return webView
  }
  
  func updateNSView(_ nsView: WKWebView, context: Context) {}
}
#else
extension ObservableWebView: UIViewRepresentable {
  func makeUIView(context: Context) -> WKWebView {
    let webView = manager.getWebView()
    webView.navigationDelegate = context.coordinator
    return webView
  }
  
  func updateUIView(_ uiView: WKWebView, context: Context) {}
}
#endif
