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
        @State private var didFollowPublication = false
        @State private var publications: [Publication] = publicationsData + publicationsData
        
        @Binding var page: OnboardingView.Page
        
        @AppStorage("isFirstLaunch") var isFirstLaunch = true
        
        private func onToggleFollowing(publication: Publication) {
            if let index = publications.firstIndex(of: publication) {
                publications[index] = Publication(
                    id: UUID(),
                    description: publication.description,
                    name: publication.name,
                    image: publication.image,
                    isFollowing: !publication.isFollowing,
                    recent: publication.recent
                )
            }
            
            withAnimation {
                self.didFollowPublication = true
            }
        }
        
        var body: some View {
            Group {
                // Empty array for axes means that scroll is disabled
                ScrollView([]) {
                    VStack(spacing: 24) {
                        ForEach(publications) { publication in
                            MorePublicationRow(publication: publication, onToggleFollowing: onToggleFollowing)
                        }
                    }
                }
                .overlay(BottomFadeView())
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
    private struct BottomFadeView: View {
        var body: some View {
            VStack {
                Spacer()
                LinearGradient(
                    gradient: Gradient(
                        colors: [
                            Color.volume.backgroundGray.opacity(0),
                            Color.volume.backgroundGray
                        ]
                    ),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 83)
            }
        }
    }
}

//struct FollowView_Previews: PreviewProvider {
//    static var previews: some View {
//        OnboardingView.FollowView()
//    }
//}
