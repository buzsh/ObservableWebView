//
//  CustomizableBrowserToolbar.swift
//  ObservableWebView
//
//  Created by Justin Bush on 3/19/24.
//

import SwiftUI

struct CustomizableBrowserToolbar: ToolbarContent, CustomizableToolbarContent {
  let manager: ObservableWebViewManager
  @Binding var toolbarStringText: String
  
  var body: some CustomizableToolbarContent {
    ToolbarItem(id: "backButton", placement: .automatic) {
      ToolbarSymbolButton(title: "Back", symbol: .back, action: manager.goBack)
        .disabled(!manager.canGoBack)
    }
    
    ToolbarItem(id: "forwardButton", placement: .automatic) {
      ToolbarSymbolButton(title: "Forward", symbol: .forward, action: manager.goForward)
        .disabled(!manager.canGoForward)
    }
    
    ToolbarItem(id: "urlSearchBar", placement: .automatic) {
      TextField("Search or type URL", text: $toolbarStringText)
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .frame(minWidth: 150, maxWidth: 300)
        .onSubmit {
          manager.load(toolbarStringText)
        }
        .onChange(of: manager.urlString) {
          toolbarStringText = manager.urlString
        }
    }
  }
}


#Preview {
  ContentView()
    .frame(width: 400, height: 600)
}
