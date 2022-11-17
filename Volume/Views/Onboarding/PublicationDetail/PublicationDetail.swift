//
//  PublicationDetail.swift
//  Volume
//
//  Created by Cameron Russell on 10/29/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import Combine
import SDWebImageSwiftUI
import SwiftUI

/// `PublicationDetail` displays detailed information about a publication
struct PublicationDetail: View {
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @EnvironmentObject private var networkState: NetworkState
    @GestureState private var dragOffset = CGSize.zero
    @StateObject var viewModel: ViewModel

    var body: some View {
        ScrollView {
            coverImageHeader
            articlesSection
        }
        .disabled(viewModel.disableScrolling)
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.top)
        .background(Color.white)
        .gesture(
            DragGesture().updating($dragOffset) { value, _, _ in
                if value.startLocation.x < Constants.dragGestureMinX && value.translation.width > Constants.dragGestureMaxX {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        )
        .onAppear {
            viewModel.setup(networkState: networkState)
            viewModel.fetchContent()
        }
    }


    // MARK: Header

    private var coverImageHeader: some View {
        VStack(alignment: .center) {
            ZStack {
                coverImage
                coverImageOverlay
            }
            .frame(height: Constants.coverImageOverlayHeight)

            publicationDescription
            divider
        }
    }

    private var coverImage: some View {
        GeometryReader { geometry in
            let scrollOffset = geometry.frame(in: .global).minY
            let headerOffset = scrollOffset > 0 ? -scrollOffset : 0
            let headerHeight = geometry.size.height + max(scrollOffset, 0)

            Group {
                if let url = viewModel.publication.backgroundImageUrl {
                    WebImage(url: url)
                        .resizable()
                        .grayBackground()
                        .scaledToFill()
                        .clipped()
                } else {
                    Rectangle() // TODO: Custom image
                        .foregroundColor(.blue)
                }
            }
            .frame(width: geometry.size.width, height: headerHeight)
            .offset(y: headerOffset)
        }
        .frame(height: Constants.coverImageHeight)
    }

    private var coverImageOverlay: some View {
        HStack {
            VStack(alignment: .leading) {
                Button {
                    self.presentationMode.wrappedValue.dismiss()
                } label: {
                    Image.volume.backArrow
                        .foregroundColor(.white)
                        .padding(.top, Constants.backButtonTopPadding)
                        .padding(.leading, Constants.backButtonLeadingPadding)
                        .shadow(color: .black, radius: Constants.shadowRadius)
                }

                Spacer()

                Group {
                    if let imageUrl = viewModel.publication.profileImageUrl {
                        WebImage(url: imageUrl)
                            .grayBackground()
                            .resizable()
                            .clipShape(Circle())
                    } else {
                        Circle()
                    }
                }
                .frame(width: Constants.profileImageDimension, height: Constants.profileImageDimension)
                .overlay(Circle().stroke(Color.white, lineWidth: Constants.profileImageStrokeWidth))
                .shadow(color: .volume.shadowBlack, radius: Constants.shadowRadius)
                .padding(.leading, Constants.horizontalPadding)
            }

            Spacer()
        }
    }

    private var publicationDescription: some View {
        PublicationDetailHeader(
            navigationSource: viewModel.navigationSource,
            publication: viewModel.publication
        )
        .padding(.bottom)
    }

    // MARK: Articles

    private var articlesSection: some View {
        LazyVStack(alignment: .center) {
            switch viewModel.articles {
            case .none:
                ForEach(0..<5) { _ in
                    articleRowSkeleton
                }
            case .some(let articles):
                Header(Constants.articlesTabTitle)
                    .foregroundColor(.black)
                    .padding()

                ForEach(articles) { article in
                    ZStack {
                        ArticleRow(article: article, navigationSource: .publicationDetail, showsPublicationName: false)
                            .padding([.horizontal, .bottom])
                            .onAppear {
                                viewModel.fetchPageIfLast(article: article)
                            }

                        NavigationLink {
                            BrowserView(initType: .readyForDisplay(article), navigationSource: .publicationDetail)
                        } label: {
                            EmptyView()
                        }.opacity(0)
                    }
                }
            }
        }
    }

    // MARK: Helpers

    private var divider: some View {
        Divider()
            .background(Color.volume.buttonGray)
            .frame(width: Constants.dividerWidth)
    }

    private var articleRowSkeleton: some View {
        ArticleRow.Skeleton(showsPublicationName: false)
            .padding([.bottom, .leading, .trailing])
    }
}

extension PublicationDetail {
    private struct Constants {
        static let horizontalPadding: CGFloat = 16
        static let backButtonTopPadding: CGFloat = 55
        static let backButtonLeadingPadding: CGFloat = 20
        static let shadowRadius: CGFloat = 4
        static let coverImageHeight: CGFloat = 140
        static let coverImageOverlayHeight: CGFloat = 156
        static let profileImageDimension: CGFloat = 60
        static let profileImageStrokeWidth: CGFloat = 3
        static let dividerWidth: CGFloat = 100
        static let dragGestureMinX: CGFloat = 20
        static let dragGestureMaxX: CGFloat = 100
        static let articlesTabTitle = "Articles"
    }
}
