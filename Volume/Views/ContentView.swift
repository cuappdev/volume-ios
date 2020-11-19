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
                HStack(alignment: .center) {
                    Spacer()
                    VStack {
                        Spacer()
                        UnderlinedText("Saved Articles")
                            .font(.begumMedium(size: 20))
                        UnderlinedText("Articles")
                            .font(.begumMedium(size: 30))
                        UnderlinedText("And a really long one too!")
                            .font(.begumBold(size: 15))
                        Spacer()
                    }
                    Spacer()
                }
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
                HStack {
                    Spacer()
                    VStack {
                        Spacer()
                        Text("Publications")
                        Spacer()
                    }
                    Spacer()
                }
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
                HStack {
                    Spacer()
                    VStack {
                        Spacer()
                        Text("Bookmarks")
                        Spacer()
                    }
                    Spacer()
                }
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
        .accentColor(._orange)
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
