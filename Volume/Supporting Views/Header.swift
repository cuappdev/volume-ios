//
//  Header.swift
//  Volume
//
//  Created by Cameron Russell on 11/15/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct Header: View {
    private let text: String
    private let alignment: Alignment

    init(_ text: String, _ alignment: Alignment = .leading) {
        self.text = text
        self.alignment = alignment
    }

    var body: some View {
        UnderlinedText(text)
            .font(.newYorkMedium(size: 20))
            .frame(maxWidth: .infinity, alignment: alignment)
    }
}
