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
    private let sidesWithDefaultPadding: Edge.Set

    init(_ text: String, sidesWithDefaultPadding: Edge.Set = [.leading, .top, .trailing, .bottom]) {
        self.text = text
        self.sidesWithDefaultPadding = sidesWithDefaultPadding
    }

    var body: some View {
        UnderlinedText(text)
            .font(.begumMedium(size: 20))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(sidesWithDefaultPadding)
    }
}

struct Header_Previews: PreviewProvider {
    static var previews: some View {
        Header("Header")
    }
}
