//
//  ObservableWebViewManager.swift
//  ObservableWebView
//
//  Created by Justin Bush on 3/15/24.
//

import SwiftUI
import WebKit
import Observation

enum ObservableWebViewLoadState {
  case idle
  case isLoading
  case finishedLoading
  case error(Error)
}

extension ObservableWebViewLoadState: Equatable {
  static func ==(lhs: ObservableWebViewLoadState, rhs: ObservableWebViewLoadState) -> Bool {
    switch (lhs, rhs) {
    case (.idle, .idle), (.isLoading, .isLoading), (.finishedLoading, .finishedLoading):
      return true
    case let (.error(lhsError), .error(rhsError)):
      return type(of: lhsError) == type(of: rhsError)
    default:
      return false
    }
  }
}

extension ObservableWebViewManager {
  private struct Constants {
    static let aboutBlank = "about:blank"
  }
}

@Observable
class ObservableWebViewManager: NSObject {
  private var webView: WKWebView = WKWebView()
  /// The current state of the WKWebView object.
  var loadState: ObservableWebViewLoadState = .idle
  
  var urlString: String {
    didSet {
      load(urlString)
    }
  }
  
  init(urlString: String = Constants.aboutBlank) {
    self.webView = WKWebView()
    self.urlString = urlString
    super.init()
    self.webView.navigationDelegate = self
    load(urlString)
  }
  
  private func load(_ urlString: String) {
    print("Loading URL:", urlString)
    let url = URL(string: urlString) ?? URL(string: Constants.aboutBlank)!
    let request = URLRequest(url: url)
    webView.load(request)
    loadState = .isLoading
  }
  
  func getWebView() -> WKWebView {
    return webView
  }
  
  /*
  func observeUrlStringChange() {
    withObservationTracking {
      // Access urlString to ensure it is being tracked for changes.
      _ = self.urlString
    } onChange: {
      // This is where you handle what happens when urlString changes.
      // For instance, reloading the webView with the new URL.
      self.load(self.urlString)
      print("URLString changed to: \(self.urlString)")
    }
  }
   */
}
