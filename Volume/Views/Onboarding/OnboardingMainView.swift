//
//  OnboardingMainView.swift
//  Volume
//
//  Created by Vin Bui on 4/22/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import AppDevAnalytics
import Combine
import SwiftUI

struct OnboardingMainView: View {
    
    // MARK: - Properties
    
    @State private var nextButtonMessage: String = "Next"
    @State private var createUserMutation: AnyCancellable?
    @State private var isShowingSplash: Bool = true
    @State private var onboardingPage: OnboardingPage = .welcome
    
    @AppStorage("isFirstLaunch") private var isFirstLaunch: Bool = true
    @Namespace private var namespace
    @EnvironmentObject private var userData: UserData
    
    // MARK: - Constants
    
    private struct Constants {
        static let animationDelay: Double = 3
        static let buttonCornerRadius: CGFloat = 10
        static let buttonFont: Font = .helveticaNeueMedium(size: 16)
        static let buttonStrokeWidth: CGFloat = 2
        static let dividerWidth: CGFloat = 100
        static let lottieFilename: String = "volume_logo"
        static let lottieViewSize: CGSize = CGSize(width: 300, height: 150)
        static let messageFont: Font = .newYorkRegular(size: 16)
        static let nextHoriPadding: CGFloat = 24
        static let nextVertPadding: CGFloat = 10
        static let volumeLogoID: String = "volume-logo"
    }
    
    // MARK: - UI
    
    var body: some View {
        VStack {
            if isShowingSplash {
                splashView
            } else {
                contentView
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + Constants.animationDelay) {
                AppDevAnalytics.log(VolumeEvent.startOnboarding.toEvent(.general))
                withAnimation(.spring()) {
                    isShowingSplash = false
                }
            }
        }
    }
    
    @ViewBuilder
    private var splashView: some View {
        Spacer()
        
        LottieView(filename: Constants.lottieFilename, play: true)
            .frame(width: Constants.lottieViewSize.width, height: Constants.lottieViewSize.height)
            .matchedGeometryEffect(id: Constants.volumeLogoID, in: namespace)
        
        Spacer()
    }
    
    private var contentView: some View {
        VStack {
            headerSection
            
            Spacer()
            
            switch onboardingPage {
            case .welcome:
                OnboardingWelcomeView()
            case .flyers:
                OnboardingFlyersView()
            case .publications:
                OnboardingPublicationsView()
            }
            
            Spacer()
            Spacer()
            
            Group {
                switch onboardingPage {
                case .welcome:
                    PageControl(currentPage: 0, numberOfPages: 3)
                case .flyers:
                    PageControl(currentPage: 1, numberOfPages: 3)
                case .publications:
                    PageControl(currentPage: 2, numberOfPages: 3)
                }
            }
            .padding(.bottom)
            
            nextButton
            
            Spacer()
        }
    }
    
    @ViewBuilder
    private var nextButton: some View {
        Button {
            withAnimation(.spring()) {
                setNextButton()
            }
        } label: {
            Text(nextButtonMessage)
                .padding(.init(
                    top: Constants.nextVertPadding,
                    leading: Constants.nextHoriPadding,
                    bottom: Constants.nextVertPadding,
                    trailing: Constants.nextHoriPadding
                ))
                .font(Constants.buttonFont)
                .foregroundColor(Color.volume.orange)
                .overlay(
                    RoundedRectangle(cornerRadius: Constants.buttonCornerRadius)
                        .stroke(Color.volume.orange, lineWidth: Constants.buttonStrokeWidth)
                )
        }
        .padding(.bottom)
    }
    
    @ViewBuilder
    private var headerSection: some View {
        LottieView(filename: Constants.lottieFilename, play: false)
            .frame(width: Constants.lottieViewSize.width, height: Constants.lottieViewSize.height)
            .matchedGeometryEffect(id: Constants.volumeLogoID, in: namespace)
        
        Group {
            switch onboardingPage {
            case .welcome:
                Text("Welcome to Volume")
            case .flyers:
                Text("Check out upcoming flyers from student organizations")
            case .publications:
                Text("Follow student publications that you are interested in")
            }
        }
        .multilineTextAlignment(.center)
        .font(Constants.messageFont)
        .fixedSize(horizontal: false, vertical: true)
        
        Divider()
            .background(Color.volume.buttonGray)
            .frame(width: Constants.dividerWidth)
    }
    
    // MARK: - Helpers
    
    private func setNextButton() {
        switch onboardingPage {
        case .welcome:
            onboardingPage = .flyers
            nextButtonMessage = "Next"
        case .flyers:
            onboardingPage = .publications
            nextButtonMessage = "Start reading"
        case .publications:
            AppDevAnalytics.log(VolumeEvent.completeOnboarding.toEvent(.general))
            createUser()
            nextButtonMessage = "Start reading"
        }
    }
    
    private func createUser() {
        guard let fcmToken = userData.fcmToken else {
            #if DEBUG
            print("Error: received nil for fcmToken from UserData")
            #endif
            return
        }

        createUserMutation = Network.shared.publisher(for: CreateUserMutation(deviceToken: fcmToken, followedPublicationSlugs: userData.followedPublicationSlugs))
            .map { $0.user.uuid }
            .sink { completion in
                if case let .failure(error) = completion {
                    print("Error: failed to create user: \(error.localizedDescription)")
                }
            } receiveValue: { uuid in
                userData.uuid = uuid
                #if DEBUG
                print("User successfully created with UUID: \(uuid)")
                #endif
                withAnimation(.spring()) {
                    isFirstLaunch = false
                }
            }
    }
    
}

extension OnboardingMainView {
    
    enum OnboardingPage {
        case welcome, flyers, publications
    }
    
    struct PageControl: View {
        private let selectedColor = Color(white: 153 / 255)
        private let unselectedColor = Color(white: 196 / 255)

        let currentPage: Int
        let numberOfPages: Int

        var body: some View {
            HStack(spacing: 12) {
                ForEach(0..<numberOfPages, id: \.self) { i in
                    Circle()
                        .fill(i == currentPage ? selectedColor : unselectedColor)
                        .frame(width: 6, height: 6)
                }
            }
        }
    }
    
}

// MARK: - Uncomment below if needed

//struct OnboardingView_Previews: PreviewProvider {
//    static var previews: some View {
//        OnboardingView()
//    }
//}
