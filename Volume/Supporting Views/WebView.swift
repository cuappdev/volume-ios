//
//  WebView.swift
//  Volume
//
//  Created by Daniel Vebman on 10/25/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//
import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let url: URL

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.backgroundColor = .white
        webView.load(URLRequest(url: url))
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) { }

    class Coordinator: NSObject { }
}
