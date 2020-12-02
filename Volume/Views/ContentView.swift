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
        let grayColor = UIColor(Color._gray)
        UINavigationBar.appearance().backgroundColor = grayColor
        UINavigationBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundColor = grayColor
        UITabBar.appearance().clipsToBounds = true
        UITabBar.appearance().unselectedItemTintColor = UIColor(Color._lightGray)
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationView {
                Text("Home")
                    .background(Color._gray)
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
            
            NavigationView {
                Text("Publications")
                    .background(Color._gray)
                    .toolbar {
                        ToolbarItem(placement: ToolbarItemPlacement.navigationBarLeading) {
                            BubblePeriodText("Publications")
                                .font(.begumMedium(size: 24))
                                .offset(y: 8)
                        }
                    }
                    .navigationBarTitleDisplayMode(.inline)
            }
            .tabItem {
                Image("publications")
            }
            .tag(Tab.publications)
            
            NavigationView {
                Text("Bookmarks")
                    .background(Color._gray)
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
        .accentColor(.volumeOrange)
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
