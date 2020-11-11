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
        UITabBar.appearance().unselectedItemTintColor = .lightGray// UIColor(Color._lightGray)
    }
    
    var body: some View {
        NavigationView {
            TabView(selection: $selectedTab) {
                ScrollView {
                    VStack {
                        HStack {
                            UnderlinedText(text: "THE BIG READ")
                                .font(.sectionHeader2)
                            Spacer()
                        }
                        Spacer().frame(height: 30)
                        HStack {
                            UnderlinedText(text: "MORE PUBLICATIONS")
                                .font(.sectionHeader2)
                            Spacer()
                        }
                        Spacer().frame(height: 30)
                        UnderlinedText(text: "You're up to date!")
                            .font(.custom("Futura-Medium", size: 12))
                        Spacer()
                        HStack {
                            Image("volume")
                            VStack(alignment: .leading) {
                                Text("Creme de Cornell")
                                    .font(.headline)
                                Text("Some multiline text so long boo, Some multiline text so long boo, Some multiline text so long boo")
                                    .font(.subheadline)
                            }
                            Spacer()
                            VStack {
                                Button(action: {

                                }) {
                                    Image("bookmark")
                                }
                                Spacer()
                            }
                        }
                    }
                    .padding(16)
                }
                .tabItem {
                    Image("volume")
                }
                .tag(0)
                Text("Publications")
                    .tabItem {
                        Image("publications")
                }
                .tag(1)
                Text("Bookmarks")
                    .tabItem {
                        Image("bookmark")
                            .offset(x: 20, y: 50)
                }
                .tag(2)
            }.navigationBarTitle("Volume")
        }
        .accentColor(._orange)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
