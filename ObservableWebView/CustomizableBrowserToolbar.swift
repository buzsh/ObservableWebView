//
//  CustomizableBrowserToolbar.swift
//  ObservableWebView
//
//  Created by Justin Bush on 3/19/24.
//

import SwiftUI

enum CustomizableToolbar: String {
  case editingtools
  
  var id: String {
    self.rawValue
  }
}

enum CustomizableToolbarItem: String {
  case backButton, forwardButton, urlSearchBar
  
  var id: String {
    self.rawValue
  }
}

struct CustomizableBrowserToolbar: ToolbarContent, CustomizableToolbarContent {
  let manager: ObservableWebViewManager
  
  var body: some CustomizableToolbarContent {
    ToolbarItem(id: CustomizableToolbarItem.urlSearchBar.id, placement: .automatic) {
      UrlSearchBarTextField(manager: manager)
    }
    .customizationBehavior(.reorderable)
    
    ToolbarItem(id: CustomizableToolbarItem.backButton.id, placement: .automatic) {
      ToolbarSymbolButton(title: "Back", symbol: .back, action: manager.goBack)
        .disabled(!manager.canGoBack)
    }
    
    ToolbarItem(id: CustomizableToolbarItem.forwardButton.id, placement: .automatic) {
      ToolbarSymbolButton(title: "Forward", symbol: .forward, action: manager.goForward)
        .disabled(!manager.canGoForward)
    }
  }
}

struct UrlSearchBarTextField: View {
  let manager: ObservableWebViewManager
  @State private var text: String = ""
  
  var body: some View {
    TextField("Search or type URL", text: $text)
      .textFieldStyle(RoundedBorderTextFieldStyle())
      .frame(minWidth: 150, maxWidth: 300)
      .onSubmit {
        manager.load(text)
      }
      .onChange(of: manager.urlString) {
        observedUrlChange()
      }
  }
  
  func observedUrlChange() {
    guard let urlString = manager.urlString else { return }
    text = urlString
  }
}


#Preview {
  ContentView()
    .frame(width: 400, height: 600)
}
