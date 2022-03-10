//
//  Magazine.swift
//  Volume
//
//  Created by Hanzheng Li on 3/4/22.
//  Copyright © 2022 Cornell AppDev. All rights reserved.
//

import Foundation

struct Magazine: Identifiable {
    // TODO: populate this class once API is specified
    let id: String
    let title: String
    let date: Date
    let coverUrl: URL?
    let publication: Publication
    let shoutouts: Int
    let magazineUrl: URL?
}

//extension Array where Element == Magazine {
//    init(_ magazines: [MagazineFields]) {
//        self.init(magazines.map(Magazine.init))
//    }
//}
