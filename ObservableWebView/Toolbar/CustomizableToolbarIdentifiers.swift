//
//  CustomizableToolbarIdentifiers.swift
//  ObservableWebView
//
//  Created by Justin Bush on 3/19/24.
//

import Foundation

enum ToolbarIdentifier: String {
  case editingtools
  
  var id: String {
    self.rawValue
  }
}

extension ToolbarItemIdentifier {
  var id: String {
    self.rawValue
  }
}
