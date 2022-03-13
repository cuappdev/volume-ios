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
    @State private var selectedTab: Tab = .home
    @State private var tabBarHeight: CGFloat = 75
    @EnvironmentObject private var notifications: Notifications
    @EnvironmentObject private var networkState: NetworkState

    private var tabViewContainer: some View {
        TabView(selection: $selectedTab) {
            TabContainer(screen: .homeList) {
                HomeList()
            }
            .tag(Tab.home)
            .background(TabBarReader { tabBar in
                tabBarHeight = tabBar.bounds.height
            })
            
            TabContainer(screen: .publicationList) {
                PublicationList()
            }
            .tag(Tab.publications)

            TabContainer(screen: .bookmarksList) {
                BookmarksList()
            }
            .tag(Tab.bookmarks)
        }
    }
    
    private var floatingTabBar: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                Spacer()
                
                let iconSize = tabBarHeight * 0.35
                HStack(alignment: .top) {
                    Spacer()
                    
                    TabItem(icon: Image("volume"), size: iconSize, name: "For You")
                        .foregroundColor(selectedTab == .home ? .volume.orange : .volume.lightGray)
                        .onTapGesture { selectedTab = .home }
                    
                    Spacer()
                    
                    TabItem(icon: Image("publications"), size: iconSize, name: "Publications")
                        .foregroundColor(selectedTab == .publications ? .volume.orange : .volume.lightGray)
                        .onTapGesture { selectedTab = .publications }
                    
                    Spacer()
                    
                    TabItem(icon: Image("bookmark"), size: iconSize, name: "Bookmarks")
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
            if url.isDeeplink && url.host == ValidURLHost.article.host {
                selectedTab = .home
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
    private enum Tab {
        case home, publications, bookmarks
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
        
        var shouldDisableScroll: Bool {
            switch self {
            case .loading:
                return true
            default:
                return false
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

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
