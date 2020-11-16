//
//  ContentView.swift
//  Volume
//
//  Created by Yana Sang on 10/6/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State private var selectedTab = 0
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor(white: 250 / 255, alpha: 0.9)
        UITabBar.appearance().clipsToBounds = true  // removes top border
        UITabBar.appearance().unselectedItemTintColor = UIColor(Color.lightGray)
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeList()
                .tabItem {
                    Image("volume")
                }
                .tag(0)
            Text("Publications")
                .tabItem {
                    Image("publications")
                }
                .tag(1)
            BookmarksList()
                .tabItem {
                    Image("bookmark")
                        .offset(x: 20, y: 50)
                }
                .tag(2)
        }
        .accentColor(.volumeOrange)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
