//
//  MagsScrollbarView.swift
//  Volume
//
//  Created by Vin Bui on 3/8/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import SwiftUI
import PDFKit

struct MagsScrollbarView: UIViewRepresentable {

    let pdfView: PDFViewUnselectable

    func makeUIView(context: Context) -> PDFThumbnailView {
        let pdfThumbnailView = PDFThumbnailView()
        pdfThumbnailView.pdfView = pdfView
        pdfThumbnailView.layoutMode = .horizontal
        pdfThumbnailView.backgroundColor = Constants.scrollbarColor
        pdfThumbnailView.thumbnailSize = CGSize(width: Constants.thumbnailWidth, height: Constants.thumbnailHeight)
        return pdfThumbnailView
    }

    func updateUIView(_ pdfThumbnailView: PDFThumbnailView, context: Context) {
        pdfThumbnailView.pdfView = pdfView
    }
}

// MARK: - Constants
extension MagsScrollbarView {

    private struct Constants {
        static let thumbnailWidth: CGFloat = 20
        static let thumbnailHeight: CGFloat = 40
        static let scrollbarColor: UIColor = UIColor(Color(white: 0.93))
    }
}
