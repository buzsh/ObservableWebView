//
//  CustomizableBrowserToolbar.swift
//  ObservableWebView
//
//  Created by Justin Bush on 3/19/24.
//

import SwiftUI

enum CustomizableToolbarItem: String {
  case backButton, forwardButton, urlSearchBar
}

struct CustomizableBrowserToolbar: ToolbarContent, CustomizableToolbarContent {
  let manager: ObservableWebViewManager
  @Environment(\.windowProperties) private var windowProperties
  
  var body: some CustomizableToolbarContent {
    ToolbarItem(id: CustomizableToolbarItem.urlSearchBar.id, placement: .automatic) {
      UrlSearchBarTextField(manager: manager)
        .frame(width: calculateUrlSearchBarWidth(for: windowProperties.width))
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
