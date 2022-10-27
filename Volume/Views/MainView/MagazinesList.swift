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
    @EnvironmentObject private var networkState: NetworkState
    @State private var onOpenMagazineUrl: String?
    @State private var openedUrl = false
    @State private var sectionQueries: SectionQueries = (nil, nil)
    @State private var sectionStates: SectionStates = (.loading, .loading)


    private func fetchContent(_ done: @escaping () -> Void = { }) {
        guard sectionStates.featuredMagazines.isLoading || sectionStates.otherMagazines.isLoading else { return }
        
        fetchFeaturedMagazines(done)
        fetchOtherMagazines()
    }
    
    private func fetchFeaturedMagazines(_ done: @escaping () -> Void = { }) {
        sectionQueries.featuredMagazines = Network.shared.publisher(for: GetFeaturedMagazinesQuery(limit: 7))
            .map {
                // not sure if force-unwrapping here is safe
                $0.magazines!.map(\.fragments.magazineFields)
            }
            .sink { completion in
                networkState.handleCompletion(screen: .magazinesList, completion)
            } receiveValue: { magazineFields in
                let featuredMagazines = [Magazine](magazineFields)
                
                withAnimation(.linear(duration: 0.1)) {
                    sectionStates.featuredMagazines = .results(featuredMagazines)
                }
                done()
            }
    }
    
    private var currentSemester = "fa22"
    
    private func fetchOtherMagazines() {
        sectionQueries.otherMagazines = Network.shared.publisher(for: GetMagazinesBySemesterQuery(semester: currentSemester))
            .map { $0.magazines.map(\.fragments.magazineFields) }
            .sink { completion in
                networkState.handleCompletion(screen: .magazinesList, completion)
            } receiveValue: { magazineFields in
                let otherMagazines = [Magazine](magazineFields)
                
                withAnimation(.linear(duration: 0.1)) {
                    sectionStates.otherMagazines = .results(otherMagazines)
                }
            }
    }
    
    private var featureMagazinesSection: some View {
        Group {
            Header("Featured")
                .padding([.top, .horizontal])
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 24) {
                    switch sectionStates.featuredMagazines {
                    case .loading:
                        ForEach(0..<10) { _ in
                             MagazineCell.Skeleton()
                        }
                    case .reloading(let results), .results(let results):
                        // TODO: Replace with results.trendingMagazines when backend is setup
                        ForEach(results) { magazine in
                            NavigationLink(destination: MagazineDetail(title: magazine.title)) {
                                MagazineCell()
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
    }

    private var otherMagazinesSection: some View {
        Group {
            Header("More magazines")
                .padding([.top, .horizontal])

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 24) {
                    switch sectionStates.otherMagazines {
                    case .loading:
                        ForEach(0..<10) { _ in
                             MagazineCell.Skeleton()
                        }
                    case .reloading(let results), .results(let results):
                        // TODO: Replace with results.trendingMagazines when backend is setup
                        ForEach(results) { magazine in
                            NavigationLink(destination: MagazineDetail(title: magazine.title)) {
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
            if case let .results(magazines) = sectionStates.featuredMagazines {
                sectionStates.featuredMagazines = .reloading(magazines)
            }
            
            sectionStates.otherMagazines = .loading
            
            fetchContent(done)
            }) {
                VStack {
                    featureMagazinesSection
                    Spacer()
                        .frame(height: 16)
                    otherMagazinesSection
               }
            }
            .disabled(sectionStates.featuredMagazines.shouldDisableScroll)
            .padding(.top)
            .background(Color.volume.backgroundGray)
            .toolbar {
                ToolbarItem(placement: ToolbarItemPlacement.navigationBarLeading) {
                    BubblePeriodText("Magazines")
                        .font(.newYorkMedium(size: 28))
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
    typealias ResultsPublisher = Publishers.Zip<
        Publishers.Map<OperationPublisher<GetFeaturedMagazinesQuery.Data>, MagazineFields>,
        Publishers.Map<OperationPublisher<GetMagazinesBySemesterQuery.Data>, MagazineFields>
        >
    
    typealias SectionStates = (
        featuredMagazines: MainView.TabState<[Magazine]>,
        otherMagazines: MainView.TabState<[Magazine]>
    )
    
    typealias SectionQueries = (
        featuredMagazines: AnyCancellable?,
        otherMagazines: AnyCancellable?
    )
}

//struct MagazinesList_Previews: PreviewProvider {
//    static var previews: some View {
//        MagazinesList()
//    }
//}
