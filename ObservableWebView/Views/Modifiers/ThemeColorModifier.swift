//
//  ThemeColorModifier.swift
//  ObservableWebView
//
//  Created by Justin Bush on 6/2/24.
//

import SwiftUI
import WebKit

struct ThemeColorModifier: ViewModifier {
  var manager: ObservableWebViewManager
  @Binding var themeColor: Color
  
  func body(content: Content) -> some View {
    content
      .onChange(of: manager.loadState) {
        Task { await updateWebViewContentThemeColor() }
      }
  }
  
  @MainActor
  private func updateWebViewContentThemeColor(canSetClearColor: Bool = true) async {
    let themeColorScript = "document.querySelector('meta[name=\\\"theme-color\\\"]').getAttribute('content');"
    do {
      if let themeColorString = try await manager.webView.evaluateJavaScript(themeColorScript) as? String,
         let PlatformThemeColor = PlatformColor(hex: themeColorString) {
        themeColor = Color(PlatformThemeColor)
      }
    } catch {
      if canSetClearColor {
        themeColor = Color.clear
      }
    }
  }
}

extension View {
  func themeColor(manager: ObservableWebViewManager, themeColor: Binding<Color>) -> some View {
    self.modifier(ThemeColorModifier(manager: manager, themeColor: themeColor))
  }
}
