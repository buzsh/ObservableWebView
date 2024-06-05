//
//  ObservableWebViewApp.swift
//  ObservableWebView
//
//  Created by Justin Bush on 3/15/24.
//

import SwiftUI

@main
struct ObservableWebViewApp: App {
  @Environment(\.windowProperties) private var windowProperties
  
  var body: some Scene {
    WindowGroup {
      WindowView()
        .environment(windowProperties)
    }
    .windowStyle(.hiddenTitleBar)
    .windowToolbarStyle(.unified(showsTitle: false))
    .commands {
      ToolbarCommands()
    }
  }
}
