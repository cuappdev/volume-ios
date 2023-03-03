//
//  PDFView.swift
//  Volume
//
//  Created by Vin Bui on 3/2/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import Foundation
import SwiftUI
import PDFReader

struct PDFView: UIViewControllerRepresentable {
    
    let pdfDoc: PDFDocument
    
    func makeUIViewController(context: Context) -> PDFViewController {
        return PDFViewController.createNew(with: pdfDoc, isThumbnailsEnabled: true)
    }
    
    func updateUIViewController(_ pdfViewController: PDFViewController, context: Context) {
        pdfViewController.document.coreDocument
    }
}
