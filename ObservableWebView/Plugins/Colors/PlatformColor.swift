//
//  PlatformColor.swift
//  ObservableWebView
//
//  Created by Justin Bush on 3/15/24.
//

import SwiftUI
#if os(iOS)
import UIKit
typealias PlatformColor = UIColor
#elseif os(macOS)
import AppKit
typealias PlatformColor = NSColor
#endif

extension PlatformColor {
  convenience init?(hex: String) {
    var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
    hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
    
    var rgb: UInt64 = 0
    
    guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }
    
    let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
    let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
    let blue = CGFloat(rgb & 0x0000FF) / 255.0
    
    self.init(red: red, green: green, blue: blue, alpha: 1.0)
  }
}


// Convert PlatformColor to SwiftUI's Color
func themeColor(fromHex hex: String) -> Color {
  if let platformColor = PlatformColor(hex: hex) {
    return Color(platformColor)
  } else {
    // Return a default color if hex conversion fails
    return Color.gray
  }
}
