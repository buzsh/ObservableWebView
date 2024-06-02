//
//  ObservableScriptMessageHandlerModifier.swift
//  ObservableWebView
//
//  Created by Justin Bush on 6/2/24.
//

import SwiftUI
import WebKit

protocol ScriptMessageHandler: AnyObject {
  func didReceiveScriptMessage(_ message: WKScriptMessage)
}

struct ObservableScriptMessageHandlerModifier: ViewModifier {
  let name: String
  let handler: (WKScriptMessage) -> Void
  var manager: ObservableWebViewManager
  
  func body(content: Content) -> some View {
    content
      .onAppear {
        manager.addScriptMessageHandler(ObservableScriptMessageHandler(handler: handler), forName: name)
      }
      .onDisappear {
        manager.removeScriptMessageHandler(forName: name)
      }
  }
}

private class ObservableScriptMessageHandler: NSObject, WKScriptMessageHandler, ScriptMessageHandler {
  let handler: (WKScriptMessage) -> Void
  
  init(handler: @escaping (WKScriptMessage) -> Void) {
    self.handler = handler
  }
  
  func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
    handler(message)
  }
  
  func didReceiveScriptMessage(_ message: WKScriptMessage) {
    handler(message)
  }
}


extension View {
  func scriptMessageHandler(_ name: String, manager: ObservableWebViewManager, handler: @escaping (WKScriptMessage) -> Void) -> some View {
    self.modifier(ObservableScriptMessageHandlerModifier(name: name, handler: handler, manager: manager))
  }
}


extension ObservableWebViewManager {
  func addScriptMessageHandler(_ handler: ScriptMessageHandler, forName name: String) {
    webView.configuration.userContentController.add(WebViewScriptMessageProxy(handler: handler), name: name)
    scriptMessageHandlers[name] = handler
  }
  
  func removeScriptMessageHandler(forName name: String) {
    webView.configuration.userContentController.removeScriptMessageHandler(forName: name)
    scriptMessageHandlers.removeValue(forKey: name)
  }
}

private class WebViewScriptMessageProxy: NSObject, WKScriptMessageHandler {
  weak var handler: ScriptMessageHandler?
  
  init(handler: ScriptMessageHandler) {
    self.handler = handler
  }
  
  func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
    handler?.didReceiveScriptMessage(message)
  }
}
