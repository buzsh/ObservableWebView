//
//  AnimateToolbarBackgroundColor.swift
//  ObservableWebView
//
//  Created by Justin Bush on 6/2/24.
//

import SwiftUI

struct AnimateToolbarBackgroundModifier: ViewModifier {
  @State private var toolbarBackgroundColor: Color = .clear
  @Binding var color: Color

  func body(content: Content) -> some View {
    content
      .toolbarBackground(toolbarBackgroundColor, for: .windowToolbar)
      .onChange(of: color) {
        withAnimation {
          toolbarBackgroundColor = color
        }
      }
  }
}

extension View {
  func animateToolbarBackground(color: Binding<Color>) -> some View {
    self.modifier(AnimateToolbarBackgroundModifier(color: color))
  }
}
