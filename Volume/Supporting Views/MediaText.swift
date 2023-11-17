//
//  MediaText.swift
//  Volume
//
//  Created by Vin Bui on 11/17/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import SwiftUI

/// A view representing a social media text.
struct MediaText: View {

    // MARK: - Properties

    let title: String
    let url: URL

    // MARK: - UI

    var body: some View {
        Link(title, destination: url)
            .font(.helveticaRegular(size: 12))
            .foregroundColor(Color.volume.orange)
            .padding(.trailing, 10)
            .lineLimit(1)
    }

}
