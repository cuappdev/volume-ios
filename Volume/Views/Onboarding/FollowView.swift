//
//  FollowView.swift
//  Volume
//
//  Created by Daniel Vebman on 11/26/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import SwiftUI

extension OnboardingView {
    struct FollowView: View {
        @AppStorage("isFirstLaunch") private var isFirstLaunch = true
        @State private var contentOffset: CGPoint = .zero
        @State private var maxContentOffset: CGPoint = .zero
        @State private var didFollowPublication = false
        
        private var publications: [Publication] {
            var p: [Publication] = []
            for i in 0..<10 {
                let src = publicationsData[i % publicationsData.count]
                p.append(Publication(id: UUID(), description: src.description, name: src.name, image: src.image, isFollowing: src.isFollowing, recent: src.recent))
            }
            return p
        }
        
        @Binding var page: OnboardingView.Page
        
        private func onToggleFollowing(publication: Publication) {
            if let index = publications.firstIndex(of: publication) {
//                publications[index] = Publication(
//                    id: UUID(),
//                    description: publication.description,
//                    name: publication.name,
//                    image: publication.image,
//                    isFollowing: !publication.isFollowing,
//                    recent: publication.recent
//                )
            }
            
            withAnimation {
                self.didFollowPublication = true
            }
        }
        
        var body: some View {
            Group {
                TrackableScrollView(
                    contentOffset: $contentOffset,
                    maxOffsetDidChange: { self.maxContentOffset = $0 }
                ) {
                    LazyVStack(spacing: 24) {
                        ForEach(publications) { publication in
                            MorePublicationRow(publication: publication, onToggleFollowing: onToggleFollowing)
                        }
                    }
                    .background(Color.volume.backgroundGray)
                }
                .overlay(
                    VStack {
                        fadeView(fadesDown: false)
                            .opacity(contentOffset.y > 0 ? 1 : 0)
                        Spacer()
                        fadeView(fadesDown: true)
                            .opacity(
                                contentOffset.y < maxContentOffset.y - 1
                                    || maxContentOffset.y == 0
                                    ? 1 : 0
                            )
                    }
                    .allowsHitTesting(false)
                    .transition(.opacity)
                    .animation(.linear(duration: 0.2))
                )
                .padding(.top, 48)
                .transition(.move(edge: .trailing))
                
                Spacer()
                
                PageControl(currentPage: page == .welcome ? 0 : 1, numberOfPages: 2)
                    .padding(.bottom, 47)
                Button("Start reading") {
                    withAnimation(.spring()) {
                        self.isFirstLaunch = false
                    }
                }
                .font(.helveticaBold(size: 16))
                .padding([.leading, .trailing], 32)
                .padding([.top, .bottom], 8)
                .foregroundColor(didFollowPublication ? Color.volume.orange : Color(white: 151 / 255))
                .background(Color(white: 238 / 255))
                .cornerRadius(5)
                .shadow(color: Color.black.opacity(0.1), radius: didFollowPublication ? 5 : 0)
                .padding(.bottom, 20)
                .disabled(!didFollowPublication)
            }
        }
    }
}

extension OnboardingView.FollowView {
    /// `fadesDown` if the fade gets stronger (more opaque) at the bottom
    private func fadeView(fadesDown: Bool) -> some View {
        Group {
            if fadesDown {
                Spacer()
            }
            LinearGradient(
                gradient: Gradient(
                    colors: [
                        Color.volume.backgroundGray.opacity(0),
                        Color.volume.backgroundGray
                    ]
                ),
                startPoint: fadesDown ? .top : .bottom,
                endPoint: fadesDown ? .bottom : .top
            )
            .frame(height: 50)
            if !fadesDown {
                Spacer()
            }
        }
    }
}

//struct FollowView_Previews: PreviewProvider {
//    static var previews: some View {
//        OnboardingView.FollowView()
//    }
//}
