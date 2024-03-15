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
  
  var body: some View {
    VStack {
      
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
    .toolbar {
      // Does work
      NavigationToolbarContent(manager: webViewManager, canGoBack: webViewManager.canGoBack, canGoForward: webViewManager.canGoForward)
      // Doesn't work
      TestNavigationToolbarContent(manager: webViewManager)
    }
    .toolbarBackground(webContentThemeColor, for: .windowToolbar)
    .navigationTitle("")
  }
  
  func observedUrlChange() {
    print("webViewManager.urlString: \(webViewManager.urlString)")
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
  
  @State private var toolbarStringText = ""
  
  private var browserToolbar: some ToolbarContent {
    ToolbarItemGroup(placement: .navigation, content: {
      ToolbarSymbolButton(title: "Back", symbol: .back, action: {
        webViewManager.goBack()
      })
      .disabled(webViewManager.canGoBack == false)
      
      ToolbarSymbolButton(title: "Forward", symbol: .forward, action: {
        webViewManager.webView.goForward()
      })
      .disabled(webViewManager.webView.canGoForward == false)
      
      TextField("Search or type URL", text: $toolbarStringText, onCommit: {
        webViewManager.load(toolbarStringText)
      })
      .textFieldStyle(RoundedBorderTextFieldStyle())
      .frame(minWidth: 150, maxWidth: 1000)
      .onChange(of: webViewManager.urlString) {
        toolbarStringText = webViewManager.urlString
      }
      
    })
  }
}

import SwiftUI

struct NavigationToolbarContent: ToolbarContent {
  let manager: ObservableWebViewManager
  let canGoBack: Bool
  let canGoForward: Bool
  
  var body: some ToolbarContent {
    ToolbarItemGroup(placement: .automatic) {
      ToolbarSymbolButton(title: "Back", symbol: .back, action: manager.goBack)
        .disabled(canGoBack == false)
      ToolbarSymbolButton(title: "Forward", symbol: .forward, action: manager.goForward)
        .disabled(canGoForward == false)
    }
  }
}

struct TestNavigationToolbarContent: ToolbarContent {
  let manager: ObservableWebViewManager
  @State private var canGoBack = false
  @State private var canGoForward = false
  
  init(manager: ObservableWebViewManager) {
    self.manager = manager
    
    observeBackState()
  }
  
  func observeBackState() {
    withObservationTracking {
      print("canGoBack: \(manager.webView.canGoBack)")
      canGoBack = manager.webView.canGoBack
    } onChange: {
      Task { observeBackState() }
    }
  }
  
  var body: some ToolbarContent {
    ToolbarItemGroup(placement: .automatic) {
      ToolbarSymbolButton(title: "Back", symbol: .back, action: manager.goBack)
        .disabled(manager.webView.canGoBack == false)
      ToolbarSymbolButton(title: "Forward", symbol: .forward, action: manager.goForward)
        .disabled(canGoForward == false)
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
