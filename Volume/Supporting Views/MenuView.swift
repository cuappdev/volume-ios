//
//  MenuView.swift
//  Volume
//
//  Created by Hanzheng Li on 11/24/22.
//  Copyright © 2022 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct MenuView: View {
    @Binding var selection: String
    @Binding var options: [String]

    var body: some View {
        Menu {
            ForEach(options, id: \.self) { option in
                Button(option) {
                    selection = option
                }
            }
        } label: {
            HStack {
                Text(selection)
                    .font(.helveticaNeueMedium(size: 12))
                    .fixedSize()

                Image("down-arrow")
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 16)
            }
            .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 12))
            .foregroundColor(.volume.orange)
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.volume.orange, lineWidth: 1.5)
            }
        }
    }
}
