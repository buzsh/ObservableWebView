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
      //ContentView()
      ContentViewWorkaround()
        .environment(WindowProperties())
    }
    .windowStyle(.hiddenTitleBar)
    .windowToolbarStyle(.unified(showsTitle: false))
    .commands {
      ToolbarCommands()
    }
  }
}

extension View {
  func animateOnChange<T: Equatable>(of value: T, with state: Binding<T>) -> some View {
    self.onChange(of: value) {
      withAnimation {
        state.wrappedValue = value
      }
    }
  }
}
