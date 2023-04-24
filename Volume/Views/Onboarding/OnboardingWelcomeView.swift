//
//  OnboardingWelcomeView.swift
//  Volume
//
//  Created by Vin Bui on 4/23/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct OnboardingWelcomeView: View {
    
    // MARK: - Constants
    
    private struct Constants {
        static let boldTextFont: Font = .newYorkBold(size: 16)
        static let iconSize: CGSize = CGSize(width: 36, height: 36)
        static let regularTextFont: Font = .newYorkRegular(size: 16)
        static let rowSpacing: CGFloat = 28
        static let verticalSpacing: CGFloat = 49
        static let sidePadding: CGFloat = 48
    }
    
    // MARK: - UI
    
    var body: some View {
        VStack(alignment: .leading, spacing: Constants.verticalSpacing) {
            featureRow(
                image: "magazine",
                textBold: "Stay updated ",
                textRegular: "with Cornell student publications and organizations, all in one place"
            )
            
            featureRow(
                image: "feed",
                textBold: "Read up ",
                textRegular: "on what's trending in the community and from the publications that you follow"
            )
            
            featureRow(
                image: "shout-out",
                textBold: "Give shoutouts ",
                textRegular: "to support student content"
            )
        }
        .transition(.asymmetric(insertion: .opacity, removal: .move(edge: .leading)))
    }
    
    private func featureRow(image: String, textBold: String, textRegular: String) -> some View {
        HStack(alignment: .top, spacing: Constants.rowSpacing) {
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(width: Constants.iconSize.width, height: Constants.iconSize.height)
                .foregroundColor(Color.volume.orange)
            
            Group {(
                Text(textBold)
                    .font(Constants.boldTextFont)
                
                +
                
                Text(textRegular)
                    .font(Constants.regularTextFont))
            }
            .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.horizontal, Constants.sidePadding)
    }
    
}

// MARK: - Uncomment below if needed

//struct OnboardingWelcomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        OnboardingWelcomeView()
//    }
//}
