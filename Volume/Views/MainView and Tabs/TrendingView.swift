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
        static let listHorizontalPadding: CGFloat = 16
        static let mainArticleSkeletonHeight: CGFloat = 480
        static let magazineVerticalSpacing: CGFloat = 30
        static let sectionSpacing: CGFloat = 40
        static let subArticlesSpacing: CGFloat = 16
    }
    
    // MARK: - UI
    
    var body: some View {
        listContent
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Image.volume.logo
            }
        }
        .onAppear {
            viewModel.setupEnvironment(networkState: networkState, userData: userData)
            Task {
                await viewModel.fetchContent()
            }
        }
    }
    
    private var listContent: some View {
        List {
            Group {
                mainArticleSection
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                subArticlesSection
                flyersSection
                magazinesSection
                endSection
            }
            .padding(.bottom, Constants.sectionSpacing)
            .listSectionSeparator(.hidden)
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets(top: 0, leading: Constants.listHorizontalPadding, bottom: 0, trailing: Constants.listHorizontalPadding))
            .listRowBackground(Color.clear)
        }
        .navigationBarTitleDisplayMode(.inline)
        .listStyle(.plain)
        .refreshable {
            await viewModel.refreshContent()
        }
        .modifier(ListBackgroundModifier())
        .background(Constants.backgroundColor)
    }
    
    // MARK: - Sections
    
    private var mainArticleSection: some View {
        Section {
            switch viewModel.mainArticle {
            case .none:
                SkeletonView()
                    .frame(height: Constants.mainArticleSkeletonHeight)
            case .some(let article):
                ZStack {
                    TrendingMainArticleCell(article: article, urlImageModel: URLImageModel(urlString: article.imageUrl?.absoluteString ?? ""))
                    
                    NavigationLink {
                        BrowserView(initType: .readyForDisplay(article), navigationSource: .trendingArticles)
                    } label: {
                        EmptyView()
                    }
                    .opacity(0)
                }
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
                        ZStack {
                            ArticleRow(article: article, navigationSource: .trendingArticles)
                            
                            NavigationLink {
                                BrowserView(initType: .readyForDisplay(article), navigationSource: .trendingArticles)
                            } label: {
                                EmptyView()
                            }
                            .opacity(0)
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
            await viewModel.fetchFlyers()
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
                        ZStack {
                            MagazineCell(magazine: magazine)
                            
                            NavigationLink {
                                MagazineReaderView(initType: .readyForDisplay(magazine), navigationSource: .featuredMagazines)
                            } label: {
                                EmptyView()
                            }.opacity(0)
                        }
                    }
                }
            }
        }
        .task {
            // Fetch asynchronously only when in view
            await viewModel.fetchMagazines()
        }
    }
    
    private var endSection: some View {
        Section {
            Group {
                VolumeMessage(message: .upToDateFlyers, largeFont: false, fullWidth: true)
                    .frame(width: Constants.endMessageWidth)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding([.top, .bottom], Constants.sectionSpacing)
        }
    }
    
}

// MARK: - Uncomment below if needed

//struct TrendingView_Previews: PreviewProvider {
//    static var previews: some View {
//        TrendingView()
//    }
//}
