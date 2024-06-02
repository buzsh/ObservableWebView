//
//  WebViewModelContainer.swift
//  ObservableWebView
//
//  Created by Justin Bush on 6/2/24.
//

import SwiftUI

struct WebViewModelContainer: View {
  private var viewModel = WebViewModel()
  
  var body: some View {
    VStack {
      ObservableWebView(manager: viewModel.manager)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onChange(of: viewModel.manager.urlString) {
          observedUrlChange()
        }
      
      BottomNavigationView(manager: viewModel.manager)
    }
  }
  
  func observedUrlChange() {
    guard let urlString = viewModel.manager.urlString else { return }
    print("viewModel.manager.urlString: \(urlString)")
  }
}

#Preview {
  WebViewModelContainer()
    .frame(width: 400, height: 600)
}
