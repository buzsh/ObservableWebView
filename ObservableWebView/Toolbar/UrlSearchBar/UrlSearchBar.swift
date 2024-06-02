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
    //fetchFavicon()
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
    .onChange(of: themeColor) {
      print("new url search bar theme: \(themeColor)")
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
        } else {
          manager.load(text)
        }
      }
    }
    .urlBarStyle(width: windowProperties.urlSearchBarWidth, themeColor: themeColor, isEditing: isEditing)
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

//
//  FaviconService.swift
//  ObservableWebView
//
//  Created by Justin Bush on 3/19/24.
//

import SwiftUI
import WebKit

class FaviconService {
  private var webView: WKWebView?
  
  init(webView: WKWebView?) {
    self.webView = webView
  }
  
  func fetchFavicon(completion: @escaping (Image?) -> Void) {
    let faviconScript = """
        (function() {
            var links = document.getElementsByTagName('link');
            var icons = Array.from(links).filter(function(link) {
                return link.getAttribute('rel') === 'icon' || link.getAttribute('rel').includes('icon');
            });
            return icons.length > 0 ? icons[0].href : '';
        })();
        """
    
    Task {
      let result = await executeJavaScript(faviconScript)
      switch result {
      case .success(let url):
        if let urlString = url as? String, let faviconUrl = URL(string: urlString) {
          let faviconImage = await downloadAndCacheFavicon(from: faviconUrl)
          await MainActor.run {
            completion(faviconImage)
          }
        } else {
          await MainActor.run {
            completion(nil)
          }
        }
      case .failure:
        await MainActor.run {
          completion(nil)
        }
      }
    }
  }
  
  @MainActor
  private func executeJavaScript(_ script: String) async -> Result<Any?, Error> {
    guard let webView = self.webView else {
      return .failure(NSError(domain: "WebViewError", code: 0, userInfo: [NSLocalizedDescriptionKey: "WebView is nil"]))
    }
    
    return await withCheckedContinuation { continuation in
      webView.evaluateJavaScript(script) { result, error in
        if let error = error {
          continuation.resume(returning: .failure(error))
        } else {
          continuation.resume(returning: .success(result))
        }
      }
    }
  }
  
  private func downloadAndCacheFavicon(from url: URL) async -> Image? {
    do {
      let (data, _) = try await URLSession.shared.data(from: url)
      #if os(iOS)
      if let uiImage = UIImage(data: data) {
        return Image(uiImage: uiImage)
      }
      #elseif os(macOS)
      if let nsImage = NSImage(data: data) {
        return Image(nsImage: nsImage)
      }
      #endif
    } catch {
      print("Error downloading favicon: \(error)")
    }
    return nil
  }
}
