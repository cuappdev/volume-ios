//
//  MainView.swift
//  Volume
//
//  Created by Daniel Vebman on 11/30/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import AppDevAnalytics
import AppDevAnnouncements
import SwiftUI

struct MainView: View {
    
    @State private var offset: CGFloat = 0
    @State private var selectedTab: Screen = .trending
    @State private var showPublication: Bool = false
    @State private var tabBarHeight: CGFloat = UIScreen.main.bounds.height * 0.10
    @EnvironmentObject private var notifications: Notifications

    private var tabViewContainer: some View {
        TabView(selection: $selectedTab) {
            TabContainer(screen: .trending) {
                TrendingView()
            }
            .tag(Screen.trending)

            TabContainer(screen: .flyers) {
                FlyersView()
            }
            .tag(Screen.flyers)

            TabContainer(screen: .reads) {
                ReadsView(showPublication: $showPublication)
            }
            .tag(Screen.reads)
            
            TabContainer(screen: .bookmarks) {
                BookmarksView()
            }
            .tag(Screen.bookmarks)
        }
        .padding(.bottom, 16)
        .edgesIgnoringSafeArea(.all)
    }
    
    private var floatingTabBar: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                Spacer()
                
                let iconSize = tabBarHeight * 0.3
                HStack(alignment: .top) {
                    Spacer()
                    
                    TabItem(icon: .volume.feed, size: iconSize, name: "Trending")
                        .foregroundColor(selectedTab == .trending ? .volume.orange : .volume.lightGray)
                        .onTapGesture {
                            selectedTab = .trending
                            AppDevAnalytics.log(VolumeEvent.tapTrendingPage.toEvent(.page))
                        }

                    Spacer()

                    TabItem(icon: .volume.flyer, size: iconSize, name: "Flyers")
                        .foregroundColor(selectedTab == .flyers ? .volume.orange : .volume.lightGray)
                        .onTapGesture {
                            selectedTab = .flyers
                            AppDevAnalytics.log(VolumeEvent.tapFlyersPage.toEvent(.page))
                        }

                    Spacer()
                    
                    TabItem(icon: .volume.magazine, size: iconSize, name: "Reads")
                        .foregroundColor(selectedTab == .reads ? .volume.orange : .volume.lightGray)
                        .onTapGesture {
                            selectedTab = .reads
                            AppDevAnalytics.log(VolumeEvent.tapReadsPage.toEvent(.page))
                        }
                    
                    Spacer()
                    
                    TabItem(icon: .volume.bookmark, size: iconSize, name: "Bookmarks")
                        .foregroundColor(selectedTab == .bookmarks ? .volume.orange : .volume.lightGray)
                        .onTapGesture {
                            selectedTab = .bookmarks
                            AppDevAnalytics.log(VolumeEvent.tapBookmarksPage.toEvent(.page))
                        }
                    
                    Spacer()
                }
                .padding(.top, iconSize * 0.2)
                .padding(.bottom, geometry.safeAreaInsets.bottom * 0.7)
                .frame(width: geometry.size.width, height: tabBarHeight)
                .background(Color.white)
            }
            .edgesIgnoringSafeArea(.bottom)
        }
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack(alignment: .trailing) {
                    tabViewContainer
                    floatingTabBar
                    
                    ZStack(alignment: .trailing) {
                        Color.black.opacity(0.0001)
                            .ignoresSafeArea(.all)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                withAnimation { showPublication.toggle() }
                            }
                        
                        Rectangle()
                            .frame(width: geometry.size.width * 0.8)
                            .shadow(radius: 10)
                        
                        PublicationList(showPublication: $showPublication)
                            .frame(width: geometry.size.width * 0.8)
                    }
                    .offset(x: showPublication ? offset : UIScreen.main.bounds.width)
                    .animation(.spring(), value: showPublication)
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                if gesture.translation.width > 0 {
                                    offset = gesture.translation.width
                                }
                            }
                            .onEnded { _ in
                                if offset > 125 {
                                    showPublication = false
                                }
                                withAnimation { offset = 0 }
                            }
                    )
                }
                .onAppear {
                    SwiftUIAnnounce.presentAnnouncement { presented in
                        if presented {
                            AppDevAnalytics.log(VolumeEvent.announcementPresented.toEvent(.general))
                        }
                    }
                }
                .onOpenURL { url in
                    guard url.isDeeplink else {
                        return
                    }

                    switch url.contentType {
                    case .article:
                        if selectedTab != .reads {
                            selectedTab = .reads
                            UIApplication.shared.open(url)
                        }
                    case .magazine:
                        if selectedTab != .reads {
                            selectedTab = .reads
                            UIApplication.shared.open(url)
                        }
                    default:
                        break
                    }
                }
                .onChange(of: notifications.isWeeklyDebriefOpen) { isOpen in
                    if isOpen {
                        selectedTab = .trending
                    }
                }
            }
        }
    }
    
}

extension MainView {
    /// An enum to keep track of which tab the user is currently on
    private enum Screen {
        case trending, flyers, reads, publications, bookmarks, weeklyDebriefPopup
    }
    
    enum TabState<Results> {
        case loading
        case reloading(Results)
        case results(Results)
        
        var isLoading: Bool {
            switch self {
            case .results:
                return false
            default:
                return true
            }
        }
    }
}

extension MainView {
    private struct TabItem: View {
        let icon: Image
        let size: CGFloat
        let name: String
        
        var body: some View {
            VStack(alignment: .center, spacing: 0) {
                Spacer()
                
                icon
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: size, height: size)
                
                Spacer(minLength: 4)
                
                Text(name)
                    .font(.helveticaRegular(size: 10))
                    .multilineTextAlignment(.center)
                
                Spacer()
            }
            .frame(width: 75)
        }
    }
}
