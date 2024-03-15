//
//  ObservableWebViewLoadState.swift
//  ObservableWebView
//
//  Created by Justin Bush on 3/15/24.
//

import Foundation

enum ObservableWebViewLoadState {
  case idle
  case isLoading
  case isFinished
  case error(Error)
}

extension ObservableWebViewLoadState: Equatable {
  static func ==(lhs: ObservableWebViewLoadState, rhs: ObservableWebViewLoadState) -> Bool {
    switch (lhs, rhs) {
    case (.idle, .idle), (.isLoading, .isLoading), (.isFinished, .isFinished):
      return true
    case let (.error(lhsError), .error(rhsError)):
      return type(of: lhsError) == type(of: rhsError)
    default:
      return false
    }
  }
}
