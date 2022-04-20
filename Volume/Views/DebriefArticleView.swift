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
    @State private var cancellableShoutoutMutation: AnyCancellable?
    @EnvironmentObject private var userData: UserData
    let header: String
    let article: Article
    
    @Binding private var isDebriefOpen: Bool
    @Binding private var isURLOpen: Bool
    @Binding private var articleID: String?
    
    let buttonSize: CGFloat = 44
    let buttonLabelHeight: CGFloat = 21
    let buttonSpacing: CGFloat = 56
    let bodySpacing: CGFloat = 30
    let bodyFrameSize: CGFloat = 275
    let bodyFrameHeight: CGFloat = 435
    
    init(header: String, article: Article, isDebriefOpen: Binding<Bool>, isURLOpen: Binding<Bool>, articleID: Binding<String?>) {
        self.header = header
        self.article = article
        _isDebriefOpen = isDebriefOpen
        _isURLOpen = isURLOpen
        _articleID = articleID
    }

    var saveButton: some View {
        Button {
            userData.toggleArticleSaved(article)
            AppDevAnalytics.log(
                userData.isArticleSaved(article) ?
                VolumeEvent.bookmarkArticle.toEvent(.article, value: article.id, navigationSource: .weeklyDebrief) :
                    VolumeEvent.unbookmarkArticle.toEvent(.article, value: article.id, navigationSource: .weeklyDebrief)
            )
        } label: {
            Image(systemName: "bookmark")
                .resizable()
                .scaledToFit()
                .frame(height: buttonLabelHeight)
                .accentColor(userData.isArticleSaved(article) ? .white : .volume.orange)
                .background(userData.isArticleSaved(article) ? Color.volume.orange : Color.white)
        }
        .frame(width: buttonSize, height: buttonSize)
        .background(userData.isArticleSaved(article) ? Color.volume.orange : Color.white)
        .overlay(Circle().stroke(Color.volume.orange, lineWidth: 4))
        .clipShape(Circle())
    }
    
    var shareButton: some View {
        Button {
            AppDevAnalytics.log(VolumeEvent.shareArticle.toEvent(.article, value: article.id, navigationSource: .weeklyDebrief))
            displayShareScreen(for: article)
        } label: {
            Image(systemName: "square.and.arrow.up")
                .foregroundColor(.volume.orange)
        }
        .frame(width: buttonSize, height: buttonSize)
        .overlay(Circle().stroke(Color.volume.orange, lineWidth: 4))
        .clipShape(Circle())
    }
    
    var shoutoutButton: some View {
        Button {
            incrementShoutouts(for: article)
        } label: {
            Image.volume.shoutout
                .resizable()
                .foregroundColor(max(article.shoutouts, userData.shoutoutsCache[article.id, default: 0]) > 0 ? .white : .volume.orange)
                .background(max(article.shoutouts, userData.shoutoutsCache[article.id, default: 0]) > 0 ? Color.volume.orange : Color.white)
                .scaledToFit()
                .frame(height: buttonLabelHeight)
        }
        .frame(width: buttonSize, height: buttonSize)
        .background(max(article.shoutouts, userData.shoutoutsCache[article.id, default: 0]) > 0 ? Color.volume.orange : Color.white)
        .overlay(Circle().stroke(Color.volume.orange, lineWidth: 4))
        .clipShape(Circle())
    }
    
    var body: some View {
        VStack(spacing: bodySpacing) {
            Header(header, .center)
                .padding(.top, 24)
            
            NavigationLink(destination: BrowserView(initType: .readyForDisplay(article), navigationSource: .weeklyDebrief)) {
                VStack(spacing: 16) {
                    if let url = article.imageUrl {
                        WebImage(url: url)
                            .resizable()
                            .grayBackground()
                            .frame(width: bodyFrameSize, height: bodyFrameSize)
                            .clipped()
                            .scaledToFill()
                    } else {
                        WebImage(url: article.publication.profileImageUrl)
                            .resizable()
                            .grayBackground()
                            .frame(width: bodyFrameSize, height: bodyFrameSize)
                            .padding(bodySpacing)
                    }
                    ArticleInfo(article: article, showsPublicationName: true, largeFont: true)
                }
                .onTapGesture {
                    isDebriefOpen = false
                    isURLOpen = true
                    articleID = article.id
                }
                ArticleInfo(article: article, showsPublicationName: true, largeFont: true)
            }
            .frame(width: bodyFrameSize, height: bodyFrameHeight)
            .accentColor(.black)
            
            HStack(spacing: buttonSpacing) {
                saveButton
                shareButton
                shoutoutButton
            }
            .padding(.horizontal, 65)
            .padding(.top, bodySpacing)
            Spacer()
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

    private func incrementShoutouts(for article: Article) {
        guard let uuid = userData.uuid else { return }

        AppDevAnalytics.log(VolumeEvent.shoutoutArticle.toEvent(.article, value: article.id, navigationSource: .weeklyDebrief))
        userData.incrementShoutoutsCounter(article)
        let currentArticleShoutouts = max(userData.shoutoutsCache[article.id, default: 0], article.shoutouts)
        userData.shoutoutsCache[article.id, default: 0] = currentArticleShoutouts + 1
        let currentPublicationShoutouts = max(userData.shoutoutsCache[article.publication.id, default: 0], article.publication.shoutouts)
        userData.shoutoutsCache[article.publication.id, default: 0] = currentPublicationShoutouts + 1
        cancellableShoutoutMutation = Network.shared.publisher(for: IncrementShoutoutsMutation(id: article.id, uuid: uuid))
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print("Error: IncrementShoutoutsMutation failed on DebriefArticleView: \(error.localizedDescription)")
                }
            }, receiveValue: { _ in })
    }
}

//struct DebriefArticleView_Previews: PreviewProvider {
//    static var previews: some View {
//        DebriefArticleView()
//    }
//}
