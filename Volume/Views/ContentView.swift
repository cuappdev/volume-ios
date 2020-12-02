//
//  ContentView.swift
//  Volume
//
//  Created by Yana Sang on 10/6/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct ContentView: View {
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
             Text("Publications")
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

extension ContentView {
    private enum Tab {
        case home, publications, bookmarks
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
