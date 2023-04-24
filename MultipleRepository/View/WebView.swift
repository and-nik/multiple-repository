//
//  WebView.swift
//  MultipleRepository
//
//  Created by And Nik on 21.04.23.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    
    let url: URL
    
    func makeUIView(context: Context) -> some UIView {
        let webView = WKWebView()
        let reguest = URLRequest(url: url)
        webView.load(reguest)
        return webView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
}
