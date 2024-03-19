//
//  CustomizableToolbarIdentifiers.swift
//  ObservableWebView
//
//  Created by Justin Bush on 3/19/24.
//

import Foundation

enum CustomizableToolbar: String {
  case editingtools
  
  var id: String {
    self.rawValue
  }
}

extension CustomizableToolbarItem {
  var id: String {
    self.rawValue
  }
}
