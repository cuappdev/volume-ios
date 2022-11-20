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
    let navigationSource: NavigationSource
    @State private var bookmarkRequestInProgress = false
    @State private var cancellableShoutoutMutation: AnyCancellable?
    @State private var showToolbars = true
    
    private var isShoutoutsButtonEnabled: Bool {
        return userData.canIncrementMagazineShoutouts(magazine)
    }
    
    private var navbar: some View {
            ZStack {
                Rectangle()
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.2), radius: 2, y: 3)
                
                if showToolbars {
                    HStack {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Image.volume.leftArrow
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 24)
                                .foregroundColor(.black)
                        }
                        
                        Spacer()
                        
                        Image.volume.compass
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 24)
                            .foregroundColor(.volume.lightGray)
                    }
                    .padding(.horizontal, 16)
                    
                    VStack {
                        Text(magazine.title)
                            .font(.newYorkBold(size: 12))
                            .truncationMode(.tail)
                        Text("Reading in Volume")
                            .font(.helveticaRegular(size: 10))
                            .foregroundColor(.volume.lightGray)
                    }
                    .padding(.horizontal, 48)
                } else {
                    Text(magazine.title)
                        .font(.newYorkBold(size: 10))
                        .fixedSize()
                }
            }
            .background(Color.white)
            .frame(height: showToolbars ? 40 : 20)
    }
        
        private var toolbar: some View {
            HStack(spacing: 0) {
                NavigationLink(destination: PublicationDetail(navigationSource: navigationSource, publication: magazine.publication)) {
                    if let imageUrl = magazine.publication.profileImageUrl {
                        WebImage(url: imageUrl)
                            .grayBackground()
                            .resizable()
                            .clipShape(Circle())
                            .frame(width: 32, height: 32)
                    } else {
                        Circle()
                            .fill(.gray)
                            .frame(width: 32, height: 32)
                    }
                    Spacer()
                        .frame(width: 7)
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
                        .frame(width: 16)
                    
                    Button {
                    } label: {
                        Image(systemName: "square.and.arrow.up.on.square")
                            .font(Font.system(size: 16, weight: .semibold))
                            .foregroundColor(.volume.orange)
                    }
                    
                    Spacer()
                        .frame(width: 16)
                    
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
                        .frame(width: 6)
                    
                    Text(String(max(magazine.shoutouts, userData.magazineShoutoutsCache[magazine.id, default: 0])))
                        .font(.helveticaRegular(size: 12))
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
                        .frame(height: showToolbars ? 40 : 20)
                    if let magazineUrl = magazine.pdfUrl {
                        PDFKitView(pdfDoc: PDFDocument(url: magazineUrl)!, showToolbars: $showToolbars)
                    }
                    if showToolbars {
                        toolbar
                    }
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
    
}
    
    extension MagazineReaderView {
        private enum MagazineReaderViewState<Results> {
            case loading, results(Results)
        }
    }
