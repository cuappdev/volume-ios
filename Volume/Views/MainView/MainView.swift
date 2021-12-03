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
                HomeList(dummyArticle: nil)
            }
            .tabItem {
                Image("volume")
            }
            .tag(Tab.home)
            TabContainer(screen: .publicationList) {
                PublicationList()
            }
            .tabItem {
                Image("publications")
            }
            .tag(Tab.publications)

            TabContainer(screen: .bookmarksList) {
                BookmarksList()
            }
            .tabItem {
                Image("bookmark")
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
            if url.isDeeplink && url.host == ValidURLHost.article.host {
                selectedTab = .home
            }
        }
        .onChange(of: notifications.openedWeeklyDebrief) { newValue in
            if newValue {
                selectedTab = .home
            }
        }
    }
}

extension MainView {
    /// An enum to keep track of which tab the user is currently on
    private enum Tab {
        case bookmarks, home, publications
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
