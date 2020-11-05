//
//  UnderlinedText.swift
//  Volume
//
//  Created by Daniel Vebman on 11/4/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct UnderlinedText: View {
    @State var text: String

    var body: some View {
        VStack {
            Text(text)
            Image("underline")
                .scaledToFill()
                .frame(height: 12)
        }
    }
}

struct UnderlinedText_Previews: PreviewProvider {
    static var previews: some View {
        UnderlinedText(text: "The Big Read")
            .font(.custom("Futura-Bold", size: 15))
    }
}
