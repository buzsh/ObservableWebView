//
//  CustomizableBrowserToolbar.swift
//  ObservableWebView
//
//  Created by Justin Bush on 3/19/24.
//

import SwiftUI

enum ToolbarItemIdentifier: String {
  case backButton, forwardButton, urlSearchBar
}

struct CustomizableBrowserToolbar: ToolbarContent, CustomizableToolbarContent {
  let manager: ObservableWebViewManager
  @Environment(\.windowProperties) private var windowProperties
  
  var body: some CustomizableToolbarContent {
    spacer
    backButton
    urlSearchBarTextField
    forwardButton
    spacer
  }
  
  var urlSearchBarTextField: some CustomizableToolbarContent {
    ToolbarItem(id: ToolbarItemIdentifier.urlSearchBar.id, placement: .automatic) {
      UrlSearchBarTextField(manager: manager)
        .frame(width: calculateUrlSearchBarWidth(for: windowProperties.width))
    }
    .customizationBehavior(.reorderable)
  }
  
  var backButton: some CustomizableToolbarContent {
    ToolbarItem(id: ToolbarItemIdentifier.backButton.id, placement: .automatic) {
      ToolbarSymbolButton(title: "Back", symbol: .back, action: manager.goBack)
        .disabled(!manager.canGoBack)
    }
  }
  
  var forwardButton: some CustomizableToolbarContent {
    ToolbarItem(id: ToolbarItemIdentifier.forwardButton.id, placement: .automatic) {
      ToolbarSymbolButton(title: "Forward", symbol: .forward, action: manager.goForward)
        .disabled(!manager.canGoForward)
    }
  }
  
  var spacer: some CustomizableToolbarContent {
    ToolbarItem(id: "spacer", placement: .automatic) {
      Spacer()
    }
  }
}


#Preview {
  ContentView()
    .frame(width: 400, height: 600)
}


extension CustomizableBrowserToolbar {
  fileprivate func calculateUrlSearchBarWidth(for availableWidth: CGFloat) -> CGFloat {
    let minWidth: CGFloat = 240
    let maxWidth: CGFloat = 800
    let adaptiveWidth = availableWidth * 0.4
    
    return min(maxWidth, max(minWidth, adaptiveWidth))
  }
}
