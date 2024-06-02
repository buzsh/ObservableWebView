//
//  WebViewModel.swift
//  ObservableWebView
//
//  Created by Justin Bush on 6/2/24.
//

import SwiftUI
import WebKit

@Observable
class WebViewModel: ScriptMessageHandler {
  var manager = ObservableWebViewManager()
  
  init() {
    manager.load("https://demo-ai-reminders.vercel.app/")
    webViewConfig()
  }
  
  func webViewConfig() {
    manager.webView.allowsBackForwardNavigationGestures = true
  }
  
  func setupScriptMessageHandlers() {
    manager.addScriptMessageHandler(self, forName: "copilotMessageProcessed")
    manager.addScriptMessageHandler(self, forName: "copilotSidebarHidden")
    manager.addScriptMessageHandler(self, forName: "copilotPopupHidden")
  }
  
  func removeScriptMessageHandlers() {
    manager.removeScriptMessageHandler(forName: "copilotMessageProcessed")
    manager.removeScriptMessageHandler(forName: "copilotSidebarHidden")
    manager.removeScriptMessageHandler(forName: "copilotPopupHidden")
  }
  
  func didReceiveScriptMessage(_ message: WKScriptMessage) {
    switch message.name {
    case "copilotMessageProcessed":
      print("Message processed: \(message.body)")
    case "copilotSidebarHidden":
      print("Sidebar hidden: \(message.body)")
    case "copilotPopupHidden":
      print("Popup hidden: \(message.body)")
    default:
      break
    }
  }
}
