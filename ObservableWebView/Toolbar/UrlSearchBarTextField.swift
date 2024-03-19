//
//  UrlSearchBarTextField.swift
//  ObservableWebView
//
//  Created by Justin Bush on 3/19/24.
//

import SwiftUI

struct UrlSearchBarTextField: View {
  @Environment(\.windowProperties) private var windowProperties
  let manager: ObservableWebViewManager
  @State private var text: String = ""
  @State private var showTextField: Bool = false
  
  var body: some View {
    ZStack {
      if showTextField {
        TextField("Search or type URL", text: $text)
          .textFieldStyle(.plain)
          .foregroundStyle(.primary)
          .font(.system(size: 14, weight: .regular, design: .rounded))
          .onSubmit {
            manager.load(text)
          }
          .urlBarStyle(themeColor: manager.themeColor, width: windowProperties.width)
      } else {
        Text(prettyUrl(from: manager.urlString))
          .onTapGesture { showTextField = true }
          .urlBarStyle(themeColor: manager.themeColor, width: windowProperties.width)
      }
    }
    .onChange(of: manager.urlString) {
      observedUrlChange()
    }
    .onChange(of: showTextField) {
      if showTextField {
        text = manager.urlString ?? ""
      }
    }
  }
  
  func observedUrlChange() {
    showTextField = false
    text = prettyUrl(from: manager.urlString)
  }
  
  func prettyUrl(from urlString: String?) -> String {
    guard let urlString = urlString, let url = URL(string: urlString), let host = url.host else {
      return ""
    }
    return host.replacingOccurrences(of: "www.", with: "")
  }
}


#Preview {
  ContentView()
    .frame(width: 600, height: 600)
    .navigationTitle("")
}


struct UrlBarStyleModifier: ViewModifier {
  let themeColor: Color
  var width: CGFloat
  @State private var borderColor: Color = .secondary.opacity(0.3)
  
  func body(content: Content) -> some View {
    content
      .padding(EdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 12))
      .overlay(
        RoundedRectangle(cornerRadius: 8)
          .stroke(borderColor, lineWidth: 1)
          .frame(width: calculateUrlSearchBarWidth(for: width))
      )
      .frame(width: calculateUrlSearchBarWidth(for: width))
      .onAppear {
        updateBorderColorWithAnimation()
      }
      .onChange(of: themeColor) {
        updateBorderColorWithAnimation()
      }
  }
  
  private func updateBorderColorWithAnimation() {
    withAnimation {
      borderColor = themeColor == .clear ? .secondary.opacity(0.3) : .secondary
    }
  }
  
  private func calculateUrlSearchBarWidth(for availableWidth: CGFloat) -> CGFloat {
    let minWidth: CGFloat = 240
    let maxWidth: CGFloat = 800
    let adaptiveWidth = availableWidth * 0.4
    
    return min(maxWidth, max(minWidth, adaptiveWidth))
  }
}

extension View {
  func urlBarStyle(themeColor: Color, width: CGFloat) -> some View {
    self.modifier(UrlBarStyleModifier(themeColor: themeColor, width: width))
  }
}
