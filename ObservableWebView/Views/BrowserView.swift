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
  @State private var toolbarBackground: Color = .clear
  
  init() {
    manager.load("https://duckduckgo.com")
  }
  
  var body: some View {
    WebViewContainer(manager: manager)
      .navigationTitle(manager.pageTitle ?? "Blank Page")
      .toolbar(id: ToolbarIdentifier.editingtools.id) {
        CustomizableBrowserToolbar(manager: manager, themeColor: themeColor)
      }
      .toolbarBackground(toolbarBackground, for: .windowToolbar)
      .animateOnChange(of: themeColor, with: $toolbarBackground)
      .themeColor(manager: manager, themeColor: $themeColor)
  }
}

#Preview {
  BrowserView()
}
