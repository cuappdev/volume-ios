//
//  MagazinesList.swift
//  Volume
//
//  Created by Hanzheng Li on 3/4/22.
//  Copyright © 2022 Cornell AppDev. All rights reserved.
//

import Combine
import SwiftUI

struct MagazinesList: View {
    @State private var cancellableQuery: AnyCancellable?
    @State private var state: MainView.TabState<Results> = .loading
    @EnvironmentObject private var networkState: NetworkState

    private func fetchContent(_ done: @escaping () -> Void = { }) {
        // Simulate network request delay with Publication network request
        // TODO: Replace with Magazines request
        cancellableQuery = Network.shared.publisher(for: GetAllPublicationsQuery())
            .map { data in data.publications.compactMap { $0 } }
            .sink { completion in
                networkState.handleCompletion(screen: .magazinesList, completion)
            } receiveValue: {
                done()
                withAnimation(.linear(duration: 0.1)) {
                    state = .results((
                    trendingMagazines: [],
                    otherMagazines: [:]))
                }
            }
    }
    
    private var featureMagazinesSection: some View {
        Group {
            Header("Featured")
                .padding([.top, .horizontal])
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 24) {
                    switch state {
                    case .loading:
                        ForEach(0..<10) { _ in
                             MagazineCell.Skeleton()
                        }
                    case .reloading(let results), .results(let results):
                        // TODO: Replace with results.trendingMagazines when backend is setup
                        ForEach(0..<10) { _ in
                            NavigationLink(destination: MagazineDetail()) {
                                MagazineCell()
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
    }

    private var moreMagazinesSection: some View {
        Group {
            Header("More magazines")
                .padding([.top, .horizontal])

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 24) {
                    switch state {
                    case .loading:
                        ForEach(0..<10) { _ in
                             MagazineCell.Skeleton()
                        }
                    case .reloading(let results), .results(let results):
                        // TODO: Replace with results.trendingMagazines when backend is setup
                        ForEach(0..<10) { _ in
                            NavigationLink(destination: MagazineDetail()) {
                                MagazineCell()
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    var body: some View {
        RefreshableScrollView(onRefresh: { done in
            switch state {
                case .loading, .reloading:
                    return
                case .results(let results):
                    state = .reloading(results)
                    fetchContent(done)
                }
            }) {
                VStack {
                    featureMagazinesSection
                    Spacer()
                        .frame(height: 16)
                    moreMagazinesSection
               }
            }
            .disabled(state.shouldDisableScroll)
            .padding(.top)
            .toolbar {
                ToolbarItem(placement: ToolbarItemPlacement.navigationBarLeading) {
                    BubblePeriodText("Magazines")
                        .font(.begumMedium(size: 28))
                        .offset(y: 8)
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
