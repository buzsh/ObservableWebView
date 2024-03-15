//
//  ContentView.swift
//  ObservableWebView
//
//  Created by Justin Bush on 3/15/24.
//

import SwiftUI

struct ContentView: View {
  @State var webViewManager = ObservableWebViewManager()
  
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
        Spacer()
      }
      .padding(.bottom, 8)
      
    }
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
    case .isFinished: 
      print("webView finished loading")
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
