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
    @State private var selectedSemester: String = Self.format(semesterString: Constants.currentSemester)
    
    private struct Constants {
        static let currentSemester = "fa22"
        static let featuredMagazinesLimit : Double = 7
        static let animationDuration = 0.1
        
    }

    private func fetchContent(_ done: @escaping () -> Void = { }) {
        guard sectionStates.featuredMagazines.isLoading || sectionStates.magazinesBySemester.isLoading else { return }
        
        fetchFeaturedMagazines(done)
        fetchMagazinesBySemester()
    }
    
    private func fetchFeaturedMagazines(_ done: @escaping () -> Void = { }) {
        sectionQueries.featuredMagazines = Network.shared.publisher(for: GetFeaturedMagazinesQuery(limit: Constants.featuredMagazinesLimit))
            .compactMap {
                $0.magazines?.map(\.fragments.magazineFields)
            }
            .sink { completion in
                networkState.handleCompletion(screen: .magazines, completion)
            } receiveValue: { magazineFields in
                let featuredMagazines = [Magazine](magazineFields)
                withAnimation(.linear(duration: Constants.animationDuration)) {
                    sectionStates.featuredMagazines = .results(featuredMagazines)
                }
                done()
            }
    }
    
    private func fetchMagazinesBySemester() {
        sectionQueries.magazinesBySemester = Network.shared.publisher(for: GetMagazinesBySemesterQuery(semester: Constants.currentSemester))
            .map { $0.magazines.map(\.fragments.magazineFields) }
            .sink { completion in
                networkState.handleCompletion(screen: .magazines, completion)
            } receiveValue: { magazineFields in
                let magazinesBySemester = [Magazine](magazineFields)
                
                withAnimation(.linear(duration: 0.1)) {
                    sectionStates.magazinesBySemester = .results(magazinesBySemester)
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
                        ForEach(results) { magazine in
                            NavigationLink(destination: MagazineReaderView(magazine: magazine)) {
                                MagazineCell(magazine: magazine)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
    }

    private var magazinesBySemesterSection: some View {
        Group {
            HStack(alignment: .center) {
                Header("More magazines")
                    .padding([.top, .horizontal])

                MenuView(
                    selection: $selectedSemester,
                    options: .constant(
                        ["fa22", "sp22", "fa21"]
                            .map { Self.format(semesterString: $0) }
                    )
                )
                .padding(.trailing, 16)
                .padding(.top, 8)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 24) {
                    switch sectionStates.magazinesBySemester {
                    case .loading:
                        ForEach(0..<10) { _ in
                             MagazineCell.Skeleton()
                        }
                    case .reloading(let results), .results(let results):
                        ForEach(results) { magazine in
                            NavigationLink(destination: MagazineReaderView(magazine: magazine)) {
                                MagazineCell(magazine: magazine)
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
            
            sectionStates.magazinesBySemester = .loading
            
            fetchContent(done)
            }) {
                VStack {
                    featureMagazinesSection
                    Spacer()
                        .frame(height: 16)
                    magazinesBySemesterSection
               }
            }
            .disabled(sectionStates.featuredMagazines.isLoading)
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
        magazinesBySemester: MainView.TabState<[Magazine]>
    )
    
    typealias SectionQueries = (
        featuredMagazines: AnyCancellable?,
        magazinesBySemester: AnyCancellable?
    )

    private static func format(semesterString: String) -> String {
        let prefix = semesterString.prefix(2)
        let suffix = semesterString.suffix(2)

        var result = ""

        switch prefix {
        case "fa":
            result = "Fall"
        case "sp":
            result = "Spring"
        default:
            break
        }

        return "\(result) 20\(suffix)"
    }
}
