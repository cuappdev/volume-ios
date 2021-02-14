//
//  BubblePeriodText.swift
//  Volume
//
//  Created by Daniel Vebman on 11/16/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct BubblePeriodText: View {
    @State var text: String

    init(_ text: String) {
        _text = State(initialValue: text)
    }

    var body: some View {
        HStack(alignment: .bottom) {
            Text(text)
            Image("period")
                .offset(x: -5, y: -5)
        }
    }
}

struct BubblePeriodText_Previews: PreviewProvider {
    static var previews: some View {
        BubblePeriodText("Hello, there!")
    }
}
