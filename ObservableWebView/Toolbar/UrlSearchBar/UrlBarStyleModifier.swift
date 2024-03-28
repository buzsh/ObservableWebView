//
//  UrlBarStyleModifier.swift
//  ObservableWebView
//
//  Created by Justin Bush on 3/28/24.
//

import SwiftUI

struct UrlBarStyleModifier: ViewModifier {
  let width: CGFloat
  let themeColor: Color
  let isEditing: Bool
  @State private var borderColor: Color = .secondary.opacity(0.5)
  @State private var borderWidth: CGFloat = 1
  
  func body(content: Content) -> some View {
    content
      .padding(EdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 12))
      .overlay(
        RoundedRectangle(cornerRadius: 8)
          .stroke(borderColor, lineWidth: borderWidth)
          .frame(width: width)
      )
      .frame(width: width)
      .onAppear {
        updateBorderColorWithAnimation()
      }
      .onChange(of: themeColor) {
        updateBorderColorWithAnimation()
      }
      .onChange(of: isEditing) {
        updateBorderColorWithAnimation()
      }
  }
  
  private func updateBorderColorWithAnimation() {
    withAnimation {
      if isEditing {
        borderWidth = 4
        borderColor = themeColor == .clear ? .accentColor : .primary
      } else {
        borderWidth = 1
        borderColor = themeColor == .clear ? .secondary.opacity(0.5) : .secondary
      }
    }
  }
}

extension View {
  func urlBarStyle(width: CGFloat, themeColor: Color, isEditing: Bool = false) -> some View {
    self.modifier(UrlBarStyleModifier(width: width, themeColor: themeColor, isEditing: isEditing))
  }
}
