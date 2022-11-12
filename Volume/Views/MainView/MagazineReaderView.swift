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
    private let pdfView = PDFView()
    
    init(magazine: Magazine) {
        self.magazine = magazine
        self.pdfView.autoScales = true
        if let url = magazine.pdfUrl {
            self.pdfView.document = PDFDocument(url: url)
        }
    }
    
    var body: some View {
        Text(magazine.title)
        if let url = magazine.pdfUrl {
            PDFKitView(url: url)
        }
    }
}

struct PDFKitView: UIViewRepresentable {
    
    let pdfUrl : URL
    
    init(url: URL) {
        self.pdfUrl = url
    }
    
    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.document = PDFDocument(url: pdfUrl)
        pdfView.autoScales = true
        return pdfView
    }
    
    func updateUIView(_ pdfView: PDFView, context: Context) {
        pdfView.document = PDFDocument(url: pdfUrl)
    }
}
