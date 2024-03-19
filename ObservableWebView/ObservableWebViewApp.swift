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
      ContentView()
    }
    .commands {
      ToolbarCommands()
    }
  }
}
