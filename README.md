<picture>
  <source media="(prefers-color-scheme: dark)" width="400" alt="ObservableWebView" srcset="https://github.com/buzsh/ObservableWebView/assets/158503966/5b8c74ec-d091-48a9-bdcb-a39b5af5c155">
  <source media="(prefers-color-scheme: light)" width="400" alt="ObservableWebView" srcset="https://github.com/buzsh/ObservableWebView/assets/158503966/bfc92866-8a80-41a1-aaf2-85e0217d503b">
  <img width="400" alt="ObservableWebView" src="https://github.com/buzsh/ObservableWebView/assets/158503966/bfc92866-8a80-41a1-aaf2-85e0217d503b">
</picture>

WKWebView implementation using Swift's [Observation framework](https://developer.apple.com/documentation/observation).

```swift
let manager: ObservableWebViewManager
```

## Observable States

```swift
ObservableWebView(manager: manager)
  .onChange(of: manager.urlString) { ... }
```

```swift
ObservableWebView(manager: manager)
  .onChange(of: manager.progress) {
    updateLoadingBar(withProgress: manager.progress)
  }
```

### Load States

```swift
ObservableWebView(manager: manager)
  .onChange(of: manager.loadState) {
    switch state {
      case .idle:
        print("WebView is idle.")
      case .isLoading:
        print("WebView is loading.")
      case .isFinished:
        print("WebView has finished loading.")
      case .error(let error):
        print("WebView encountered an error: \(error.localizedDescription)")
      }
  }
```


## JavaScript-friendly

### Script Message Handlers

```swift
ObservableWebView(manager: manager)
  .scriptMessageHandler("messageFromJS", manager: manager) { message in
    print("Message: \(message.body)")
  }
```

### Execution

```swift
manager.js("document.title")
```

With completion:

```swift
manager.js("document.title") { result, error in
  if let error = error {
    print("JavaScript execution failed: \(error)")
  } else if let result = result {
    print("JavaScript execution result: \(result)")
  }
}
```

<p align="center">
  <img width="1155" alt="Screenshot 2024-04-06 at 12 24 31 PM" src="https://github.com/buzsh/ObservableWebView/assets/158503966/b595c8d6-14be-4b48-8369-e18323b89c67">
</p>

<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" width="1155" alt="Dark Tabs Gallery" srcset="https://github.com/buzsh/ObservableWebView/assets/158503966/f41171ca-4f72-4d95-897b-cf1a2598c870">
    <source media="(prefers-color-scheme: light)" width="1155" alt="Light Tabs Gallery" srcset="https://github.com/buzsh/ObservableWebView/assets/158503966/1b21944b-78be-4c4c-ad29-d7989c34950c">
    <img width="1155" alt="Tabs Gallery" src="https://github.com/buzsh/ObservableWebView/assets/158503966/1b21944b-78be-4c4c-ad29-d7989c34950c">
  </picture>
</p>

<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" width="1155" alt="Dark Toolbar Customization" srcset="https://github.com/buzsh/ObservableWebView/assets/158503966/5fc6dedc-f99c-4038-97c4-621087216d35">
    <source media="(prefers-color-scheme: light)" width="1155" alt="Light Toolbar Customization" srcset="https://github.com/buzsh/ObservableWebView/assets/158503966/36b62554-fe56-45fa-abb7-e6f586b2e0ea">
    <img width="1155" alt="Toolbar Customization" src="https://github.com/buzsh/ObservableWebView/assets/158503966/36b62554-fe56-45fa-abb7-e6f586b2e0ea">
  </picture>
</p>
