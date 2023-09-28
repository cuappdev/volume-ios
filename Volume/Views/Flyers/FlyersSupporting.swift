//
//  FlyersSupporting.swift
//  Volume
//
//  Created by Vin Bui on 6/5/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import AppDevAnalytics
import SwiftUI

struct FlyersBookmark: View {
    
    // MARK: - Properties
    
    let buttonSize: CGSize
    let flyer: Flyer
    let isPast: Bool
    let navigationSource: NavigationSource
    
    @State private var bookmarkRequestInProgress: Bool = false
    @State private var isFlyerSaved: Bool = false
    @EnvironmentObject private var userData: UserData
    
    // MARK: - UI
    
    var body: some View {
        Group {
            if isPast {
                pastBookmark
            } else {
                upcomingBookmark
            }
        }
        .onAppear {
            isFlyerSaved = userData.isFlyerSaved(flyer)
        }
        .onChange(of: userData.isFlyerSaved(flyer)) { saved in
            isFlyerSaved = saved
        }
    }
    
    @ViewBuilder
    private var pastBookmark: some View {
        if isFlyerSaved {
            Image.volume.bookmarkFilled
                .resizable()
                .scaledToFit()
                .foregroundColor(.volume.orange)
                .frame(width: buttonSize.width, height: buttonSize.height)
                .onTapGesture {
                    withAnimation {
                        Haptics.shared.play(.light)
                        toggleSaved(for: flyer)
                    }
                }
        } else {
            Image.volume.bookmark
                .resizable()
                .scaledToFit()
                .foregroundColor(.volume.orange)
                .frame(width: buttonSize.width, height: buttonSize.height)
                .onTapGesture {
                    withAnimation {
                        Haptics.shared.play(.light)
                        toggleSaved(for: flyer)
                    }
                }
        }
    }
    
    private var upcomingBookmark: some View {
        Button {
            Haptics.shared.play(.light)
            toggleSaved(for: flyer)
        } label: {
            if isFlyerSaved {
                Image.volume.bookmarkFilled
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.volume.orange)
                    .frame(width: buttonSize.width, height: buttonSize.height)
            } else {
                Image.volume.bookmark
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.volume.orange)
                    .frame(width: buttonSize.width, height: buttonSize.height)
            }
        }
        .onTapGesture {
            withAnimation(.easeInOut) {
                Haptics.shared.play(.light)
                toggleSaved(for: flyer)
            }
        }
    }
    
    // MARK: - Bookmarking Logic
    
    private func toggleSaved(for flyer: Flyer) {
        bookmarkRequestInProgress = true
        isFlyerSaved.toggle()
        userData.toggleFlyerSaved(flyer, $bookmarkRequestInProgress)
        AppDevAnalytics.log(
            VolumeEvent.bookmarkFlyer.toEvent(.flyer, value: flyer.id, navigationSource: navigationSource)
        )
    }
    
}

struct FlyersShare: View {
    
    // MARK: - Properties
    
    let buttonSize: CGSize
    let flyer: Flyer
    let isPast: Bool
    let navigationSource: NavigationSource
    
    // MARK: - UI
    
    var body: some View {
        if isPast {
            pastShare
        } else {
            upcomingShare
        }
    }
    
    private var pastShare: some View {
        Image.volume.share
            .resizable()
            .foregroundColor(.black)
            .frame(width: buttonSize.width, height: buttonSize.height)
            .onTapGesture {
                Haptics.shared.play(.light)
                AppDevAnalytics.log(
                    VolumeEvent.shareFlyer.toEvent(.flyer, value: flyer.id, navigationSource: navigationSource)
                )
                Task {
                    await FlyersView.ViewModel.displayShareScreen(for: flyer)
                }
            }
    }
    
    private var upcomingShare: some View {
        Button {
            Haptics.shared.play(.light)
            Task {
                await FlyersView.ViewModel.displayShareScreen(for: flyer)
            }
        } label: {
            Image.volume.share
                .resizable()
                .foregroundColor(.black)
                .frame(width: buttonSize.width, height: buttonSize.height)
        }
    }
    
}
