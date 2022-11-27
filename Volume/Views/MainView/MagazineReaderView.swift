//
//  MagazineDetail.swift
//  Volume
//
//  Created by Justin Ngai on 9/3/2022.
//  Copyright © 2022 Cornell AppDev. All rights reserved.
//

import SwiftUI
import PDFKit
import AppDevAnalytics
import Combine
import LinkPresentation
import SDWebImageSwiftUI

struct MagazineReaderView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject private var userData: UserData
    
    let magazine: Magazine
    let magazineUrl: URL
    let navigationSource: NavigationSource
    @State private var bookmarkRequestInProgress = false
    @State private var cancellableShoutoutMutation: AnyCancellable?
    
    private struct Constants {
        static let navbarOpacity: CGFloat = 0.2
        static let navbarRadius: CGFloat = 2
        static let navbarY: CGFloat = 3
        static let navbarLeftComponentHeight: CGFloat = 24
        static let navbarRightComponentHeight: CGFloat = 16
        static let navbarHStackPadding: CGFloat = 16
        static let navbarTitleSize: CGFloat = 12
        static let navbarSubtitle = "Reading in Volume"
        static let navbarSubtitleSize: CGFloat = 10
        static let navbarVStackPadding: CGFloat = 48
        static let navbarHeight: CGFloat = 40
        
        static let toolbarPubImageW: CGFloat = 32
        static let toolbarPubImageH: CGFloat = 32
        static let toolbarRightComponentsPadding: CGFloat = 16
        static let toolbarLeftBorderPadding: CGFloat = 7
        static let toolbarRightBorderPadding: CGFloat = 6
        static let toolbarShoutoutsFontSize: CGFloat = 12
        
    }
    
    private var isShoutoutsButtonEnabled: Bool {
        return userData.canIncrementMagazineShoutouts(magazine)
    }
    
    private var navbar: some View {
            ZStack {
                Rectangle()
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(Constants.navbarOpacity), radius: Constants.navbarRadius, y: Constants.navbarY)
                
                HStack {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image.volume.leftArrow
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: Constants.navbarLeftComponentHeight)
                            .foregroundColor(.black)
                    }
                    
                    Spacer()
                    
                    Image.volume.menu
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: Constants.navbarRightComponentHeight)
                        .foregroundColor(.volume.lightGray)
                }
                .padding(.horizontal, Constants.navbarHStackPadding)
                
                VStack {
                    Text(magazine.title)
                        .font(.newYorkBold(size: Constants.navbarTitleSize))
                        .truncationMode(.tail)
                    
                    Text(Constants.navbarSubtitle)
                        .font(.helveticaRegular(size: Constants.navbarSubtitleSize))
                        .foregroundColor(.volume.lightGray)
                }
                .padding(.horizontal, Constants.navbarVStackPadding)
            }
            .background(Color.white)
            .frame(height: Constants.navbarHeight)
    }
        
        private var toolbar: some View {
            HStack(spacing: 0) {
                NavigationLink(destination: PublicationDetail(navigationSource: navigationSource, publication: magazine.publication)) {
                    
                    if let imageUrl = magazine.publication.profileImageUrl {
                        WebImage(url: imageUrl)
                            .grayBackground()
                            .resizable()
                            .clipShape(Circle())
                            .frame(width: Constants.toolbarPubImageW, height: Constants.toolbarPubImageH)
                    } else {
                        Circle()
                            .fill(.gray)
                            .frame(width: Constants.toolbarPubImageW, height: Constants.toolbarPubImageH)
                    }
                    
                    Spacer()
                        .frame(width: Constants.toolbarLeftBorderPadding)
                    
                    Text("See more")
                        .font(.helveticaRegular(size: 12))
                        .foregroundColor(.black)
                }
                Spacer()
                Group {
                    Button(action: {
                        bookmarkRequestInProgress = true
                        userData.toggleMagazineSaved(magazine, $bookmarkRequestInProgress)
                    }, label: {
                        Image(systemName: userData.isMagazineSaved(magazine) ? "bookmark.fill" : "bookmark")
                            .font(Font.system(size: 18, weight: .semibold))
                            .foregroundColor(.volume.orange)
                    })
                    .disabled(bookmarkRequestInProgress)
                    
                    Spacer()
                        .frame(width: Constants.toolbarRightComponentsPadding)
                    
                    Button {
                        displayShareScreen(for: magazine)
                    } label: {
                        Image(systemName: "square.and.arrow.up.on.square")
                            .font(Font.system(size: 16, weight: .semibold))
                            .foregroundColor(.volume.orange)
                    }
                    
                    Spacer()
                        .frame(width: Constants.toolbarRightComponentsPadding)
                    
                    Button {
                        incrementShoutouts(for: magazine)
                    } label: {
                        Image.volume.shoutout
                            .resizable()
                            .scaledToFit()
                            .frame(height: 24)
                            .foregroundColor(.volume.orange)
                            .foregroundColor(isShoutoutsButtonEnabled ? .volume.orange : .gray)
                    }
                    .disabled(!isShoutoutsButtonEnabled)
                    
                    Spacer()
                        .frame(width: Constants.toolbarRightBorderPadding)
                    
                    Text(String(max(magazine.shoutouts, userData.magazineShoutoutsCache[magazine.id, default: 0])))
                        .font(.helveticaRegular(size: Constants.toolbarShoutoutsFontSize))
                }
            }
            .padding([.leading, .trailing], 16)
            .padding([.top, .bottom], 8)
            .background(Color.white)
        }
        
        var body: some View {
            ZStack {
                VStack(spacing: 0) {
                    
                    Spacer()
                        .frame(height: Constants.navbarHeight)
                    
                    if let pdfDoc = PDFDocument(url: magazineUrl) {
                        PDFKitView(pdfDoc: pdfDoc)
                    } else {
                        PDFKitView(pdfDoc: PDFDocument())
                    }
                    
                    toolbar
                }
                
                VStack(spacing: 0) {
                    navbar
                    
                    Spacer()
                }
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
    
    // MARK: Actions
    private func incrementShoutouts(for magazine: Magazine) {
        guard let uuid = userData.uuid else { return }
        userData.incrementMagazineShoutoutsCounter(magazine)
        let currentMagazineShoutouts = max(userData.magazineShoutoutsCache[magazine.id, default: 0], magazine.shoutouts)
        userData.magazineShoutoutsCache[magazine.id, default: 0] = currentMagazineShoutouts + 1
        let currentPublicationShoutouts = max(userData.shoutoutsCache[magazine.publication.slug, default: 0], magazine.publication.shoutouts)
        userData.shoutoutsCache[magazine.publication.slug, default: 0] = currentPublicationShoutouts + 1
        
        cancellableShoutoutMutation = Network.shared.publisher(for: IncrementMagazineShoutoutsMutation(id: magazine.id, uuid: uuid))
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print("Error: IncrementMagazineShoutoutsMutation failed on MagazineReaderView: \(error.localizedDescription)")
                }
            }, receiveValue: { _ in })
    }
    
    func displayShareScreen(for magazine: Magazine) {
        let rawString = Secrets.openArticleUrl + magazine.id
        if let shareMagazineUrl = URL(string: rawString) {
            let linkSource = LinkItemSource(url: shareMagazineUrl, magazine: magazine)
            let shareVC = UIActivityViewController(activityItems: [linkSource], applicationActivities: nil)
            UIApplication.shared.windows.first?.rootViewController?.present(shareVC, animated: true)
        }
    }
    
}
    
    extension MagazineReaderView {
        private enum MagazineReaderViewState<Results> {
            case loading, results(Results)
        }
    }
