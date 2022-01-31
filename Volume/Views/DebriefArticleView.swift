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
                .frame(height: 21)
                .accentColor(userData.isArticleSaved(article) ? Color.white : Color.volume.orange)
                .background(userData.isArticleSaved(article) ? Color.volume.orange : Color.white)
        }
        .frame(width: 44, height: 44)
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
                .foregroundColor(Color.volume.orange)
        }
        .frame(width: 44, height: 44)
        .overlay(Circle().stroke(Color.volume.orange, lineWidth: 4))
        .clipShape(Circle())
    }
    
    var shoutoutButton: some View {
        Button {
            incrementShoutouts(for: article)
        } label: {
            let _ = print("the shoutouts is \(max(article.shoutouts, userData.shoutoutsCache[article.id, default: 0]))")
            Image("shout-out")
                .resizable()
                .foregroundColor(max(article.shoutouts, userData.shoutoutsCache[article.id, default: 0]) > 0 ? Color.white : Color.volume.orange)
                .background(max(article.shoutouts, userData.shoutoutsCache[article.id, default: 0]) > 0 ? Color.volume.orange : Color.white)
                .scaledToFit()
                .frame(height: 21)
        }
        .frame(width: 44, height: 44)
        .background(max(article.shoutouts, userData.shoutoutsCache[article.id, default: 0]) > 0 ? Color.volume.orange : Color.white)
        .overlay(Circle().stroke(Color.volume.orange, lineWidth: 4))
        .clipShape(Circle())
    }
    
    var body: some View {
        VStack(spacing: 30) {
            Header(header, .center)
                .padding(.top, 24)
            
            NavigationLink(destination: BrowserView(initType: .readyForDisplay(article), navigationSource: .weeklyDebrief)) {
                VStack(spacing: 16) {
                    if let url = article.imageUrl {
                        WebImage(url: url)
                            .resizable()
                            .grayBackground()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 275, height: 275)
                            .clipped()
                    } else {
                        WebImage(url: article.publication.profileImageUrl)
                            .resizable()
                            .grayBackground()
                            .frame(width: 275, height: 275)
                            .padding(30)
                    }
                    ArticleInfo(article: article, showsPublicationName: true, largeFont: true)
                }
                .frame(width: 275, height: 435)
            }
            .accentColor(Color.black)
            
            HStack(spacing: 56) {
                saveButton
                shareButton
                shoutoutButton
            }
            .padding([.leading, .trailing], 65)
            .padding(.top, 30)
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
                    print(error)
                }
            }, receiveValue: { _ in })
    }
}

//struct DebriefArticleView_Previews: PreviewProvider {
//    static var previews: some View {
//        DebriefArticleView()
//    }
//}
