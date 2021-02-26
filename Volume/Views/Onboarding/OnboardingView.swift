//
//  OnboardingView.swift
//  Volume
//
//  Created by Daniel Vebman on 11/26/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import AppDevAnalytics
import SwiftUI

struct OnboardingView: View {
    @State private var isShowingSplash = true
    @State private var page: Page = .welcome
    @Namespace private var namespace
    @AppStorage("isFirstLaunch") private var isFirstLaunch = true
    @EnvironmentObject private var userData: UserData

    private let volumeLogoID = "volume-logo"

    private var didFollowPublication: Bool {
        userData.followedPublicationIDs.count > 0
    }

    private var splashView: some View {
        Group {
            Spacer()
            Image("volume-logo")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .padding([.leading, .trailing], 65)
                .matchedGeometryEffect(id: volumeLogoID, in: namespace)
            Spacer()
        }
    }

    private var contentView: some View {
        Group {
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
                case .follow:
                    Text("Follow student publications that you are interested in")
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                }
            }
            .font(.begumRegular(size: 16))
            .frame(height: 80)
            .padding([.leading, .trailing], 50)

            Divider()
                .background(Color.volume.buttonGray)
                .frame(width: 100)

            switch page {
            case .welcome:
                WelcomeView()
            case .follow:
                FollowView()
            }

            Spacer()

            PageControl(currentPage: page == .welcome ? 0 : 1, numberOfPages: 2)
                .padding(.bottom, 47)

            Group {
                switch page {
                case .welcome:
                    Button("Next") {
                        withAnimation(.spring()) {
                            page = .follow
                        }
                    }
                    .foregroundColor(Color.volume.orange)
                case .follow:
                    Button("Start reading") {
                        AppDevAnalytics.log(CompleteOnboarding())
                        withAnimation(.spring()) {
                            isFirstLaunch = false
                        }
                    }
                    .foregroundColor(didFollowPublication ? Color.volume.orange : Color(white: 151 / 255))
                    .disabled(!didFollowPublication)
                }
            }
            .font(.helveticaBold(size: 16))
            .padding([.leading, .trailing], 32)
            .padding([.top, .bottom], 8)
            .background(Color.volume.buttonGray)
            .cornerRadius(5)
            .shadow(color: Color.black.opacity(0.1), radius: page == .welcome || didFollowPublication ? 5 : 0)
            .padding(.bottom, 20)
        }
    }

    var body: some View {
        VStack {
            if isShowingSplash {
                splashView
            } else {
                contentView
            }
        }
        .background(Color.volume.backgroundGray)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                AppDevAnalytics.log(StartOnboarding())
                withAnimation(.spring()) {
                    isShowingSplash = false
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
