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
    @State private var textSize: CGSize = .zero

    var body: some View {
        VStack {
            Text(text)
                .fixedSize()
                .background(SizeGetter(size: $textSize))

            Image("underline")
                .resizable()
                .scaledToFit()
                // 112x6
                .frame(width: textSize.width + 4, height:
                    (textSize.width + 4) * 6 / 112)
                .clipped()
                .padding(.top, -12 * textSize.height / 20)
                .offset(x: 2)
        }
    }
}

struct UnderlinedText_Previews: PreviewProvider {
    static var previews: some View {
        PreviewWrapper()
    }

    struct PreviewWrapper: View {
        var body: some View {
            UnderlinedText(text: "THE BIG READ AND OTHER THINGS")
                .font(.custom("Futura-Bold", size: 15))
        }
    }
}

struct SizeGetter: View {
    @Binding var size: CGSize

    var body: some View {
        return GeometryReader { geometry in
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
