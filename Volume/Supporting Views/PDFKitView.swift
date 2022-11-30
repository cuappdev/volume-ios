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

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView(frame: CGRect(origin: .zero, size: CGSize(width: 150, height: 220)))
        pdfView.document = pdfDoc
        pdfView.autoScales = true
        pdfView.usePageViewController(true)
        pdfView.displayDirection = isCover ? .vertical : .horizontal
        pdfView.displaysAsBook = true
        pdfView.displaysPageBreaks = false

        return pdfView
    }
    
    func updateUIView(_ pdfView: PDFView, context: Context) {
        pdfView.document = pdfDoc
    }
}
