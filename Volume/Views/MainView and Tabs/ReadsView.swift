//
//  ReadsView.swift
//  Volume
//
//  Created by Vin Bui on 4/2/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct ReadsView: View {
    
    // MARK: - Properties
    @StateObject private var viewModel = ViewModel()
    
    init() {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithTransparentBackground()
        navBarAppearance.backgroundColor = UIColor(Constants.backgroundColor)

        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().compactAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
    }
    
    // MARK: - Constants
    
    private struct Constants {
        static let articlesTabWidth: CGFloat = 80
        static let browserViewNavigationTitleKey: String = "BrowserView"
        static let hamburgerLineHeight: CGFloat = 1
        static let hamburgerLineSpacing: CGFloat = 7
        static let hamburgerLineWidth: CGFloat = 25
        static let hamburgerSidePadding: CGFloat = 30
        static let magazinesTabWidth: CGFloat = 106
        static let magazineNavigationTitleKey = "MagazineReaderView"
        static let searchTopPadding: CGFloat = 8
        static let titleFont: Font = .newYorkMedium(size: 28)
        
        static var backgroundColor: Color {
            if #available(iOS 16.0, *) {
                return Color.volume.backgroundGray
            } else {
                return Color.white
            }
        }
    }
    
    // MARK: - UI
    
    var body: some View {
        ZStack {
            background.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: Constants.searchTopPadding) {
                HStack {
                    tabBar
                    
                    Spacer()
                    
                    hamburgerMenu
                        .onTapGesture {
                            Haptics.shared.play(.light)
                        }
                }
                
                scrollContent
            }
            .background(Color.volume.backgroundGray)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    title
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .onOpenURL { url in
                viewModel.handleURL(url)
            }
        }
    }
    
    private var title: some View {
        BubblePeriodText("Reads")
            .font(Constants.titleFont)
            .offset(y: 8)
    }
    
    private var tabBar: some View {
        SlidingTabBarView(
            selectedTab: $viewModel.selectedTab,
            items: [
                SlidingTabBarView.Item(
                    title: "Articles",
                    tab: .articles,
                    width: Constants.articlesTabWidth
                ),
                SlidingTabBarView.Item(
                    title: "Magazines",
                    tab: .magazines,
                    width: Constants.magazinesTabWidth
                )
            ]
        )
    }
    
    private var hamburgerMenu: some View {
        VStack(spacing: Constants.hamburgerLineSpacing) {
            Rectangle()
                .frame(width: Constants.hamburgerLineWidth, height: Constants.hamburgerLineHeight)
            Rectangle()
                .frame(width: Constants.hamburgerLineWidth, height: Constants.hamburgerLineHeight)
            Rectangle()
                .frame(width: Constants.hamburgerLineWidth, height: Constants.hamburgerLineHeight)
        }
        .padding(.top)
        .padding(.trailing, Constants.hamburgerSidePadding)
    }
    
    private var scrollContent: some View {
        Group {
            switch viewModel.selectedTab {
            case .articles:
                ArticlesView()
            case .magazines:
                MagazinesView()
            }
        }
    }
    
    // MARK: - Deeplink
    
    private var background: some View {
        ZStack {
            deepNavigationLink
            Constants.backgroundColor
        }
    }

    private var deepNavigationLink: some View {
        Group {
            if viewModel.openArticleFromDeeplink, let articleID = viewModel.deeplinkID {
                NavigationLink(Constants.browserViewNavigationTitleKey, isActive: $viewModel.openArticleFromDeeplink) {
                    BrowserView(initType: .fetchRequired(articleID), navigationSource: .otherArticles)
                }
                .hidden()
            }
            
            if viewModel.openMagazineFromDeeplink, let magazineID = viewModel.deeplinkID {
                NavigationLink(Constants.magazineNavigationTitleKey, isActive: $viewModel.openMagazineFromDeeplink) {
                    MagazineReaderView(initType: .fetchRequired(magazineID), navigationSource: .moreMagazines)
                }
                .hidden()
            }
        }
    }
}

//struct ReadsView_Previews: PreviewProvider {
//    static var previews: some View {
//        ReadsView()
//    }
//}
