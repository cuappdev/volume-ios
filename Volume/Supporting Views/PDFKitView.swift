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
        let pdfView = PDFView()
        pdfView.document = pdfDoc
        pdfView.autoScales = true
        pdfView.displayDirection = isCover ? .vertical : .horizontal
        return pdfView
    }
    
    func updateUIView(_ pdfView: PDFView, context: Context) {
        pdfView.document = pdfDoc
    }
}
