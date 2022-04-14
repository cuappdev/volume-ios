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
                .foregroundColor(.volume.orange)
                .frame(height: 24)
                .padding(.trailing, 24)
            HStack(spacing: 8, content: {
                Text(leftText)
                    .font(.newYorkMedium(size: 16))
                Text("\(number)")
                    .font(.newYorkMedium(size: 36))
                    .foregroundColor(.volume.orange)
                Text(rightText)
                    .font(.newYorkMedium(size: 16))
            })
            Spacer()
        }
    }
}

extension StatisticView {
    struct Skeleton: View {
        var body: some View {
            HStack {
                SkeletonView()
                    .scaledToFit()
                    .foregroundColor(.volume.orange)
                    .frame(height: 24)
                    .padding(.trailing, 24)
                HStack(spacing: 8, content: {
                    SkeletonView()
                        .font(.newYorkMedium(size: 16))
                    SkeletonView()
                        .font(.newYorkMedium(size: 36))
                        .foregroundColor(.volume.orange)
                    SkeletonView()
                        .font(.newYorkMedium(size: 16))
                })
                Spacer()
            }
        }
    }
}


struct SStatisticViewRow_Previews: PreviewProvider {
    static var previews: some View {
        StatisticView(image: "feed", leftText: "read", number: 45, rightText: "articles")
    }
}
