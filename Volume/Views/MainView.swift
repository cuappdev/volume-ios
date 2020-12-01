//
//  MainView.swift
//  Volume
//
//  Created by Daniel Vebman on 11/30/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct MainView: View {
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
