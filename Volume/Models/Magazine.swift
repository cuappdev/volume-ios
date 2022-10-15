//
//  Magazine.swift
//  Volume
//
//  Created by Hanzheng Li on 3/4/22.
//  Copyright © 2022 Cornell AppDev. All rights reserved.
//

import Foundation
import SwiftUI

struct Magazine: Identifiable, Hashable {
    let date: Date
    let id: String
    let isFeatured: Bool
    let isFiltered: Bool
    let isNsfw: Bool
    let magazineUrl: URL?
    let pdfUrl: URL?
    //let publication: Publication
    let publicationSlug: String
    let semester: String
    let shoutouts: Int
    let title: String
    let trendiness: Int
    
    struct DummyMagazine {
        let date: String
        let id: String
        let isFeatured: Bool
        let isFiltered: Bool
        let nsfw: Bool
        let magazineUrl: String
        let pdfUrl: String
        //let publication: Publication
        let publicationSlug: String
        let semester: String
        let shoutouts: Int
        let title: String
        let trendiness: Int
    }
    
    init(from magazine : DummyMagazine) {
        date = Date.from(iso8601: magazine.date)
        id = magazine.id
        isFeatured = magazine.isFeatured
        isFiltered = magazine.isFiltered
        isNsfw = magazine.nsfw
        magazineUrl = URL(string: magazine.magazineUrl)
        pdfUrl = URL(string: magazine.pdfUrl)
        //TODO: test publication after backend update
        //publication = Publication(from: magazine.publication.fragments.publicationFields)
        publicationSlug = magazine.publicationSlug
        semester = magazine.semester
        shoutouts = Int(magazine.shoutouts)
        title = magazine.title
        trendiness = Int(magazine.trendiness)
    }
    
}

//extension Array where Element == Magazine {
//    init(_ magazines: [MagazineFields]) {
//        self.init(magazines.map(Magazine.init))
//    }
//}
