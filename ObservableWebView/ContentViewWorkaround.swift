//
//  ContentViewWorkaround.swift
//  ObservableWebView
//
//  Created by Justin Bush on 4/6/24.
//

import SwiftUI

struct ContentViewWorkaround: View {
  @State private var webViewManager: ObservableWebViewManager?
  @Environment(\.windowProperties) private var windowProperties
  @State private var toolbarBackgroundColor: Color = .clear
  
  var body: some View {
    GeometryReader { geometry in
      VStack {
        if let webViewManager = webViewManager {
          ObservableWebView(manager: webViewManager)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onChange(of: webViewManager.urlString) {
              observedUrlChange()
            }
            .onChange(of: webViewManager.progress) {
              observedProgressChange()
            }
            .onChange(of: webViewManager.loadState) { oldState, newState in
              observedLoadStateChange(from: oldState, to: newState)
            }
        }
        
        HStack {
          Spacer()
          Button("Wikipedia") {
            if let webViewManager = webViewManager {
              webViewManager.load("https://www.wikipedia.org")
            }
          }
          Button("Apple") {
            if let webViewManager = webViewManager {
              webViewManager.load("https://apple.com")
            }
          }
          Button("Site with Theme") {
            if let webViewManager = webViewManager {
              webViewManager.load("https://scinfu.github.io/SwiftSoup/")
            }
          }
          Spacer()
        }
        .padding(.bottom, 8)
        
      }
      .onChange(of: geometry.size.width) {
        windowProperties.width = geometry.size.width
      }
    }
    .onAppear {
      webViewManager = ObservableWebViewManager()
      webViewManager?.load("https://duckduckgo.com")
    }
    .toolbar(id: ToolbarIdentifier.editingtools.id) {
      if let webViewManager = webViewManager {
        CustomizableBrowserToolbar(manager: webViewManager)
      }
    }
    .toolbarBackground(toolbarBackgroundColor, for: .windowToolbar)
    .animateOnChange(of: webViewManager?.themeColor ?? .clear, with: $toolbarBackgroundColor)
  }
  
  func observedUrlChange() {
    guard let webViewManager = webViewManager,
            let urlString = webViewManager.urlString
    else { return }
    print("webViewManager.urlString: \(urlString)")
  }
  
  func observedProgressChange() {
    guard let webViewManager = webViewManager else { return }
    print("webViewManager.progress: \(webViewManager.progress)")
  }
  
  func observedLoadStateChange(from oldState: ObservableWebViewLoadState, to newState: ObservableWebViewLoadState) {
    print("webViewManager.loadState from: \(oldState), to: \(newState)")
    switch newState {
    case .isLoading:
      print("webView is loading")
      // quick fade-in progress bar
    case .isFinished:
      print("webView is finished loading")
      // stanadrd fade-out progress bar
    case .error(let error):
      print("webView encountered an error: \(error.localizedDescription)")
    default:
      break
    }
  }
}

#Preview {
  ContentViewWorkaround()
    .frame(width: 400, height: 600)
}
