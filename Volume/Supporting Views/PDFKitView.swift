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
    
    let pdfDoc: PDFDocument
    var isCover = false

    func makeUIView(context: Context) -> PDFViewUnselectable {
        let pdfView = PDFViewUnselectable(frame: CGRect(origin: .zero, size: CGSize(width: 150, height: 220)))
        pdfView.document = pdfDoc
        pdfView.autoScales = true
        pdfView.usePageViewController(true)
        pdfView.displayDirection = isCover ? .vertical : .horizontal
        pdfView.displaysAsBook = true
        pdfView.displaysPageBreaks = false

        return pdfView
    }

    func updateUIView(_ pdfView: PDFViewUnselectable, context: Context) {
        pdfView.document = pdfDoc
    }
}

class PDFViewUnselectable: PDFView {

    /// prevent users from copy+pasting content from PDF documents
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }

    override func addGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer) {
        if gestureRecognizer is UILongPressGestureRecognizer {
            gestureRecognizer.isEnabled = false
        }

        super.addGestureRecognizer(gestureRecognizer)
    }
}
