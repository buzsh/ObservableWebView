//
//  WebViewManager.swift
//  ObservableWebView
//
//  Created by Justin Bush on 3/15/24.
//

import SwiftUI
import WebKit
import Observation

extension WebViewManager {
  private struct Constants {
    static let aboutBlank = "about:blank"
  }
}

enum WebViewLoadState {
  case idle
  case isLoading
  case finishedLoading
  case error(Error)
}

@Observable
class WebViewManager {
  private var webView: WKWebView = WKWebView()
  /// The current state of the WKWebView object.
  var loadState: WebViewLoadState = .idle
  
  var urlString: String {
    didSet {
      load(urlString)
    }
  }
  
  init(urlString: String = Constants.aboutBlank) {
    self.urlString = urlString
    load(urlString)
    observeURLStringChange()
  }
  
  private func load(_ urlString: String) {
    //guard let url = URL(string: urlString) else { return }
    let url = URL(string: urlString) ?? URL(string: Constants.aboutBlank)!
    let request = URLRequest(url: url)
    webView.load(request)
  }
  
  func getWebView() -> WKWebView {
    return webView
  }
  
  func observeURLStringChange() {
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
}
