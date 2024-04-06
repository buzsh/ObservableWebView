//
//  ViewExtension.swift
//  ObservableWebView
//
//  Created by Justin Bush on 4/6/24.
//

import SwiftUI

extension View {
  func animateOnChange<T: Equatable>(of value: T, with state: Binding<T>) -> some View {
    self.onChange(of: value) {
      withAnimation {
        state.wrappedValue = value
      }
    }
  }
}
