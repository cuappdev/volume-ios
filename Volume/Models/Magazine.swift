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

typealias MagazineID = String

struct Magazine: ReadableContent {
    
    let id: String
    let date: Date
    let isNSFW: Bool
    let isFeatured: Bool
    let isFiltered: Bool
    var pdfDoc: PDFDocument?
    let pdfUrl: URL?
    let publication: Publication
    let publicationSlug: String
    let semester: String
    let shoutouts: Int
    let title: String
    let trendiness: Int
    
    init(from magazine : MagazineFields) async {
        date = Date.from(iso8601: magazine.date)
        id = magazine.id
        isFeatured = magazine.isFeatured
        isFiltered = magazine.isFiltered
        isNSFW = magazine.nsfw
        pdfUrl = URL(string: magazine.pdfUrl)
        publication = Publication(from: magazine.publication.fragments.publicationFields)
        publicationSlug = magazine.publicationSlug
        semester = magazine.semester
        shoutouts = Int(magazine.shoutouts)
        title = magazine.title
        trendiness = Int(magazine.trendiness)
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
