//
//  BottomNavigationView.swift
//  ObservableWebView
//
//  Created by Justin Bush on 6/2/24.
//

import SwiftUI

struct BottomNavigationView: View {
  var manager: ObservableWebViewManager
  @State private var showingAlert = false
  @State private var javaScriptCode = ""
  
  var body: some View {
    HStack {
      Spacer()
      Button("Localhost") {
        manager.load("http://localhost:3000")
      }
      Button("Search") {
        manager.load("https://duckduckgo.com/")
      }
      Button("Theme") {
        manager.load("https://scinfu.github.io/SwiftSoup/")
      }
      Button("Execute JavaScript") {
        showingAlert = true
      }
      Spacer()
    }
    .padding(.bottom, 8)
    .alert("Execute JavaScript", isPresented: $showingAlert) {
      TextField("JavaScript Code", text: $javaScriptCode)
      Button("Execute") {
        manager.js(javaScriptCode)
      }
      Button("Cancel", role: .cancel) { }
    }
  }
}

#Preview {
  BottomNavigationView(manager: ObservableWebViewManager())
}
