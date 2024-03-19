//
//  ContentView.swift
//  ObservableWebView
//
//  Created by Justin Bush on 3/15/24.
//

import SwiftUI

struct ContentView: View {
  @State var webViewManager = ObservableWebViewManager()
  @State private var webContentThemeColor: Color = .clear
  @State private var toolbarStringText = ""
  
  var body: some View {
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
        Button("Load Wikipedia") {
          webViewManager.load("https://www.wikipedia.org")
        }
        Button("Load Apple") {
          webViewManager.load("https://apple.com")
        }
        Button("Theme Site") {
          webViewManager.load("https://scinfu.github.io/SwiftSoup/")
        }
        Spacer()
      }
      .padding(.bottom, 8)
    }
    .toolbar(id: CustomizableToolbar.editingtools.id) {
      CustomizableBrowserToolbar(manager: webViewManager, toolbarStringText: $toolbarStringText)
    }
    .toolbarBackground(webContentThemeColor, for: .windowToolbar)
    .navigationTitle("")
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
      Task { await updateWebTheme() }
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

extension ContentView {
  @MainActor
  private func updateWebTheme() async {
    let themeColorScript = "document.querySelector('meta[name=\\\"theme-color\\\"]').getAttribute('content');"
    
    do {
      if let themeColorString = try await webViewManager.webView.evaluateJavaScript(themeColorScript) as? String,
         let themeColor = PlatformColor(hex: themeColorString) {
        updateWebContentThemeColor(to: Color(themeColor))
      }
    } catch {
      updateWebContentThemeColor(to: .clear)
    }
  }
  
  func updateWebContentThemeColor(to color: Color) {
    withAnimation {
      webContentThemeColor = color
    }
  }
}
