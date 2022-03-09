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
    @State private var selectedTab: Tab = .home
    @EnvironmentObject private var notifications: Notifications
    @EnvironmentObject private var networkState: NetworkState

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                switch selectedTab {
                case .home:
                    TabContainer(screen: .homeList) {
                        HomeList()
                    }
                    .tag(Tab.home)
                case .publications:
                    TabContainer(screen: .publicationList) {
                        PublicationList()
                    }
                    .tag(Tab.publications)
                case .bookmarks:
                    TabContainer(screen: .bookmarksList) {
                        BookmarksList()
                    }
                    .tag(Tab.bookmarks)
                }
                
                HStack(alignment: .top) {
                    Spacer()
                    
                    TabItem(icon: Image("volume"), name: "For You")
                        .foregroundColor(selectedTab == .home ? .volume.orange : .volume.lightGray)
                        .onTapGesture { selectedTab = .home }
                    
                    Spacer()
                    
                    TabItem(icon: Image("publications"), name: "Publications")
                        .foregroundColor(selectedTab == .publications ? .volume.orange : .volume.lightGray)
                        .onTapGesture { selectedTab = .publications }
                    
                    Spacer()
                    
                    TabItem(icon: Image("bookmark"), name: "Bookmarks")
                        .foregroundColor(selectedTab == .bookmarks ? .volume.orange : .volume.lightGray)
                        .onTapGesture { selectedTab = .bookmarks }
                    
                    Spacer()
                }
                .frame(width: geometry.size.width, height: 75 + geometry.safeAreaInsets.bottom * 0.4)
                .background(Color.white)
            }
            .edgesIgnoringSafeArea(.bottom)
        }
        .onAppear {
            SwiftUIAnnounce.presentAnnouncement { presented in
                if presented {
                    AppDevAnalytics.log(VolumeEvent.announcementPresented.toEvent(.general))
                }
            }
        }
        .onOpenURL { url in
            if url.isDeeplink && url.host == ValidURLHost.article.host {
                selectedTab = .home
            }
        }
        .onChange(of: notifications.isWeeklyDebriefOpen) { isOpen in
            if isOpen {
                selectedTab = .home
            }
        }
    }
}

extension MainView {
    /// An enum to keep track of which tab the user is currently on
    private enum Tab {
        case home, publications, bookmarks
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
        
        var shouldDisableScroll: Bool {
            switch self {
            case .loading:
                return true
            default:
                return false
            }
        }
    }
}

extension MainView {
    private struct TabItem: View {
        let icon: Image
        let name: String
        
        var body: some View {
            VStack(alignment: .center) {
                icon
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30)
                    .padding(.top, 13)
                Text(name)
                    .font(.footnote)
                    .multilineTextAlignment(.center)
                Spacer()
            }
            .frame(width: 75)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
