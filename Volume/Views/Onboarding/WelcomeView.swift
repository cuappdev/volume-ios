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
        @Binding var page: OnboardingView.Page
        
        var body: some View {
            Group {
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
               
                Spacer()
                
                PageControl(currentPage: page == .welcome ? 0 : 1, numberOfPages: 2)
                    .padding(.bottom, 47)
                Button("Next") {
                    withAnimation(.spring()) {
                        self.page = .follow
                    }
                }
                .font(.helveticaBold(size: 16))
                .padding([.leading, .trailing], 32)
                .padding([.top, .bottom], 8)
                .foregroundColor(Color.volume.orange)
                .background(Color(white: 238 / 255))
                .cornerRadius(5)
                .shadow(color: Color.black.opacity(0.1), radius: 5)
                .padding(.bottom, 20)
            }
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
                    .foregroundColor(Color.volume.orange)
                Text(textBold)
                    .font(.begumBold(size: 16))
                    +
                    Text(textRegular)
                    .font(.begumRegular(size: 16))
                
            }
            .padding([.leading, .trailing, .top], 48)
        }
    }
}

//struct WelcomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        OnboardingView.WelcomeView()
//    }
//}
