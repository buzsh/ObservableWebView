//
//  ProgressViewStyles.swift
//  ObservableWebView
//
//  Created by Justin Bush on 3/28/24.
//

import SwiftUI

struct LinearTransparentProgressViewStyle: ProgressViewStyle {
  func makeBody(configuration: Configuration) -> some View {
    ZStack {
      RoundedRectangle(cornerRadius: 8.0)
        .fill(Color.clear)
        .frame(height: 2)
      
      GeometryReader { geometry in
        RoundedRectangle(cornerRadius: 8.0)
          .fill(Color.accentColor)
          .frame(width: geometry.size.width * CGFloat(configuration.fractionCompleted ?? 0))
          .animation(.linear, value: configuration.fractionCompleted ?? 0)
      }
    }
    .frame(height: 2)
    .padding(.bottom, 1)
  }
}


struct CenteredTransparentProgressViewStyle: ProgressViewStyle {
  func makeBody(configuration: Configuration) -> some View {
    GeometryReader { geometry in
      ZStack(alignment: .bottomLeading) {
        RoundedRectangle(cornerRadius: 8.0)
          .fill(Color.accentColor)
          .frame(width: geometry.size.width * CGFloat(configuration.fractionCompleted ?? 0), height: 2)
          .animation(.linear, value: configuration.fractionCompleted ?? 0)
      }
      .frame(width: geometry.size.width, height: 2)
    }
  }
}
