//
//  ObservableWebViewApp.swift
//  ObservableWebView
//
//  Created by Justin Bush on 3/15/24.
//

import SwiftUI

@main
struct ObservableWebViewApp: App {
  var body: some Scene {
    WindowGroup {
      BrowserTabView()
        .environment(WindowProperties())
    }
    .windowStyle(.hiddenTitleBar)
    .windowToolbarStyle(.unified(showsTitle: false))
    .commands {
      ToolbarCommands()
    }
  }
}
