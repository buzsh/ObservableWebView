//
//  UrlSearchBar.swift
//  ObservableWebView
//
//  Created by Justin Bush on 3/28/24.
//

import SwiftUI

extension WindowProperties {
  var urlSearchBarWidth: CGFloat {
    calculateUrlSearchBarWidth()
  }
  
  private func calculateUrlSearchBarWidth() -> CGFloat {
    let minWidth: CGFloat = 240
    let maxWidth: CGFloat = 800
    let adaptiveWidth = width * 0.4
    
    return min(maxWidth, max(minWidth, adaptiveWidth))
  }
}

struct UrlSearchBar: View {
  @Environment(\.windowProperties) private var windowProperties
  let manager: ObservableWebViewManager
  @State private var text: String = ""
  @State private var isEditing: Bool = false
  @State private var showTextField: Bool = false
  @State private var progressBarColor: Color = .accentColor
  
  var body: some View {
    ZStack(alignment: .bottom) {
      if showTextField {
        HStack {
          
          Image(systemName: "magnifyingglass")
            .foregroundColor(.secondary)
            .onTapGesture {
              showTextField = false
            }
          
          UrlSearchBarTextField(text: $text, isEditing: $isEditing) {
            manager.load(text)
          }
          .textFieldStyle(.plain)
          
          if !text.isEmpty {
            Image(systemName: "xmark.circle.fill")
              .foregroundColor(.secondary)
              .scaleEffect(0.9)
              .onTapGesture {
                text = ""
              }
          }
        }
        .urlBarStyle(width: windowProperties.urlSearchBarWidth, themeColor: manager.themeColor, isEditing: isEditing)
        
      } else {
        HStack {
          if manager.isSecurePage {
            Image(systemName: "lock.fill")
              .foregroundColor(.secondary)
          } else {
            Image(systemName: "lock.slash.fill")
              .foregroundColor(.secondary)
          }
          
          Spacer()
          
          if let favicon = manager.favicon {
            favicon
              .resizable()
              .foregroundColor(.secondary)
              .frame(width: 18, height: 18)
          }
          
          Text(prettyUrl(from: manager.urlString))
            .onTapGesture { showTextField = true }
          
          Spacer()
        }
        .urlBarStyle(width: windowProperties.urlSearchBarWidth, themeColor: manager.themeColor)
      }
      
      ProgressView(value: manager.progress, total: 100)
        .progressViewStyle(LinearTransparentProgressViewStyle(tintColor: progressBarColor, horizontalPadding: 5))
        .frame(height: 2)
        .frame(width: windowProperties.urlSearchBarWidth)
        .opacity(manager.loadState == .isLoading ? 1 : 0)
        .padding(.top)
    }
    .foregroundStyle(.primary)
    .font(.system(size: 14, weight: .regular, design: .rounded))
    .onChange(of: manager.urlString ?? "") { oldUrl, newUrl in
      observedUrlChange(from: oldUrl, to: newUrl)
    }
    .onChange(of: showTextField) {
      if showTextField {
        text = manager.urlString ?? ""
      }
    }
    .onChange(of: manager.themeColor) {
      progressBarColor = manager.themeColor == .clear ? .accentColor : .primary
    }
    .mask(
      RoundedRectangle(cornerRadius: 8)
        .frame(width: windowProperties.urlSearchBarWidth)
    )
  }
  
  func observedUrlChange(from oldUrlString: String, to newUrlString: String) {
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


#Preview("ContentView") {
  ContentView()
    .frame(width: 400, height: 600)
}


struct UrlBarStyleModifier: ViewModifier {
  let width: CGFloat
  let themeColor: Color
  let isEditing: Bool
  @State private var borderColor: Color = .secondary.opacity(0.3)
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
        borderColor = themeColor == .clear ? .accentColor : .primary
        borderWidth = 3
      } else {
        borderColor = themeColor == .clear ? .secondary.opacity(0.3) : .secondary
        borderWidth = 1
      }
    }
  }
}

extension View {
  func urlBarStyle(width: CGFloat, themeColor: Color, isEditing: Bool = false) -> some View {
    self.modifier(UrlBarStyleModifier(width: width, themeColor: themeColor, isEditing: isEditing))
  }
}
