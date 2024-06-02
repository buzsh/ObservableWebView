//
//  WebViewContainer.swift
//  ObservableWebView
//
//  Created by Justin Bush on 3/15/24.
//

import SwiftUI
import WebKit

struct WebViewContainer: View {
  let manager: ObservableWebViewManager
  
  var body: some View {
    VStack {
      ObservableWebView(manager: manager)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onChange(of: manager.urlString) {
          observedUrlChange()
        }
        .scriptMessageHandler("copilotMessageProcessed", manager: manager) { message in
          print("Message processed: \(message.body)")
        }
      BottomNavigationView(manager: manager)
    }
  }
  
  func observedUrlChange() {
    guard let urlString = manager.urlString else { return }
    print("manager.urlString: \(urlString)")
  }
  
}

#Preview {
  BrowserView()
    .frame(width: 400, height: 600)
}

