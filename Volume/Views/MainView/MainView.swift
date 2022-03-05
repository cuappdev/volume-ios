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
    @EnvironmentObject private var notifications: Notifications
    @EnvironmentObject private var networkState: NetworkState

    init() {
        let grayColor = UIColor(Color.volume.navigationBarGray)
        UINavigationBar.appearance().backgroundColor = grayColor
        UINavigationBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundColor = grayColor
        UITabBar.appearance().clipsToBounds = true
        UITabBar.appearance().unselectedItemTintColor = UIColor(Color.volume.lightGray)
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            TabContainer(screen: .homeList) {
                HomeList()
            }
            .tabItem {
                VStack {
                    Image.volume.feed
                    Text("For You")
                }
            }
            .tag(Tab.home)
            
            TabContainer(screen: .magazinesList) {
                MagazinesList()
            }
            .tabItem {
                VStack {
                    Image.volume.magazine
                    Text("Magazines")
                }
            }
            .tag(Tab.magazines)
            
            TabContainer(screen: .publicationList) {
                PublicationList()
            }
            .tabItem {
                VStack {
                    Image.volume.pen
                    Text("Publications")
                }
            }
            .tag(Tab.publications)

            TabContainer(screen: .bookmarksList) {
                BookmarksList()
            }
            .tabItem {
                VStack {
                    Image.volume.bookmark
                    Text("Bookmarks")
                }
            }
            .tag(Tab.bookmarks)
        }
        .accentColor(Color.volume.orange)
        .onAppear {
            SwiftUIAnnounce.presentAnnouncement { presented in
                if presented {
                    AppDevAnalytics.log(VolumeEvent.announcementPresented.toEvent(.general))
                }
            }
        }
        .onOpenURL { url in
            // TODO: handle deeplink to magazines after API is finalized
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
        case home, magazines, publications, bookmarks
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

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
