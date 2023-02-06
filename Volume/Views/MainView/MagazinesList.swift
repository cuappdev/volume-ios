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
    @State private var deeplinkId: String?
    @State private var openMagazineFromDeeplink = false
    @State private var sectionQueries: SectionQueries = (nil, nil)
    @State private var sectionStates: SectionStates = (.loading, .loading)
    @State private var selectedSemester: String?
    @State private var allSemesters: [String]? = nil
    @State private var queryBag = Set<AnyCancellable>()

    private struct Constants {
        static let featuredMagazinesLimit: Double = 7
        static let animationDuration = 0.1
        static let navigationTitleKey = "MagazineReaderView"
    }

    // MARK: Requests

    private func fetchContent(_ done: @escaping () -> Void = { }) {
        guard sectionStates.featuredMagazines.isLoading || sectionStates.magazinesBySemester.isLoading else { return }
        
        fetchFeaturedMagazines(done)
        fetchMagazineSemesters()
    }
    
    private func fetchFeaturedMagazines(_ done: @escaping () -> Void = { }) {
        sectionQueries.featuredMagazines = Network.shared.publisher(for: GetFeaturedMagazinesQuery(limit: Constants.featuredMagazinesLimit))
            .compactMap {
                $0.magazines?.map(\.fragments.magazineFields)
            }
            .sink { completion in
                networkState.handleCompletion(screen: .magazines, completion)
            } receiveValue: { magazineFields in
                Task {
                    let featuredMagazines = await [Magazine](magazineFields)
                    withAnimation(.linear(duration: Constants.animationDuration)) {
                        sectionStates.featuredMagazines = .results(featuredMagazines)
                    }
                    done()
                }
            }
    }

    private func fetchMagazineSemesters() {
        // TODO: replace logic when backend implements Publication.getMagazineSemesters
        Network.shared.publisher(
            for: GetAllMagazineSemestersQuery(limit: 100)
        )
        .map { $0.magazines.map(\.semester) }
        .sink { completion in
            networkState.handleCompletion(screen: .magazines, completion)
        } receiveValue: { semesters in
            allSemesters = Array(Set(semesters))
                .sorted(by: compareSemesters)

            if let currentSemester = allSemesters?.last {
                selectedSemester = currentSemester
                fetchMagazinesBySemester(currentSemester)
            }
        }
        .store(in: &queryBag)
    }
    
    private func fetchMagazinesBySemester(_ semester: String) {
        sectionStates.magazinesBySemester = .loading

        sectionQueries.magazinesBySemester = Network.shared.publisher(
            for: GetMagazinesBySemesterQuery(semester: semester)
        )
        .map { $0.magazines.map(\.fragments.magazineFields) }
        .sink { completion in
            networkState.handleCompletion(screen: .magazines, completion)
        } receiveValue: { magazineFields in
            Task {
                let magazinesBySemester = await [Magazine](magazineFields)
                withAnimation(.linear(duration: 0.1)) {
                    sectionStates.magazinesBySemester = .results(magazinesBySemester)
                }
            }
        }
    }

    // MARK: UI
    
    private var featureMagazinesSection: some View {
        Group {
            Header("Featured")
                .padding([.top, .horizontal])
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 24) {
                    switch sectionStates.featuredMagazines {
                    case .loading, .reloading:
                        ForEach(0..<3) { _ in
                             MagazineCell.Skeleton()
                        }
                    case .results(let results):
                        ForEach(results) { magazine in
                            NavigationLink {
                                MagazineReaderView(initType: .readyForDisplay(magazine), navigationSource: .featuredMagazines)
                            } label: {
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

                Group {
                    if let allSemesters {
                        SemesterMenuView(
                            selection: $selectedSemester,
                            options: allSemesters
                        )
                    } else {
                        SemesterMenuView.Skeleton()
                    }
                }
                .padding(.trailing, 16)
                .padding(.top, 8)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 24) {
                    switch sectionStates.magazinesBySemester {
                    case .loading, .reloading:
                        ForEach(0..<3) { _ in
                             MagazineCell.Skeleton()
                        }
                    case .results(let results):
                        ForEach(results) { magazine in
                            NavigationLink {
                                MagazineReaderView(initType: .readyForDisplay(magazine), navigationSource: .moreMagazines)
                            } label: {
                                MagazineCell(magazine: magazine)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
        .onChange(of: selectedSemester) { newValue in
            if let selectedSemester {
                fetchMagazinesBySemester(selectedSemester)
            }
        }
    }

    private var deepNavigationLink: some View {
        Group {
            if let magazineId = deeplinkId {
                NavigationLink(Constants.navigationTitleKey, isActive: $openMagazineFromDeeplink) {
                    MagazineReaderView(initType: .fetchRequired(magazineId), navigationSource: .moreMagazines)
                }
                .hidden()
            }
        }
    }

    private var background: some View {
        ZStack {
            Color.volume.backgroundGray
            deepNavigationLink
        }
    }
    
    var body: some View {
        RefreshableScrollView { done in
            if case let .results(magazines) = sectionStates.featuredMagazines {
                sectionStates.featuredMagazines = .reloading(magazines)
            }
            
            sectionStates.magazinesBySemester = .loading
            
            fetchContent(done)
        } content: {
            VStack {
                featureMagazinesSection
                Spacer()
                    .frame(height: 16)
                magazinesBySemesterSection
            }
        }
        .disabled(sectionStates.featuredMagazines.isLoading)
        .padding(.top)
        .background(background)
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
        .onOpenURL { url in
            if url.isDeeplink,
                url.host == ValidURLHost.magazine.host,
               let id = url.parameters["id"] {
                deeplinkId = id
                openMagazineFromDeeplink = true
            }
        }
    }

    // MARK: Helpers

    private func compareSemesters(_ s1: String, _ s2: String) -> Bool {
        if let s1Year = Int(s1.suffix(2)),
           let s2Year = Int(s2.suffix(2)),
           s1Year != s2Year {
            return s1Year < s2Year
        }

        let validSemesterStrings = ["sp", "fa"]
        if let s1Semester = validSemesterStrings.firstIndex(of: String(s1.prefix(2))),
           let s2Semester = validSemesterStrings.firstIndex(of: String(s2.prefix(2))) {
            return s1Semester < s2Semester
        }

        return false
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
