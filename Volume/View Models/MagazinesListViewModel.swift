//
//  MagazinesListViewModel.swift
//  Volume
//
//  Created by Vin Bui on 3/18/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import SwiftUI
import Combine

extension MagazinesList {
    
    @MainActor
    class ViewModel: ObservableObject {
        @Published var deeplinkId: String?
        @Published var openMagazineFromDeeplink = false
        @Published var sectionQueries: SectionQueries = (nil, nil)
        @Published var sectionStates: SectionStates = (.loading, .loading)
        @Published var selectedSemester: String?
        @Published var allSemesters: [String]? = nil
        @Published var queryBag = Set<AnyCancellable>()
                
        var networkState: NetworkState = NetworkState()
        private var numMagsLoaded: Double = 0
        private var offset: Double = 0

        private struct Constants {
            static let allMagazinesLimit: Double = 15
            static let featuredMagazinesLimit: Double = 7
            static let animationDuration = 0.1
        }
        
        // MARK: Requests

        func fetchContent(_ done: @escaping () -> Void = { }) {
            guard sectionStates.featuredMagazines.isLoading || sectionStates.magazinesBySemester.isLoading else { return }
            
            fetchFeaturedMagazines(done)
            fetchMagazineSemesters()
        }
        
        func fetchFeaturedMagazines(_ done: @escaping () -> Void = { }) {
            sectionQueries.featuredMagazines = Network.shared.publisher(for: GetFeaturedMagazinesQuery(limit: Constants.featuredMagazinesLimit))
                .compactMap {
                    $0.magazines?.map(\.fragments.magazineFields)
                }
                .sink { [weak self] completion in
                    self?.networkState.handleCompletion(screen: .magazines, completion)
                } receiveValue: { [weak self] magazineFields in
                    Task {
                        let featuredMagazines = await [Magazine](magazineFields)
                        withAnimation(.linear(duration: Constants.animationDuration)) {
                            self?.sectionStates.featuredMagazines = .results(featuredMagazines)
                        }
                        done()
                    }
                }
        }

        func fetchMagazineSemesters() {
            // TODO: replace logic when backend implements Publication.getMagazineSemesters
            Network.shared.publisher(
                for: GetAllMagazineSemestersQuery(limit: 100)
            )
            .map { $0.magazines.map(\.semester) }
            .sink { [weak self] completion in
                self?.networkState.handleCompletion(screen: .magazines, completion)
            } receiveValue: { [weak self] semesters in
                guard let `self` = self else { return }
                self.allSemesters = Array(Set(semesters))
                    .sorted(by: self.compareSemesters)
                
                self.allSemesters?.reverse()
                self.allSemesters?.insert("all", at: 0)
                self.selectedSemester = "all"
                self.fetchAllMagazines()
            }
            .store(in: &queryBag)
        }
        
        func fetchMagazinesBySemester(_ semester: String) {
            sectionStates.magazinesBySemester = .loading

            sectionQueries.magazinesBySemester = Network.shared.publisher(
                for: GetMagazinesBySemesterQuery(semester: semester)
            )
            .map { $0.magazines.map(\.fragments.magazineFields) }
            .sink { [weak self] completion in
                self?.networkState.handleCompletion(screen: .magazines, completion)
            } receiveValue: { [weak self] magazineFields in
                Task {
                    let magazinesBySemester = await [Magazine](magazineFields)
                    withAnimation(.linear(duration: 0.1)) {
                        self?.sectionStates.magazinesBySemester = .results(magazinesBySemester)
                    }
                }
            }
        }
        
        func fetchAllMagazines() {
            sectionStates.magazinesBySemester = .loading
            sectionQueries.magazinesBySemester = Network.shared.publisher(
                for: GetAllMagazinesQuery(limit: Constants.allMagazinesLimit, offset: offset)
            )
            .map { $0.magazines.map(\.fragments.magazineFields) }
            .sink { [weak self] completion in
                self?.networkState.handleCompletion(screen: .magazines, completion)
            } receiveValue: { [weak self] magazineFields in
                Task {
                    let allMagazines = await [Magazine](magazineFields)
                    withAnimation(.linear(duration: 0.1)) {
                        self?.sectionStates.magazinesBySemester = .results(allMagazines)
                    }
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
