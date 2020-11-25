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
        let grayColor = UIColor(Color.volume.navigationBarGray)
        UINavigationBar.appearance().backgroundColor = grayColor
        UINavigationBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundColor = grayColor
        UITabBar.appearance().clipsToBounds = true
        UITabBar.appearance().unselectedItemTintColor = UIColor(Color.volume.lightGray)
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationView {
                Text("Home")
                    .toolbar {
                        ToolbarItem(placement: ToolbarItemPlacement.navigationBarLeading) {
                            Image("volume-logo")
                        }
                    }
                    .navigationBarTitleDisplayMode(.inline)
            }
            .tabItem {
                Image("volume")
            }
            .tag(Tab.home)
            
            PublicationList()
            .tabItem {
                Image("publications")
            }
            .tag(Tab.publications)
            
            NavigationView {
                Text("Bookmarks")
                    .toolbar {
                        ToolbarItem(placement: ToolbarItemPlacement.navigationBarLeading) {
                            BubblePeriodText("Bookmarks")
                                .font(.begumMedium(size: 24))
                                .offset(y: 8)
                        }
                    }
                    .navigationBarTitleDisplayMode(.inline)
            }
            .tabItem {
                Image("bookmark")
            }
            .tag(Tab.bookmarks)
        }
        .accentColor(Color.volume.orange)
    }
}

extension ContentView {
    /// An enum to keep track of which tab the user is currently on
    private enum Tab {
        case bookmarks, home, publications
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
