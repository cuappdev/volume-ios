//
//  DebriefArticleView.swift
//  Volume
//
//  Created by Amy Chin Siu Huang on 12/2/21.
//  Copyright © 2021 Cornell AppDev. All rights reserved.
//

import AppDevAnalytics
import Combine
import SDWebImageSwiftUI
import SwiftUI

struct DebriefArticleView: View {
    static let buttonSize: CGFloat = 44
    static let buttonLabelHeight: CGFloat = 21
    static let buttonSpacing: CGFloat = 56
    static let bodySpacing: CGFloat = 30
    static let bodyFrameSize: CGFloat = 275
    static let bodyFrameHeight: CGFloat = 435
    
    @State private var bookmarkRequestInProgress = false
    @State private var cancellableShoutoutMutation: AnyCancellable?
    @EnvironmentObject private var userData: UserData
    let header: String
    let article: Article
    
    @Binding private var isDebriefOpen: Bool
    @Binding private var isURLOpen: Bool
    @Binding private var articleID: String?
    
    init(header: String, article: Article, isDebriefOpen: Binding<Bool>, isURLOpen: Binding<Bool>, articleID: Binding<String?>) {
        self.header = header
        self.article = article
        _isDebriefOpen = isDebriefOpen
        _isURLOpen = isURLOpen
        _articleID = articleID
    }

    var saveButton: some View {
        Button(action: {
            Haptics.shared.play(.light)
            bookmarkRequestInProgress = true 
            userData.toggleArticleSaved(article, $bookmarkRequestInProgress)
            AppDevAnalytics.log(
                VolumeEvent.bookmarkArticle.toEvent(.article, value: article.id, navigationSource: .weeklyDebrief)
            )
        }, label: {
            Image.volume.bookmark
                .resizable()
                .scaledToFit()
                .frame(height: Self.buttonLabelHeight)
                .accentColor(userData.isArticleSaved(article) ? .white : .volume.orange)
                .background(userData.isArticleSaved(article) ? Color.volume.orange : Color.white)
        })
        .disabled(bookmarkRequestInProgress)
        .frame(width: Self.buttonSize, height: Self.buttonSize)
        .background(userData.isArticleSaved(article) ? Color.volume.orange : Color.white)
        .overlay(Circle().stroke(Color.volume.orange, lineWidth: 4))
        .clipShape(Circle())
    }
    
    var shareButton: some View {
        Button {
            Haptics.shared.play(.light)
            AppDevAnalytics.log(VolumeEvent.shareArticle.toEvent(.article, value: article.id, navigationSource: .weeklyDebrief))
            displayShareScreen(for: article)
        } label: {
            Image(systemName: "square.and.arrow.up")
                .foregroundColor(.volume.orange)
        }
        .frame(width: Self.buttonSize, height: Self.buttonSize)
        .overlay(Circle().stroke(Color.volume.orange, lineWidth: 4))
        .clipShape(Circle())
    }
    
    var shoutoutButton: some View {
        Button {
            Haptics.shared.play(.light)
            incrementShoutouts(for: article)
        } label: {
            Image.volume.shoutout
                .resizable()
                .foregroundColor(isShoutoutsButtonEnabled ? .volume.orange : .white)
                .background(isShoutoutsButtonEnabled ? Color.white : Color.volume.orange)
                .scaledToFit()
                .frame(height: Self.buttonLabelHeight)
        }
        .frame(width: Self.buttonSize, height: Self.buttonSize)
        .background(isShoutoutsButtonEnabled ? Color.white : Color.volume.orange)
        .overlay(Circle().stroke(Color.volume.orange, lineWidth: 4))
        .clipShape(Circle())
        .disabled(!isShoutoutsButtonEnabled)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Header(header, .center)
                .padding(.top, 24)
                .padding(.bottom, 30)
            
            NavigationLink(destination: BrowserView(initType: .readyForDisplay(article), navigationSource: .weeklyDebrief)) {
                VStack(spacing: 16) {
                    if let url = article.imageUrl {
                        WebImage(url: url)
                            .resizable()
                            .grayBackground()
                            .scaledToFit()
                            .frame(width: Self.bodyFrameSize, height: Self.bodyFrameSize)
                            .clipped()
                    } else {
                        WebImage(url: article.publication.profileImageUrl)
                            .resizable()
                            .grayBackground()
                            .frame(width: Self.bodyFrameSize, height: Self.bodyFrameSize)
                            .padding(Self.bodySpacing)
                    }
                    ArticleInfo(article: article, showsPublicationName: true, isDebrief: true)
                }
            }
            .frame(width: Self.bodyFrameSize, height: Self.bodyFrameHeight)
            .accentColor(.black)

            Spacer()
            
            HStack(spacing: Self.buttonSpacing) {
                saveButton
                shareButton
                shoutoutButton
            }
            .padding(.horizontal, 65)
            .padding(.bottom, 100)
        }
    }

    func displayShareScreen(for article: Article) {
        if let shareArticleUrl = URL(string: Secrets.openArticleUrl + article.id) {
            let rootVC = UIApplication.shared.windows.first?.rootViewController
            let presentingVC = rootVC?.presentedViewController ?? rootVC
            let linkSource = LinkItemSource(url: shareArticleUrl, article: article)
            let shareVC = UIActivityViewController(activityItems: [linkSource], applicationActivities: nil)
            presentingVC?.present(shareVC, animated: true, completion: nil)
        }
    }

    private var isShoutoutsButtonEnabled: Bool {
        return userData.canIncrementShoutouts(article)
    }

    private func incrementShoutouts(for article: Article) {
        guard let uuid = userData.uuid else { return }

        AppDevAnalytics.log(VolumeEvent.shoutoutArticle.toEvent(.article, value: article.id, navigationSource: .weeklyDebrief))
        userData.incrementShoutoutsCounter(article)
        let currentArticleShoutouts = max(userData.shoutoutsCache[article.id, default: 0], article.shoutouts)
        userData.shoutoutsCache[article.id, default: 0] = currentArticleShoutouts + 1
        let currentPublicationShoutouts = max(userData.shoutoutsCache[article.publication.slug, default: 0], article.publication.shoutouts)
        userData.shoutoutsCache[article.publication.slug, default: 0] = currentPublicationShoutouts + 1
        cancellableShoutoutMutation = Network.shared.publisher(for: IncrementShoutoutsMutation(id: article.id, uuid: uuid))
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print("Error: IncrementShoutoutsMutation failed on DebriefArticleView: \(error.localizedDescription)")
                }
            }, receiveValue: { _ in })
    }
}

extension DebriefArticleView {
    struct Skeleton: View {
        var body: some View {
            VStack(spacing: 0) {
                // Header
                SkeletonView()
                    .frame(width: 217, height: 42)
                    .padding(.top, 24)
                    .padding(.bottom, 30)
                    .cornerRadius(5)

                VStack(spacing: 16) {
                    // Image
                    SkeletonView()
                        .frame(width: bodyFrameSize, height: bodyFrameSize)
                        .cornerRadius(5)

                    // ArticleInfo
                    ArticleInfo
                        .Skeleton(isDebrief: true)
                }
                .frame(width: bodyFrameSize, height: bodyFrameHeight)
                .cornerRadius(5)

                Spacer()

                // Buttons
                HStack(spacing: buttonSpacing) {
                    ForEach(1...3, id: \.self) { _ in
                        SkeletonView()
                            .frame(width: buttonSize, height: buttonSize)
                            .cornerRadius(buttonSize / 2)
                    }
                }
                .padding(.horizontal, 65)
                .padding(.bottom, 100)
            }
        }
    }
}

//struct DebriefArticleView_Previews: PreviewProvider {
//    static var previews: some View {
//        DebriefArticleView()
//    }
//}
