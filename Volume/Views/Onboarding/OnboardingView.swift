//
//  OnboardingView.swift
//  Volume
//
//  Created by Daniel Vebman on 11/26/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct OnboardingView: View {
    @State private var isShowingSplash = true
    @State private var page: Page = .follow
    @Namespace private var namespace
    
    private let volumeLogoID = "volume-logo"
    
    var body: some View {
        VStack {
            if isShowingSplash {
                Spacer()
                Image("volume-logo")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .padding([.leading, .trailing], 65)
                    .matchedGeometryEffect(id: volumeLogoID, in: namespace)
                Spacer()
            } else {
                Image("volume-logo")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .padding([.leading, .trailing], 65)
                    .padding(.top, 25)
                    .matchedGeometryEffect(id: volumeLogoID, in: namespace)
                
                Group {
                    switch page {
                    case .welcome:
                        Text("Welcome to Volume")
                            .padding([.top, .bottom], 32)
                            .transition(.asymmetric(insertion: .opacity, removal: .move(edge: .leading)))
                    case .follow:
                        Text("Follow student publications that you are interested in")
                            .padding([.top, .bottom], 20.75)
                            .multilineTextAlignment(.center)
                            .lineSpacing(4)
                            .transition(.move(edge: .trailing))
                    }
                }
                .font(.begumRegular(size: 16))
                .padding([.leading, .trailing], 50)
                
                Divider()
                    .background(Color(white: 238 / 255))
                    .frame(width: 100)
                
                switch page {
                case .welcome:
                    WelcomeView(page: $page)
                case .follow:
                    FollowView(page: $page)
                }
            }
        }
        .background(Color.volume.backgroundGray)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation {
                    self.isShowingSplash = false
                }
            }
        }
    }
}

extension OnboardingView {
    enum Page {
        case welcome, follow
    }
    
    struct PageControl: View {
        private let selectedColor = Color(white: 153 / 255)
        private let unselectedColor = Color(white: 196 / 255)
        
        let currentPage: Int
        let numberOfPages: Int
        
        var body: some View {
            HStack(spacing: 12) {
                ForEach(0..<numberOfPages) { i in
                    Circle()
                        .fill(i == currentPage ? selectedColor : unselectedColor)
                        .frame(width: 6, height: 6)
                }
            }
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
