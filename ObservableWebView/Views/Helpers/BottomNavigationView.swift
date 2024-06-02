//
//  BottomNavigationView.swift
//  ObservableWebView
//
//  Created by Justin Bush on 6/2/24.
//

import SwiftUI

struct BottomNavigationView: View {
  var manager: ObservableWebViewManager
  
  var body: some View {
    HStack {
      Spacer()
      Button("Search") {
        manager.load("https://vessium.vercel.app/")
      }
      Button("Reminders") {
        manager.load("https://demo-ai-reminders.vercel.app/")
      }
      Button("Spreadsheets") {
        manager.load("https://demo-ai-spreadsheet.vercel.app/")
      }
      Button("Theme") {
        manager.load("https://scinfu.github.io/SwiftSoup/")
      }
      Button("Send Copilot Test") {
        manager.webView.evaluateJavaScript("sendMessageToCopilot(`i need to walk my dog 3 times today`)")
      }
      Spacer()
    }
    .padding(.bottom, 8)
  }
}


#Preview {
  BottomNavigationView(manager: ObservableWebViewManager())
}
