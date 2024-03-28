//
//  WindowPropertiesExtension.swift
//  ObservableWebView
//
//  Created by Justin Bush on 3/28/24.
//

import Foundation

extension WindowProperties {
  var urlSearchBarWidth: CGFloat {
    calculateUrlSearchBarWidth()
  }
  
  private func calculateUrlSearchBarWidth() -> CGFloat {
    let minWidth: CGFloat = 240
    let maxWidth: CGFloat = 800
    let adaptiveWidth = width * 0.4
    
    return min(maxWidth, max(minWidth, adaptiveWidth))
  }
}
