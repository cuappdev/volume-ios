//
//  MagazineDetail.swift
//  Volume
//
//  Created by Justin Ngai on 9/3/2022.
//  Copyright © 2022 Cornell AppDev. All rights reserved.
//

import SwiftUI
import PDFKit

struct MagazineReaderView: View {
    private let magazine: Magazine
    
    init(magazine: Magazine) {
        self.magazine = magazine
    }
    
    var body: some View {
        Text(magazine.title)
        if let url = magazine.pdfUrl {
            PDFKitView(pdfDoc: PDFDocument(url: url)!)
        }
    }
}

struct PDFKitView: UIViewRepresentable {
    
    let pdfDoc : PDFDocument
    
    init(pdfDoc: PDFDocument) {
        self.pdfDoc = pdfDoc
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
