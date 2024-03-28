//
//  UrlSearchBarTextField.swift
//  ObservableWebView
//
//  Created by Justin Bush on 3/19/24.
//

import SwiftUI
import AppKit

struct UrlSearchBarTextField: NSViewRepresentable {
  @Binding var text: String
  @Binding var isEditing: Bool
  var onSubmit: (() -> Void)?
  
  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }
  
  func makeNSView(context: Context) -> CustomTextField {
    let textField = CustomTextField()
    textField.delegate = context.coordinator
    textField.onEditingChanged = { editing in
      context.coordinator.isEditing = editing
    }
    context.coordinator.onSubmit = onSubmit
    textField.isBordered = false
    textField.drawsBackground = false
    textField.focusRingType = .none
    textField.font = NSFont.systemFont(ofSize: 14, weight: .regular)
    textField.textColor = NSColor.textColor
    return textField
  }
  
  func updateNSView(_ textField: CustomTextField, context: Context) {
    textField.stringValue = text
  }
  
  class Coordinator: NSObject, NSTextFieldDelegate {
    var parent: UrlSearchBarTextField
    var onSubmit: (() -> Void)?
    
    var isEditing: Bool = false {
      didSet {
        DispatchQueue.main.async {
          self.parent.isEditing = self.isEditing
        }
      }
    }
    
    init(_ textField: UrlSearchBarTextField) {
      self.parent = textField
    }
    
    func controlTextDidChange(_ obj: Notification) {
      if let textField = obj.object as? NSTextField {
        DispatchQueue.main.async {
          self.parent.text = textField.stringValue
        }
      }
    }
    
    func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
      if commandSelector == #selector(NSResponder.insertNewline(_:)) {
        if let textField = control as? NSTextField {
          self.parent.text = textField.stringValue
        }
        onSubmit?()
        return true
      }
      return false
    }
  }
}

class CustomTextField: NSTextField {
  var onEditingChanged: ((Bool) -> Void)?
  private var shouldAttemptToFocus = true
  
  override func becomeFirstResponder() -> Bool {
    let becomeFirstResponder = super.becomeFirstResponder()
    if becomeFirstResponder {
      onEditingChanged?(true)
    }
    return becomeFirstResponder
  }
  
  override func textDidEndEditing(_ notification: Notification) {
    super.textDidEndEditing(notification)
    onEditingChanged?(false)
  }
  
  override init(frame frameRect: NSRect) {
    super.init(frame: frameRect)
    self.isBordered = false
    self.drawsBackground = false
    self.focusRingType = .none
    self.font = NSFont.systemFont(ofSize: 14, weight: .regular)
    self.textColor = NSColor.textColor
    self.placeholderString = "Search or type URL"
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func mouseDown(with event: NSEvent) {
    if let textEditor = currentEditor() {
      textEditor.selectAll(self)
    }
  }
  
  override func viewDidMoveToWindow() {
    super.viewDidMoveToWindow()
    if shouldAttemptToFocus, self.window != nil {
      self.window?.makeFirstResponder(self)
      shouldAttemptToFocus = false
    }
  }
}
