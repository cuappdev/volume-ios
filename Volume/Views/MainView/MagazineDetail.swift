//
//  MagazineDetail.swift
//  Volume
//
//  Created by Justin Ngai on 9/3/2022.
//  Copyright © 2022 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct MagazineReaderView: View {
    let magazine: Magazine
    var body: some View {
        Text(magazine.title)
    }
}
