//
//  MainView.swift
//  Volume
//
//  Created by Daniel Vebman on 11/30/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import AppDevAnalytics
import AppDevAnnouncements
import SwiftUI

struct MainView: View {
    @State private var selectedTab: Screen = .home
    @State private var tabBarHeight: CGFloat = 75
    @EnvironmentObject private var notifications: Notifications

    private var tabViewContainer: some View {
        TabView(selection: $selectedTab) {
            TabContainer(screen: .home) {
                HomeView()
            }
            .tag(Screen.home)

            #if DEBUG
            TabContainer(screen: .magazines) {
                MagazinesList()
            }
            .tag(Screen.magazines)
            #endif

            TabContainer(screen: .publications) {
                PublicationList()
            }
            .tag(Screen.publications)
            
            TabContainer(screen: .bookmarks) {
                BookmarksList()
            }
            .tag(Screen.bookmarks)
        }
    }
    
    private var floatingTabBar: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                Spacer()
                
                let iconSize = tabBarHeight * 0.35
                HStack(alignment: .top) {
                    Spacer()
                    
                    TabItem(icon: .volume.feed, size: iconSize, name: "For You")
                        .foregroundColor(selectedTab == .home ? .volume.orange : .volume.lightGray)
                        .onTapGesture { selectedTab = .home }

                    #if DEBUG
                    Spacer()

                    TabItem(icon: .volume.magazine, size: iconSize, name: "Magazines")
                        .foregroundColor(selectedTab == .magazines ? .volume.orange : .volume.lightGray)
                        .onTapGesture { selectedTab = .magazines }
                    #endif

                    Spacer()
                    
                    TabItem(icon: .volume.pen, size: iconSize, name: "Publications")
                        .foregroundColor(selectedTab == .publications ? .volume.orange : .volume.lightGray)
                        .onTapGesture { selectedTab = .publications }
                    
                    Spacer()
                    
                    TabItem(icon: .volume.bookmark, size: iconSize, name: "Bookmarks")
                        .foregroundColor(selectedTab == .bookmarks ? .volume.orange : .volume.lightGray)
                        .onTapGesture { selectedTab = .bookmarks }
                    
                    Spacer()
                }
                .padding(.top, iconSize * 0.3)
                .padding(.bottom, geometry.safeAreaInsets.bottom * 0.5)
                .frame(width: geometry.size.width, height: tabBarHeight)
                .background(Color.white)
            }
            .edgesIgnoringSafeArea(.bottom)
        }
    }
    
    var body: some View {
        ZStack {
            tabViewContainer
            floatingTabBar
        }
        .onAppear {
            SwiftUIAnnounce.presentAnnouncement { presented in
                if presented {
                    AppDevAnalytics.log(VolumeEvent.announcementPresented.toEvent(.general))
                }
            }
        }
        .onOpenURL { url in
            guard url.isDeeplink else {
                return
            }

            switch url.host {
            case ValidURLHost.article.host:
                selectedTab = .home
            case ValidURLHost.magazine.host:
                selectedTab = .magazines
            default:
                break
            }
        }
        .onChange(of: notifications.isWeeklyDebriefOpen) { isOpen in
            if isOpen {
                selectedTab = .home
            }
        }
    }
}

extension MainView {
    /// An enum to keep track of which tab the user is currently on
    private enum Screen {
        case home, magazines, publications, bookmarks, weeklyDebriefPopup
    }
    
    enum TabState<Results> {
        case loading
        case reloading(Results)
        case results(Results)
        
        var isLoading: Bool {
            switch self {
            case .results:
                return false
            default:
                return true
            }
        }
    }
}

extension MainView {
    private struct TabItem: View {
        let icon: Image
        let size: CGFloat
        let name: String
        
        var body: some View {
            VStack(alignment: .center, spacing: 0) {
                Spacer()
                
                icon
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: size, height: size)
                
                Spacer(minLength: 4)
                
                Text(name)
                    .font(.helveticaRegular(size: 10))
                    .multilineTextAlignment(.center)
                
                Spacer()
            }
            .frame(width: 75)
        }
    }
}
