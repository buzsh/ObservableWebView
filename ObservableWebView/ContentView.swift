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
        .onChange(of: webViewManager.loadState) { newState, oldState in
          switch newState {
          case .isLoading:
            print("webView is loading")
          case .finishedLoading:
            print("webView finished loading")
          case .error(let error):
            print("webView encountered an error: \(error.localizedDescription)")
          default:
            break
          }
        }
      HStack {
        Spacer()
        Button("Load Wikipedia") {
          webViewManager.urlString = "https://www.wikipedia.org"
        }
        Button("Load Apple") {
          webViewManager.urlString = "https://apple.com"
        }
      }
    }
  }
}

#Preview {
  ContentView()
}
