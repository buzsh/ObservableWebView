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
  @Environment(WindowProperties.self) private var windowProperties
  
  var body: some CustomizableToolbarContent {
    ToolbarItem(id: CustomizableToolbarItem.urlSearchBar.id, placement: .automatic) {
      UrlSearchBarTextField(manager: manager)
        .frame(minWidth: calculateTextFieldWidth(for: windowProperties.width), maxWidth: 800)
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

extension CustomizableBrowserToolbar {
  fileprivate func calculateTextFieldWidth(for availableWidth: CGFloat) -> CGFloat {
    let minWidth: CGFloat = 240
    let maxWidth: CGFloat = 800
    let adaptiveWidth = availableWidth * 0.4
    
    return min(maxWidth, max(minWidth, adaptiveWidth))
  }
}

struct UrlSearchBarTextField: View {
  let manager: ObservableWebViewManager
  @State private var text: String = ""
  
  var body: some View {
    TextField("Search or type URL", text: $text)
      .textFieldStyle(RoundedBorderTextFieldStyle())
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
