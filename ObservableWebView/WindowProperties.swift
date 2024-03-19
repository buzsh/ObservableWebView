//
//  WindowProperties.swift
//  ObservableWebView
//
//  Created by Justin Bush on 3/19/24.
//

import SwiftUI

@Observable
class WindowProperties {
  var width: CGFloat = 0
}

struct WindowPropertiesKey: EnvironmentKey {
  static let defaultValue: WindowProperties = WindowProperties()
}

extension EnvironmentValues {
  var windowProperties: WindowProperties {
    get { self[WindowPropertiesKey.self] }
    set { self[WindowPropertiesKey.self] = newValue }
  }
}
