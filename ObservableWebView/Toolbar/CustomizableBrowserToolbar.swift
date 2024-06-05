//
//  CustomizableBrowserToolbar.swift
//  ObservableWebView
//
//  Created by Justin Bush on 3/19/24.
//

import SwiftUI

enum ToolbarItemIdentifier: String {
  case spacer, urlSearchBar, backButton, forwardButton, refreshButton, bookmarkButton, shareButton, tabBarButton, tabGalleryButton
}

struct CustomizableBrowserToolbar: ToolbarContent, CustomizableToolbarContent {
  @Environment(\.windowProperties) private var windowProperties
  let manager: ObservableWebViewManager
  let themeColor: Color
  
  var body: some CustomizableToolbarContent {
    backButton
    forwardButton
    spacer
    urlSearchBarTextField
    refreshButton
    spacer
    bookmarkButton
    shareButton
    tabBarButton
      .defaultCustomization(.hidden)
    tabGalleryButton
  }
  
  var urlSearchBarTextField: some CustomizableToolbarContent {
    ToolbarItem(id: ToolbarItemIdentifier.urlSearchBar.id, placement: .automatic) {
      UrlSearchBar(manager: manager, themeColor: themeColor)
        .frame(width: windowProperties.urlSearchBarWidth)
    }
    .customizationBehavior(.reorderable)
  }
  
  @State private var canGoBack = false
  var backButton: some CustomizableToolbarContent {
    ToolbarItem(id: ToolbarItemIdentifier.backButton.id, placement: .automatic) {
      ToolbarSymbolButton(title: "Back", symbol: .back, action: manager.goBack)
        .disabled(!canGoBack)
        .animateOnChange(of: manager.canGoBack, with: $canGoBack)
    }
  }
  
  @State private var canGoForward = false
  var forwardButton: some CustomizableToolbarContent {
    ToolbarItem(id: ToolbarItemIdentifier.forwardButton.id, placement: .automatic) {
      ToolbarSymbolButton(title: "Forward", symbol: .forward, action: manager.goForward)
        .disabled(!canGoForward)
        .animateOnChange(of: manager.canGoForward, with: $canGoForward)
    }
  }
  
  var refreshButton: some CustomizableToolbarContent {
    ToolbarItem(id: ToolbarItemIdentifier.refreshButton.id, placement: .automatic) {
      ToolbarSymbolButton(title: "Refresh", symbol: .refresh, action: manager.reload)
        .disabled(manager.urlString == nil)
        .onLongPressGesture(perform: {
          manager.forceReload()
        })
    }
  }
  
  @State private var canBookmark = false
  var bookmarkButton: some CustomizableToolbarContent {
    ToolbarItem(id: ToolbarItemIdentifier.bookmarkButton.id, placement: .automatic) {
      ToolbarSymbolButton(title: "Bookmark", symbol: .star, action: { print("BOOKMARK") })
        .disabled(!canBookmark)
        .animateOnChange(of: manager.urlString != nil, with: $canBookmark)
    }
  }
  
  @State private var canShare = false
  var shareButton: some CustomizableToolbarContent {
    ToolbarItem(id: ToolbarItemIdentifier.shareButton.id, placement: .automatic) {
      ToolbarSymbolButton(title: "Share", symbol: .share, action: { print("SHARE") })
        .disabled(!canShare)
        .animateOnChange(of: manager.urlString != nil, with: $canShare)
    }
  }
  
  var tabBarButton: some CustomizableToolbarContent {
    ToolbarItem(id: ToolbarItemIdentifier.tabBarButton.id, placement: .automatic) {
      ToolbarSymbolButton(title: "Toggle Tabs", symbol: .tabBar, action: {
        KeyWindow.toggleTabBar()
      })
    }
  }
  
  var tabGalleryButton: some CustomizableToolbarContent {
    ToolbarItem(id: ToolbarItemIdentifier.tabGalleryButton.id, placement: .automatic) {
      ToolbarSymbolButton(title: "Tab Gallery", symbol: .tabGallery, action: {
        KeyWindow.toggleTabOverview()
      })
    }
  }
  
  var spacer: some CustomizableToolbarContent {
    ToolbarItem(id: ToolbarItemIdentifier.spacer.id, placement: .automatic) {
      Spacer()
    }
  }
}

#Preview {
  BrowserView()
    .frame(width: 400, height: 600)
}
