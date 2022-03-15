//
//  WelcomeView.swift
//  Volume
//
//  Created by Daniel Vebman on 11/26/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import SwiftUI

extension OnboardingView {
    struct WelcomeView: View {
        var body: some View {
            Group {
                FeatureRow(
                    image: "publications",
                    textBold: "Stay updated ",
                    textRegular: "with Cornell student publications, all in one place"
                )
                FeatureRow(
                    image: "volume",
                    textBold: "Read articles ",
                    textRegular: "trending in the Cornell commnity and from publications you follow"
                )
                FeatureRow(
                    image: "shout-out",
                    textBold: "Give shout-outs ",
                    textRegular: "to support student content"
                )
            }
            .transition(.asymmetric(insertion: .opacity, removal: .move(edge: .leading)))
        }
    }
}

extension OnboardingView.WelcomeView {
    private struct FeatureRow: View {
        let image: String
        let textBold: String
        let textRegular: String

        var body: some View {
            HStack(alignment: .top, spacing: 28) {
                Image(image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 36, height: 36)
                    .foregroundColor(.volume.orange)
                (
                    Text(textBold)
                        .font(.newYorkBold(size: 16))
                    +
                    Text(textRegular)
                        .font(.newYorkRegular(size: 16))
                )
                .frame(width: 222)
            }
            .padding([.leading, .trailing], 48)
            .padding(.top, 35)
        }
    }
}

//struct WelcomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        OnboardingView.WelcomeView()
//    }
//}
