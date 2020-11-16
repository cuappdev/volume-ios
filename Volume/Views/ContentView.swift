//
//  ContentView.swift
//  Volume
//
//  Created by Yana Sang on 10/6/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Tab = .publications
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor(white: 250 / 255, alpha: 0.9)
        UITabBar.appearance().clipsToBounds = true  // removes top border
        UITabBar.appearance().unselectedItemTintColor = UIColor(Color(white: 153 / 255, opacity: 1))
                
        UIView.appearance().backgroundColor = UIColor.clear
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Text("Home Feed")
                .tabItem {
                    Image("volume")
                }
                .tag(Tab.home)
            PublicationList()
                .tabItem {
                    Image("publications")
                }
                .tag(Tab.publications)
            Text("Bookmarks")
                .tabItem {
                    Image("bookmark")
                }
                .tag(Tab.bookmarks)
        }
        .accentColor(.volumeOrange)
    }
}

/// An enum to keep track of which tab the user is currently on
enum Tab {
    case bookmarks
    case home
    case publications
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
