//
//  MainView.swift
//  Volume
//
//  Created by Daniel Vebman on 11/30/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct MainView: View {
    @State private var selectedTab: Tab = .home
    
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
            HomeList()
            .tabItem {
                Image("volume")
            }
            .tag(Tab.home)
            
            PublicationList()
            .tabItem {
                Image("publications")
            }
            .tag(Tab.publications)
            
            BookmarksList()
            .tabItem {
                Image("bookmark")
            }
            .tag(Tab.bookmarks)
        }
        .accentColor(Color.volume.orange)
    }
}

extension MainView {
    /// An enum to keep track of which tab the user is currently on
    private enum Tab {
        case bookmarks, home, publications
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
