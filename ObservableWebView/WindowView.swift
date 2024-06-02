//
//  WindowView.swift
//  ObservableWebView
//
//  Created by Justin Bush on 6/2/24.
//

import SwiftUI

struct WindowView: View {
  @Environment(\.windowProperties) private var windowProperties
  
  var body: some View {
    GeometryReader { geometry in
      BrowserView()
        .onChange(of: geometry.size.width) {
          windowProperties.width = geometry.size.width
        }
        .onAppear {
          windowProperties.width = geometry.size.width
        }
    }
  }
}

#Preview {
  WindowView()
}
