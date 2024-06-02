//
//  BrowserView.swift
//  ObservableWebView
//
//  Created by Justin Bush on 4/6/24.
//

import SwiftUI

struct BrowserView: View {
  @State private var manager = ObservableWebViewManager()
  @State private var themeColor: Color = .clear
  
  init() {
    manager.load("https://demo-ai-reminders.vercel.app/")
    webViewConfig()
  }
  
  var body: some View {
    WebViewContainer(manager: manager)
      .navigationTitle(manager.pageTitle ?? "Blank Page")
      .themeColor(manager: manager, themeColor: $themeColor)
      .animateToolbarBackground(color: $themeColor)
      .toolbar(id: ToolbarIdentifier.editingtools.id) {
        CustomizableBrowserToolbar(manager: manager, themeColor: themeColor)
      }
  }
  
  func webViewConfig() {
    manager.webView.allowsBackForwardNavigationGestures = true
  }
}

#Preview {
  BrowserView()
}
