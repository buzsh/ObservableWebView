//
//  ContentView.swift
//  ObservableWebView
//
//  Created by Justin Bush on 3/15/24.
//

import SwiftUI

struct ContentView: View {
  @State var webViewManager = WebViewManager()
  
  var body: some View {
    VStack {
      ObservableWebView(webViewManager: webViewManager)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onChange(of: webViewManager.urlString) {
          print("onChange of url: \(webViewManager.urlString)")
        }
      
      Button("Load Another Page") {
        webViewManager.urlString = "https://www.wikipedia.org"
      }
    }
  }
}

#Preview {
  ContentView()
}
