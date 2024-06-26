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
    let imageUrl: URL?
    let isNSFW: Bool
    let isFeatured: Bool
    let isFiltered: Bool
    let pdfUrl: URL?
    let publication: Publication
    let publicationSlug: String
    let semester: String
    let shoutouts: Int
    let title: String
    let trendiness: Int

    init(from magazine: VolumeAPI.MagazineFields) async {
        id = magazine.id
        date = Date.from(iso8601: magazine.date)
        imageUrl = URL(string: magazine.imageURL)
        isFeatured = magazine.isFeatured
        isFiltered = magazine.isFiltered
        isNSFW = magazine.nsfw
        pdfUrl = URL(string: magazine.pdfURL)
        publication = Publication(from: magazine.publication.fragments.publicationFields)
        publicationSlug = magazine.publicationSlug
        semester = magazine.semester
        shoutouts = Int(magazine.shoutouts)
        title = magazine.title
        trendiness = Int(magazine.trendiness)
    }

}

extension Array where Element == Magazine {

    init(_ magazines: [VolumeAPI.MagazineFields]) async {
        await self.init(magazines.asyncMap(Magazine.init))
    }

}
