//
//  PDFKitView.swift
//  Volume
//
//  Created by Jennifer Gu on 11/12/22.
//  Copyright © 2022 Cornell AppDev. All rights reserved.
//

import Foundation
import SwiftUI
import PDFKit

struct PDFKitView: UIViewRepresentable {
    
    let pdfDoc : PDFDocument
    @Binding var showToolbars: Bool
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.document = pdfDoc
        pdfView.autoScales = true
        return pdfView
    }
    
    func updateUIView(_ pdfView: PDFView, context: Context) {
        pdfView.document = pdfDoc
    }
}

struct SimplePDFView: UIViewRepresentable {
    
    let pdfDoc : PDFDocument
    
    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.document = pdfDoc
        pdfView.autoScales = true
        return pdfView
    }
    
    func updateUIView(_ pdfView: PDFView, context: Context) {
        pdfView.document = pdfDoc
    }
}

extension PDFKitView {
    class Coordinator: NSObject, UIScrollViewDelegate {
        var parent: PDFKitView
        private var lastContentOffset: CGFloat = 0
        
        init(_ parent: PDFKitView) {
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
