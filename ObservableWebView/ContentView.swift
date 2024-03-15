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
          print("onChange of url: \(webViewManager.urlString)")
        }
        .onChange(of: webViewManager.loadState) { oldState, newState in
          loadStateChanged(from: oldState, to: newState)
        }
        .onChange(of: webViewManager.progress) {
          print("Progress: \(webViewManager.progress)%")
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
  
  func loadStateChanged(from oldState: ObservableWebViewLoadState, to newState: ObservableWebViewLoadState) {
    print("from \(oldState) to \(newState)")
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
