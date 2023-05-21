//
//  WebView.swift
//  Volume
//
//  Created by Daniel Vebman on 10/25/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//
import SwiftUI
import UIKit
import WebKit

struct WebView: UIViewRepresentable {
    let url: URL
    @Binding var showToolbars: Bool

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> WKWebView {
        let webView = LoadingWebView()
        webView.backgroundColor = .white
        webView.scrollView.delegate = context.coordinator
        webView.load(URLRequest(url: url))
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) { }
}

extension WebView {
    class Coordinator: NSObject, UIScrollViewDelegate {
        var parent: WebView
        private var lastContentOffset: CGFloat = 0
        
        init(_ parent: WebView) {
            self.parent = parent
        }
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            withAnimation {
                // show toolbar when near top of page or scrolling up
                parent.showToolbars = (lastContentOffset > scrollView.contentOffset.y) || scrollView.contentOffset.y <= 10
            }
            lastContentOffset = scrollView.contentOffset.y
        }
    }
}

class LoadingWebView: WKWebView {
    private let loadingIndicator = UIActivityIndicatorView()

    init() {
        super.init(frame: .zero, configuration: WKWebViewConfiguration())
        navigationDelegate = self

        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = .medium
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(loadingIndicator)

        NSLayoutConstraint.activate([
            loadingIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            loadingIndicator.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LoadingWebView: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loadingIndicator.stopAnimating()
        scrollView.isScrollEnabled = true
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        loadingIndicator.stopAnimating()
        scrollView.isScrollEnabled = true
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        loadingIndicator.startAnimating()
        scrollView.isScrollEnabled = false
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        loadingIndicator.stopAnimating()
    }
    
}
