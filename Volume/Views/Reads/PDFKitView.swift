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

    @ObservedObject var pdfView: PDFViewUnselectable
    let pdfDoc: PDFDocument

    func makeUIView(context: Context) -> PDFViewUnselectable {
        pdfView.document = pdfDoc
        pdfView.autoScales = true
        pdfView.usePageViewController(true)
        pdfView.displayDirection = .horizontal
        pdfView.displaysAsBook = true
        pdfView.displaysPageBreaks = false
        pdfView.displayMode = .singlePage
        pdfView.minScaleFactor = pdfView.scaleFactor

        let scrollView = pdfView.subviews.first?.subviews.first as? UIScrollView
        scrollView?.showsVerticalScrollIndicator = false
        scrollView?.showsHorizontalScrollIndicator = false

        return pdfView
    }

    func updateUIView(_ pdfView: PDFViewUnselectable, context: Context) {
        pdfView.document = pdfDoc
    }
}

class PDFViewUnselectable: PDFView, ObservableObject {

    /// prevent users from copy+pasting content from PDF documents
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        false
    }

    override func addGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer) {
        if gestureRecognizer is UILongPressGestureRecognizer {
            gestureRecognizer.isEnabled = false
        }

        super.addGestureRecognizer(gestureRecognizer)
    }
}
