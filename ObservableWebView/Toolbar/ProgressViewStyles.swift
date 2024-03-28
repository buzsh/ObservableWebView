//
//  ProgressViewStyles.swift
//  ObservableWebView
//
//  Created by Justin Bush on 3/28/24.
//

import SwiftUI

struct LinearTransparentProgressViewStyle: ProgressViewStyle {
  var tintColor: Color
  var horizontalPadding: CGFloat
  
  init(tintColor: Color = .accentColor, horizontalPadding: CGFloat = 0) {
    self.tintColor = tintColor
    self.horizontalPadding = horizontalPadding
  }
  
  func makeBody(configuration: Configuration) -> some View {
    ZStack {
      RoundedRectangle(cornerRadius: 8.0)
        .fill(Color.clear)
        .frame(height: 2)
      
      GeometryReader { geometry in
        RoundedRectangle(cornerRadius: 8.0)
          .fill(tintColor)
          .frame(width: (geometry.size.width - (horizontalPadding * 2)) * CGFloat(configuration.fractionCompleted ?? 0))
          .animation(.linear, value: configuration.fractionCompleted ?? 0)
      }
    }
    .frame(height: 2)
    .padding(.bottom, 1)
    .padding(.horizontal, horizontalPadding)
  }
}

struct CenteredTransparentProgressViewStyle: ProgressViewStyle {
  var tintColor: Color
  var horizontalPadding: CGFloat
  
  init(tintColor: Color = .accentColor, horizontalPadding: CGFloat = 0) {
    self.tintColor = tintColor
    self.horizontalPadding = horizontalPadding
  }
  
  func makeBody(configuration: Configuration) -> some View {
    GeometryReader { geometry in
      ZStack(alignment: .bottomLeading) {
        RoundedRectangle(cornerRadius: 8.0)
          .frame(width: max(0, (geometry.size.width - (horizontalPadding * 2)) * CGFloat(configuration.fractionCompleted ?? 0)), height: 2)
          .animation(.linear, value: configuration.fractionCompleted ?? 0)
      }
      .padding(.horizontal, horizontalPadding)
      .frame(width: geometry.size.width, height: 2)
    }
  }
}
