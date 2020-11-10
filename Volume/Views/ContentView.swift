//
//  ContentView.swift
//  Volume
//
//  Created by Yana Sang on 10/6/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State private var selectedTab = 1
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor(white: 250/255, alpha: 0.9)
        UITabBar.appearance().clipsToBounds = true  // removes top border
        UITabBar.appearance().unselectedItemTintColor = UIColor(Color(white: 153/255, opacity: 1))
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Text("Home Feed")
                .tabItem {
                    Image("volume")
                }
                .tag(0)
            PublicationList()
                .tabItem {
                    Image("publications")
                }
                .tag(1)
            Text("Bookmarks")
                .tabItem {
                    Image("bookmark")
                }
                .tag(2)
        }
        .accentColor(._orange)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
