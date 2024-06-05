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
