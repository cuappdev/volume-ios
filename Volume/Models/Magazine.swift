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
    let isNsfw: Bool
    let magazineUrl: URL?
    let pdfUrl: URL?
    let publication: Publication
    let semester: String
    let shoutouts: Int
    let title: String
    
    init(from magazine : MagazineFields) {
        date = Date.from(iso8601: magazine.date)
        id = magazine.id
        isNsfw = magazine.nsfw
        magazineUrl = URL(string: magazine.magazineUrl)
        pdfUrl = URL(string: magazine.pdfUrl)
        publication = Publication(from: magazine.publication.fragments.publicationFields)
        semester = magazine.semester
        shoutouts = Int(magazine.shoutouts)
        title = magazine.title
    }
    
}

//extension Array where Element == Magazine {
//    init(_ magazines: [MagazineFields]) {
//        self.init(magazines.map(Magazine.init))
//    }
//}
