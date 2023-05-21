//
//  TrendingView.swift
//  Volume
//
//  Created by Vin Bui on 4/2/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct TrendingView: View {
    
    // MARK: - Properties
    
    @EnvironmentObject private var networkState: NetworkState
    @EnvironmentObject private var userData: UserData
    @StateObject private var viewModel = ViewModel()
    
    // MARK: - Constants
    
    private struct Constants {
        static let backgroundColor: Color = Color.volume.backgroundGray
        static let endMessageWidth: CGFloat = 250
        static let gridColumns: Array = Array(repeating: GridItem(.flexible()), count: 2)
        static let sidePadding: CGFloat = 16
        static let mainArticleSkeletonHeight: CGFloat = 480
        static let magazineVerticalSpacing: CGFloat = 30
        static let sectionSpacing: CGFloat = 40
        static let subArticlesSpacing: CGFloat = 16
    }
    
    // MARK: - UI
    
    var body: some View {
        RefreshableScrollView { done in
            viewModel.refreshContent(done)
        } content: {
            LazyVStack(spacing: Constants.sectionSpacing) {
                mainArticleSection
                subArticlesSection
                flyersSection
                magazinesSection
                endSection
            }
            .padding(.horizontal, Constants.sidePadding)
        }
        .background(Constants.backgroundColor)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Image.volume.logo
            }
        }
        .onAppear {
            viewModel.setupEnvironment(networkState: networkState, userData: userData)
            if viewModel.mainArticle == nil || viewModel.subArticles == nil {
                Task {
                    await viewModel.fetchContent()
                }
            }
        }
    }
    
    // MARK: - Sections
    
    private var mainArticleSection: some View {
        Section {
            switch viewModel.mainArticle {
            case .none:
                SkeletonView()
                    .frame(width: UIScreen.main.bounds.width, height: Constants.mainArticleSkeletonHeight)
                    .shimmer(.largeShimmer())
            case .some(let article):
                NavigationLink {
                    BrowserView(initType: .readyForDisplay(article), navigationSource: .trendingArticles)
                } label: {
                    TrendingMainArticleCell(article: article, urlImageModel: URLImageModel(urlString: article.imageUrl?.absoluteString ?? ""))
                }
                .buttonStyle(EmptyButtonStyle())
            }
        }
        .padding(.top, 0.5 * Constants.sectionSpacing)
    }
    
    private var subArticlesSection: some View {
        Section {
            VStack(spacing: Constants.subArticlesSpacing) {
                switch viewModel.subArticles {
                case .none:
                    ArticleRow.Skeleton()
                    ArticleRow.Skeleton()
                    ArticleRow.Skeleton()
                case .some(let articles):
                    ForEach(articles) { article in
                        NavigationLink {
                            BrowserView(initType: .readyForDisplay(article), navigationSource: .trendingArticles)
                        } label: {
                            ArticleRow(article: article, navigationSource: .trendingArticles)
                        }
                    }
                }
            }
        }
    }
    
    private var flyersSection: some View {
        Section {
            VStack(spacing: Constants.sectionSpacing) {
                switch viewModel.flyers {
                case .none:
                    Group {
                        TrendingFlyerCell.Skeleton()
                        TrendingFlyerCell.Skeleton()
                    }
                    .frame(maxWidth: .infinity)
                case .some(let flyers):
                    ForEach(flyers) { flyer in
                        TrendingFlyerCell(flyer: flyer, urlImageModel: URLImageModel(urlString: flyer.imageURL))
                    }
                }
            }
        }
        .task {
            // Fetch asynchronously only when in view
            switch viewModel.flyers {
            case .none:
                await viewModel.fetchFlyers()
            case .some(_):
                break
            }
        }
    }
    
    private var magazinesSection: some View {
        Section {
            LazyVGrid(columns: Constants.gridColumns, spacing: Constants.magazineVerticalSpacing) {
                switch viewModel.magazines {
                case .none:
                    MagazineCell.Skeleton()
                    MagazineCell.Skeleton()
                    MagazineCell.Skeleton()
                    MagazineCell.Skeleton()
                case .some(let magazines):
                    ForEach(magazines) { magazine in
                        NavigationLink {
                            MagazineReaderView(initType: .readyForDisplay(magazine), navigationSource: .featuredMagazines)
                        } label: {
                            MagazineCell(magazine: magazine)
                        }
                    }
                }
            }
        }
        .task {
            // Fetch asynchronously only when in view
            switch viewModel.magazines {
            case .none:
                await viewModel.fetchMagazines()
            case .some(_):
                break
            }
        }
    }
    
    private var endSection: some View {
        Section {
            Group {
                VolumeMessage(message: .upToDateFlyers, largeFont: false, fullWidth: true)
                    .frame(width: Constants.endMessageWidth)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.top, Constants.sectionSpacing)
            .padding(.bottom, 2 * Constants.sectionSpacing)
        }
    }
    
}

// MARK: - Uncomment below if needed

//struct TrendingView_Previews: PreviewProvider {
//    static var previews: some View {
//        TrendingView()
//    }
//}
