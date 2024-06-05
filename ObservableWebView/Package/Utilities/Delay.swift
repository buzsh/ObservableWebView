//
//  Delay.swift
//  ObservableWebView
//
//  Created by Justin Bush on 6/2/24.
//

import Foundation

extension ObservableWebViewManager {
  struct Delay {
    /// Perform an action after a set amount of seconds.
    static func by(_ seconds: Double, closure: @escaping () -> Void) {
      Timer.scheduledTimer(withTimeInterval: seconds, repeats: false) { _ in
        closure()
      }
    }
  }
}
