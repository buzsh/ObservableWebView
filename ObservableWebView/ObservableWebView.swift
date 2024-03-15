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
  
  func makeCoordinator() -> Coordinator {
    Coordinator(self)
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

class Coordinator: NSObject, WKNavigationDelegate {
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
    parent.manager.loadState = .finishedLoading
  }
  
  func webView(_ webView: WKWebView,
               didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
    parent.manager.loadState = .error(error)
  }
}
