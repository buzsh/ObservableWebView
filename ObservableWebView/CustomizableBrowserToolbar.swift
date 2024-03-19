//
//  CustomizableBrowserToolbar.swift
//  ObservableWebView
//
//  Created by Justin Bush on 3/19/24.
//

import SwiftUI

enum CustomizableToolbarItem: String {
  case backButton, forwardButton, urlSearchBar
  
  var id: String {
    self.rawValue
  }
}

struct CustomizableBrowserToolbar: ToolbarContent, CustomizableToolbarContent {
  let manager: ObservableWebViewManager
  @Binding var toolbarStringText: String
  
  var body: some CustomizableToolbarContent {
    ToolbarItem(id: CustomizableToolbarItem.backButton.id, placement: .automatic) {
      ToolbarSymbolButton(title: "Back", symbol: .back, action: manager.goBack)
        .disabled(!manager.canGoBack)
    }
    
    ToolbarItem(id: CustomizableToolbarItem.forwardButton.id, placement: .automatic) {
      ToolbarSymbolButton(title: "Forward", symbol: .forward, action: manager.goForward)
        .disabled(!manager.canGoForward)
    }
    
    ToolbarItem(id: CustomizableToolbarItem.urlSearchBar.id, placement: .automatic) {
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
