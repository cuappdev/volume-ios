//
//  UnderlinedText.swift
//  Volume
//
//  Created by Daniel Vebman on 11/4/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct UnderlinedText: View {
    @State private var textSize: CGSize = .zero
    private let text: String

    init(_ text: String) {
        self.text = text
    }

    var body: some View {
        VStack {
            Text(text)
                .fixedSize()
                .background(SizeGetter(size: $textSize))

            Image("underline")
                .resizable()
                .scaledToFit()
                .frame(width: textSize.width + 4, height:
                    (textSize.width + 4) * 6 / 112)
                .clipped()
                .padding(.top, -10 * textSize.height / 25)
        }
    }
}

struct SizeGetter: View {
    @Binding var size: CGSize

    var body: some View {
        GeometryReader { geometry in
            self.makeView(geometry: geometry)
        }
    }

    func makeView(geometry: GeometryProxy) -> some View {
        DispatchQueue.main.async {
            self.size = geometry.frame(in: .global).size
        }

        return Rectangle().fill(Color.clear)
    }
}

struct UnderlinedText_Previews: PreviewProvider {
    static var previews: some View {
        PreviewWrapper()
    }

    struct PreviewWrapper: View {
        var body: some View {
            UnderlinedText("THE BIG READ AND OTHER THINGS")
                .font(.helveticaBold(size: 15))
        }
    }
}
