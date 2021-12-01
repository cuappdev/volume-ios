//
//  OnboardingView.swift
//  Volume
//
//  Created by Daniel Vebman on 11/26/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import AppDevAnalytics
import Combine
import SwiftUI

struct OnboardingView: View {
    @State private var isShowingSplash = true
    @State private var page: Page = .welcome
    @State private var cancellableCreateUserMutation: AnyCancellable?
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
                .padding(.bottom, 30)

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
                    Button(action: {
                        withAnimation(.spring()) {
                            page = .follow
                        }
                    }, label: {
                        Text("Next")
                            .padding([.top, .bottom], 10)
                            .padding([.leading, .trailing], 24)
                    })
                    .foregroundColor(Color.volume.orange)
                case .follow:
                    Button(action: {
                        AppDevAnalytics.log(VolumeEvent.completeOnboarding.toEvent(.general))
                        createUser()
                    }, label: {
                        Text("Start reading")
                            .padding([.top, .bottom], 10)
                            .padding([.leading, .trailing], 24)
                    })
                    .foregroundColor(didFollowPublication ? Color.volume.orange : Color(white: 151 / 255))
                    .disabled(!didFollowPublication)
                }
            }
            .overlay(
                RoundedRectangle(cornerRadius:10)
                    .stroke(didFollowPublication || page == .welcome ? Color.volume.orange : Color(white: 151 / 255), lineWidth: 2)
            )
            .font(.latoBold(size: 16))
            .padding([.leading, .trailing], 32)
            .padding(.top, 8)
            .padding(.bottom, 28)
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
        .background(Color.volume.backgroundGray.ignoresSafeArea())
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                AppDevAnalytics.log(VolumeEvent.startOnboarding.toEvent(.general))
                withAnimation(.spring()) {
                    isShowingSplash = false
                }
            }
        }
    }
    
    // MARK: Actions
    
    private func createUser() {
        guard let deviceToken = userData.deviceToken else {
            print("Error: received nil for deviceToken from UserData")
            return
        }
        
        cancellableCreateUserMutation = Network.shared.publisher(for: CreateUserMutation(deviceToken: deviceToken, followedPublicationIDs: userData.followedPublicationIDs))
            .map { $0.user.uuid }
            .sink { completion in
                if case let .failure(error) = completion {
                    print("An error occurred in creating user: \(error)")
                }
            } receiveValue: { uuid in
                userData.uuid = uuid
                withAnimation(.spring()) {
                    isFirstLaunch = false
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
