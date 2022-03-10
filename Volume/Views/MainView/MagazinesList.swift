//
//  MagazinesList.swift
//  Volume
//
//  Created by Hanzheng Li on 3/4/22.
//  Copyright © 2022 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct MagazinesList: View {
    @State private var state: MainView.TabState<Results> = .loading

    // TODO: Remove test data when backend setup
    let magHeight: CGFloat = 220
    let magWidth: CGFloat  = 150
    
    private func fetchContent(_ done: @escaping () -> Void = { }) {
        // simulate network request delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // TODO: add actual network request
            done()
            state = .results((
                trendingMagazines: [Magazine](),
                otherMagazines: [String : [Magazine]]()
            ))
        }
    }
    
    private var featureMagazinesSection: some View {
        Group {
            Header("Featured")
                .padding([.top, .leading, .trailing])
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 24) {
                    switch state {
                    case .loading:
                        ForEach(0..<2) { _ in
                            // TODO: replace w/ trending magazine skeleton
                            SkeletonView()
                                .frame(width: magWidth, height: magHeight)
                        }
                    case .reloading(let results), .results(let results):
                        // TODO: Replace with results.trendingMagazines when backend is setup
                        ForEach(0..<10) { _ in
                            NavigationLink(destination: MagazineDetail()) {
                                FeaturedMagazineCell()
                            }
                        }
                    }
                }
            }
            .padding([.leading, .trailing])
        }
    }

    private var moreMagazinesSection: some View {
        Group {
            Header("More magazines")
                .padding([.top, .leading, .trailing])

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 24) {
                    switch state {
                    case .loading:
                        ForEach(0..<3) { _ in
                            // TODO: replace w/ trending magazine skeleton
                            SkeletonView()
                                .frame(width: magWidth, height: magHeight)
                        }
                    case .reloading(let results), .results(let results):
                        // TODO: Replace with results.trendingMagazines when backend is setup
                        ForEach(0..<10) { _ in
                            NavigationLink(destination: MagazineDetail()) {
                                FeaturedMagazineCell()
                            }
                        }
                    }
                }
            }
            .padding([.leading, .trailing])
        }
    }
    
    var body: some View {
        RefreshableScrollView { done in
            switch state {
            case .loading, .reloading:
                return
            case .results(let results):
                state = .reloading(results)
                fetchContent(done)
            }
        } content: {
            VStack {
                featureMagazinesSection
                Spacer().frame(height: 16)
                moreMagazinesSection
            }
        }
        .disabled(state.shouldDisableScroll)
        .padding(.top)
        .background(Color.volume.backgroundGray)
        .toolbar {
            ToolbarItem(placement: ToolbarItemPlacement.navigationBarLeading) {
                Image.volume.logo
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            fetchContent()
        }
    }
}

extension MagazinesList {
    typealias Results = (
        trendingMagazines: [Magazine],
        otherMagazines: [String : [Magazine]]
    )
    
    // TODO: implement when query objects have been designed
    //    typealias ResultsPublisher = Publishers.Zip<
    //        Publishers.Map<OperationPublisher<GetTrendingMagazinesQuery.Data>, MagazineFields>,
    //        Publishers.Map<OperationPublisher<GetAllMagazinesQuery.Data>, MagazineFields>
    //    >
}

struct MagazinesList_Previews: PreviewProvider {
    static var previews: some View {
        MagazinesList()
    }
}
