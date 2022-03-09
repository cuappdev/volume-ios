//
//  StatisticViewRow.swift
//  Volume
//
//  Created by Amy Chin Siu Huang on 12/1/21.
//  Copyright © 2021 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct StatisticView: View {
    let image: String
    let leftText: String
    let number: Int
    let rightText: String

    var body: some View {
        HStack {
            Image(image)
                .resizable()
                .scaledToFit()
                .foregroundColor(Color.volume.orange)
                .frame(height: 24)
                .padding(.trailing, 24)
            HStack(spacing: 8, content: {
                Text(leftText)
                    .font(.begumMedium(size: 16))
                Text("\(number)")
                    .font(.begumMedium(size: 36))
                    .foregroundColor(Color.volume.orange)
                Text(rightText)
                    .font(.begumMedium(size: 16))
            })
            Spacer()
        }
    }
}


struct StatisticViewRow_Previews: PreviewProvider {
    static var previews: some View {
        StatisticView(image: "feed", leftText: "read", number: 45, rightText: "articles")
    }
}
