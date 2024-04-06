//
//  ContentView.swift
//  ObservableWebView
//
//  Created by Justin Bush on 3/15/24.
//

import SwiftUI

struct ContentView: View {
  @State private var webViewManager = ObservableWebViewManager()
  @Environment(\.windowProperties) private var windowProperties
  @State private var toolbarBackgroundColor: Color = .clear
  
  var body: some View {
    GeometryReader { geometry in
      VStack {
        ObservableWebView(manager: webViewManager)
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .onAppear {
            webViewManager.webView.allowsBackForwardNavigationGestures = true
            webViewManager.load("https://duckduckgo.com")
          }
          .onChange(of: webViewManager.urlString) {
            observedUrlChange()
          }
          .onChange(of: webViewManager.progress) {
            observedProgressChange()
          }
          .onChange(of: webViewManager.loadState) { oldState, newState in
            observedLoadStateChange(from: oldState, to: newState)
          }
        
        HStack {
          Spacer()
          Button("Wikipedia") {
            webViewManager.load("https://www.wikipedia.org")
          }
          Button("Apple") {
            webViewManager.load("https://apple.com")
          }
          Button("Site with Theme") {
            webViewManager.load("https://scinfu.github.io/SwiftSoup/")
          }
          Spacer()
        }
        .padding(.bottom, 8)
        
      }
      .onChange(of: geometry.size.width) {
        windowProperties.width = geometry.size.width
      }
    }
    .toolbar(id: ToolbarIdentifier.editingtools.id) {
      CustomizableBrowserToolbar(manager: webViewManager)
    }
    .toolbarBackground(toolbarBackgroundColor, for: .windowToolbar)
    .animateOnChange(of: webViewManager.themeColor, with: $toolbarBackgroundColor)
  }
  
  func observedUrlChange() {
    guard let urlString = webViewManager.urlString else { return }
    print("webViewManager.urlString: \(urlString)")
  }
  
  func observedProgressChange() {
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
  ContentView()
    .frame(width: 400, height: 600)
}
