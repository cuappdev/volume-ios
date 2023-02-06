//
//  Magazine.swift
//  Volume
//
//  Created by Hanzheng Li on 3/4/22.
//  Copyright © 2022 Cornell AppDev. All rights reserved.
//

import Foundation
import PDFKit
import SwiftUI

struct Magazine: ReadableContent {
    let id: String
    let date: Date
    let isNSFW: Bool
    let pdfUrl: URL?
    let publication: Publication
    let semester: String
    let shoutouts: Int
    let title: String
    var pdfDoc: PDFDocument?
    
    init(from magazine : MagazineFields) async {
        date = Date.from(iso8601: magazine.date)
        id = magazine.id
        isNSFW = magazine.nsfw
        pdfUrl = URL(string: magazine.pdfUrl)
        publication = Publication(from: magazine.publication.fragments.publicationFields)
        semester = magazine.semester
        shoutouts = Int(magazine.shoutouts)
        title = magazine.title
        if let pdfUrl {
            pdfDoc = await fetchPDF(url: pdfUrl)
        }
    }

    private func fetchPDF(url: URL) async -> PDFDocument? {
        await withCheckedContinuation { continuation in
            Task {
                let doc = await PDFDocument(url: url)
                continuation.resume(returning: doc)
            }
        }
    }
}

extension Array where Element == Magazine {
    init(_ magazines: [MagazineFields]) async {
        await self.init(magazines.asyncMap(Magazine.init))
    }
}
