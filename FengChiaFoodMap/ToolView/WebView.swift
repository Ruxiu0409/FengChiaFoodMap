//
//  WebView.swift
//  FengChiaFoodMap
//
//  Created by 蔡承曄 on 2024/8/12.
//
import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    var url: URL

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

#Preview {
    WebView(url: URL(string: "https://www.youtube.com")!)
}
