//
//  KeyWindow.swift
//  ObservableWebView
//
//  Created by Justin Bush on 4/6/24.
//

import SwiftUI
import AppKit

struct KeyWindow: NSViewControllerRepresentable {
  func makeNSViewController(context: Context) -> some NSViewController {
    NSViewController()
  }
  
  func updateNSViewController(_ nsViewController: NSViewControllerType, context: Context) {}
  
  static func toggleTabBar() {
    if let keyWindow = NSApp.keyWindow {
      keyWindow.toggleTabBar(nil)
    }
  }
  
  static func toggleTabOverview() {
    if let keyWindow = NSApp.keyWindow {
      keyWindow.toggleTabOverview(nil)
    }
  }
}
