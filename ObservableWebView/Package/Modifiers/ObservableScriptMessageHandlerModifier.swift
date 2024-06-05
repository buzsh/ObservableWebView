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
