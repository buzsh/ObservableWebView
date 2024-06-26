//
//  UrlSearchBar.swift
//  ObservableWebView
//
//  Created by Justin Bush on 3/28/24.
//

import SwiftUI

struct UrlSearchBar: View {
  @Environment(\.windowProperties) private var windowProperties
  let manager: ObservableWebViewManager
  let themeColor: Color
  
  @State private var text: String = ""
  @State private var isEditing: Bool = false
  @State private var showTextField: Bool = false
  @State private var progressBarColor: Color = .accentColor
  @State private var favicon: Image?
  
  func observedUrlChange(from oldUrlString: String, to newUrlString: String) {
    showTextField = false
    text = prettyUrl(from: manager.urlString)
  }
  
  var body: some View {
    ZStack(alignment: .bottom) {
      if showTextField {
        urlSearchBarTextField
      } 
      else {
        prettyUrlBar
      }
      
      progressBar
    }
    .foregroundStyle(.primary)
    .font(.system(size: 14, weight: .regular, design: .rounded))
    .onChange(of: manager.urlString ?? "") { oldUrl, newUrl in
      observedUrlChange(from: oldUrl, to: newUrl)
    }
    .onChange(of: showTextField) {
      if showTextField {
        text = manager.urlString ?? ""
      }
    }
    .onChange(of: themeColor) {
      progressBarColor = themeColor == .clear ? .accentColor : .primary
    }
    .onChange(of: manager.loadState) {
      if manager.loadState == .isFinished {
        fetchFavicon()
      }
    }
    .mask(
      RoundedRectangle(cornerRadius: 8)
        .frame(width: windowProperties.urlSearchBarWidth)
    )
  }
  
  var progressBar: some View {
    ProgressView(value: manager.progress, total: 100)
      .progressViewStyle(LinearTransparentProgressViewStyle(tintColor: progressBarColor, horizontalPadding: 5))
      .frame(height: 2)
      .frame(width: windowProperties.urlSearchBarWidth)
      .opacity(manager.loadState == .isLoading ? 1 : 0)
      .padding(.top)
  }
}

// MARK: - PrettyUrlBar
extension UrlSearchBar {
  func prettyUrl(from urlString: String?) -> String {
    guard let urlString = urlString, let url = URL(string: urlString), let host = url.host else {
      return ""
    }
    return host.replacingOccurrences(of: "www.", with: "")
  }
  
  var prettyUrlBar: some View {
    HStack {
      manager.isSecurePage ? SFSymbol.solidLock.image : SFSymbol.solidLockSlash.image
      
      Spacer()
      
      if let favicon {
        favicon
          .resizable()
          .frame(width: 18, height: 18)
      }
      
      Text(prettyUrl(from: manager.urlString))
        .onTapGesture { showTextField = true }
        .foregroundStyle(.primary)
      
      Spacer()
    }
    .urlBarStyle(width: windowProperties.urlSearchBarWidth, themeColor: themeColor)
    .foregroundColor(.secondary)
  }
}

// MARK: - UrlSearchBarTextField
extension UrlSearchBar {
  var urlSearchBarTextField: some View {
    HStack {
      SFSymbol.search.image
        .foregroundColor(.secondary)
        .onTapGesture {
          showTextField = false
        }
      UrlSearchBarTextField(text: $text, isEditing: $isEditing) {
        if text.isEmpty {
          showTextField = false
        } else if isValidUrl(text) {
          manager.load(text)
        } else {
          loadSearch(query: text)
        }
      }
    }
    .urlBarStyle(width: windowProperties.urlSearchBarWidth, themeColor: themeColor, isEditing: isEditing)
  }
  
  func isValidUrl(_ urlString: String) -> Bool {
    let urlRegEx = "((?:http|https|file)://)?((?:localhost)|(?:\\w+\\.\\w+))(?::\\d+)?(?:/[^\\s]*)?"
    let predicate = NSPredicate(format:"SELF MATCHES %@", urlRegEx)
    return predicate.evaluate(with: urlString)
  }
  
  func loadSearch(query: String) {
    let searchQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    let searchURL = "https://duckduckgo.com/?q=\(searchQuery)"
    manager.load(searchURL)
  }
}

#Preview {
  BrowserView()
    .frame(width: 400, height: 600)
    .navigationTitle("")
}

extension UrlSearchBar {
  private func fetchFavicon() {
    let faviconService = FaviconService(webView: manager.webView)
    faviconService.fetchFavicon { image in
      Task {
        favicon = image
      }
    }
  }
}
