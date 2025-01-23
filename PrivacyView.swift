//
//  UnclickableSwiftUiWebView
//
//  Created by Berk Ilgar Özalp on 23.01.2025.
//

import SwiftUI
import WebKit

struct UnclickableSwiftUiWebView: View {
    private let unclickableURL = URL(string: "https://YOURURLHERE.TLD")!
    
    var body: some View {
        WebView(url: unclickableURL)
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct WebView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        let preferences = WKWebpagePreferences()
        preferences.allowsContentJavaScript = true
        
        let configuration = WKWebViewConfiguration()
        configuration.defaultWebpagePreferences = preferences
        configuration.allowsInlineMediaPlayback = false
        configuration.preferences.javaScriptCanOpenWindowsAutomatically = false
        
        // Inject JavaScript to disable links
        let script = """
            (function() {
                function disableLinks() {
                    document.querySelectorAll('a').forEach(function(link) {
                        link.style.pointerEvents = 'none';
                        link.style.cursor = 'default';
                        link.onclick = function(e) {
                            e.preventDefault();
                            return false;
                        };
                        link.href = 'javascript:void(0)';
                        link.target = '_self';
                        link.removeAttribute('download');
                    });
                }
                
                // Run on initial load
                if (document.readyState === 'loading') {
                    document.addEventListener('DOMContentLoaded', disableLinks);
                } else {
                    disableLinks();
                }
                
                // Watch for changes
                new MutationObserver(disableLinks).observe(
                    document.documentElement || document.body,
                    { childList: true, subtree: true }
                );
                
                // Capture and prevent all click events
                document.addEventListener('click', function(e) {
                    if (e.target.tagName === 'A' || e.target.closest('a')) {
                        e.preventDefault();
                        e.stopPropagation();
                        return false;
                    }
                }, true);
                
                // Override window.open
                window.open = function() { return null; };
            })();
        """
        
        let userScript = WKUserScript(
            source: script,
            injectionTime: .atDocumentStart,
            forMainFrameOnly: false
        )
        
        configuration.userContentController.addUserScript(userScript)
        
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator
        webView.uiDelegate = context.coordinator
        webView.scrollView.isScrollEnabled = true
        webView.allowsBackForwardNavigationGestures = false
        webView.allowsLinkPreview = false
        
        // Load the URL
        webView.load(URLRequest(url: url))
        
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, WKNavigationDelegate, WKUIDelegate {
        // Navigation Delegate: Block all navigation except initial load
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if navigationAction.navigationType == .other {
                decisionHandler(.allow)
            } else {
                decisionHandler(.cancel)
            }
        }
        
        // UI Delegate: Block new windows and link previews
        func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
            return nil
        }
        
        func webView(_ webView: WKWebView, shouldPreviewElement elementInfo: WKPreviewElementInfo) -> Bool {
            return false
        }
    }
}

#Preview {
    NavigationStack {
        UnclickableSwiftUiWebView()
    }
}
