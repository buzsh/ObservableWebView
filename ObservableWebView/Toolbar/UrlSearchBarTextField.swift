//
//  UrlSearchBarTextField.swift
//  ObservableWebView
//
//  Created by Justin Bush on 3/19/24.
//

import SwiftUI

struct UrlSearchBarTextField: View {
  let manager: ObservableWebViewManager
  @State private var text: String = ""
  
  var body: some View {
    TextField("Search or type URL", text: $text)
      .textFieldStyle(RoundedBorderTextFieldStyle())
      .foregroundStyle(.primary)
      .font(.system(size: 14, weight: .regular, design: .rounded))
      .onSubmit {
        manager.load(text)
      }
      .onChange(of: manager.urlString) {
        observedUrlChange()
      }
  }
  
  func observedUrlChange() {
    guard let urlString = manager.urlString else { return }
    text = urlString
  }
}


#Preview {
  ContentView()
    .frame(width: 400, height: 600)
}
