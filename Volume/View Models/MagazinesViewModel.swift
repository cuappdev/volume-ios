//
//  MagazinesViewModel.swift
//  Volume
//
//  Created by Vin Bui on 3/23/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import Combine
import SwiftUI

extension MagazinesView {
    
    @MainActor
    class ViewModel: ObservableObject {
        
        // MARK: - Publishers
        typealias ResultsPublisher = Publishers.Zip3<
            Publishers.Map<OperationPublisher<GetFeaturedMagazinesQuery.Data>, MagazineFields>,
            Publishers.Map<OperationPublisher<GetMagazinesBySemesterQuery.Data>, MagazineFields>,
            Publishers.Map<OperationPublisher<GetAllMagazinesQuery.Data>, MagazineFields>
        >
        
        // MARK: - Properties
        
        @Published var allSemesters: [String]? = nil
        @Published var featuredMagazines: [Magazine]? = nil
        @Published var moreMagazines: [Magazine]? = nil
        
        @Published var hasMoreMagazines: Bool = true
        @Published var selectedSemester: String? = Constants.allSemestersIdentifier
        
        @Published var searchState: SearchView.SearchState = .searching
        @Published var searchText: String = ""
        
        var networkState: NetworkState?
        private var queryBag: Set = Set<AnyCancellable>()
        
        // MARK: - Logic Constants
        
        private struct Constants {
            static let featuredMagazinesLimit: Double = 7
            static let semesterCountLimit: Double = 50  // TODO: Change this value when backend implements getMagazineSemesters
            static let moreMagazinesLimit: Double = 4
            static let allSemestersIdentifier: String = "all"
        }
        
        // MARK: - Public Requests

        func fetchContent() async {
            fetchFeaturedMagazines()
            fetchMagazineSemesters()
            
            if moreMagazines == nil {
                fetchMoreMagazinesSection()
            }
        }
        
        func refreshContent(_ done: @escaping () -> Void = { } ) {
            Network.shared.clearCache()
            queryBag.removeAll()

            featuredMagazines = nil
            moreMagazines = nil
            hasMoreMagazines = true

            Task {
                await fetchContent()
                done()
            }
        }
        
        func fetchMoreMagazinesSection() {
            moreMagazines = nil
            
            if selectedSemester == Constants.allSemestersIdentifier {
                fetchAllSemestersMagazines()
            } else {
                fetchSemesterMagazines()
            }
        }
        
        func fetchNextPage() {
            if selectedSemester == Constants.allSemestersIdentifier {
                fetchAllSemestersNextPage()
            } else {
                fetchSemesterNextPage()
            }
        }
        
        // MARK: - Hidden Requests
        
        private func fetchFeaturedMagazines() {
            Network.shared.publisher(for: GetFeaturedMagazinesQuery(limit: Constants.featuredMagazinesLimit))
                .compactMap { $0.magazines?.map(\.fragments.magazineFields) }
                .sink { [weak self] completion in
                    self?.networkState?.handleCompletion(screen: .reads, completion)
                } receiveValue: { [weak self] magazineFields in
                    Task {
                        self?.featuredMagazines = await [Magazine](magazineFields)
                    }
                }
                .store(in: &queryBag)
        }
        
        private func fetchMagazineSemesters() {
            Network.shared.publisher(for: GetAllMagazineSemestersQuery(limit: Constants.semesterCountLimit))
                .map { $0.magazines.map(\.semester) }
                .sink { [weak self] completion in
                    self?.networkState?.handleCompletion(screen: .reads, completion)
                } receiveValue: { [weak self] semesters in
                    guard let `self` = self else { return }
                    self.allSemesters = Array(Set(semesters)).sorted(by: self.compareSemesters)
                    self.allSemesters?.insert(Constants.allSemestersIdentifier, at: 0)
                }
                .store(in: &queryBag)
        }
        
        private func fetchSemesterMagazines() {
            guard let selectedSemester = selectedSemester else { return }
            Network.shared
                .publisher(
                    for: GetMagazinesBySemesterQuery(
                        semester: selectedSemester,
                        limit: Constants.moreMagazinesLimit,
                        offset: 0
                    )
                )
                .map { $0.magazines.map(\.fragments.magazineFields) }
                .sink { [weak self] completion in
                    self?.networkState?.handleCompletion(screen: .reads, completion)
                } receiveValue: { [weak self] magazineFields in
                    Task {
                        self?.moreMagazines = await [Magazine](magazineFields)
                    }
                }
                .store(in: &queryBag)
        }
        
        private func fetchAllSemestersMagazines() {
            Network.shared
                .publisher(
                    for: GetAllMagazinesQuery(
                        limit: Constants.moreMagazinesLimit,
                        offset: 0
                    )
                )
                .map { $0.magazines.map(\.fragments.magazineFields) }
                .sink { [weak self] completion in
                    self?.networkState?.handleCompletion(screen: .reads, completion)
                } receiveValue: { [weak self] magazineFields in
                    Task {
                        self?.moreMagazines = await [Magazine](magazineFields)
                    }
                }
                .store(in: &queryBag)
        }
        
        private func fetchSemesterNextPage() {
            guard let selectedSemester = selectedSemester else { return }
            Network.shared
                .publisher(
                    for: GetMagazinesBySemesterQuery(
                        semester: selectedSemester,
                        limit: Constants.moreMagazinesLimit,
                        offset: offset(for: moreMagazines)
                    )
                )
                .map { $0.magazines.map(\.fragments.magazineFields) }
                .sink { [weak self] completion in
                    self?.networkState?.handleCompletion(screen: .reads, completion)
                } receiveValue: { [weak self] magazineFields in
                    Task {
                        let newMagazines = await [Magazine](magazineFields)
                        self?.loadMoreMagazines(with: newMagazines)
                    }
                }
                .store(in: &queryBag)
        }
        
        private func fetchAllSemestersNextPage() {
            Network.shared
                .publisher(
                    for: GetAllMagazinesQuery(
                        limit: Constants.moreMagazinesLimit,
                        offset: offset(for: moreMagazines)
                    )
                )
                .map { $0.magazines.map(\.fragments.magazineFields) }
                .sink { [weak self] completion in
                    self?.networkState?.handleCompletion(screen: .reads, completion)
                } receiveValue: { [weak self] magazineFields in
                    Task {
                        let newMagazines = await [Magazine](magazineFields)
                        self?.loadMoreMagazines(with: newMagazines)
                    }
                }
                .store(in: &queryBag)
        }
        
        // MARK: - Helpers
        
        private func loadMoreMagazines(with newMagazines: [Magazine]) {
            switch moreMagazines {
            case .none:
                moreMagazines = newMagazines
            case .some(let oldMagazines):
                moreMagazines = oldMagazines + newMagazines
            }

            if newMagazines.count < Int(Constants.moreMagazinesLimit) {
                hasMoreMagazines = false
            }
        }
        
        private func offset(for mags: [Magazine]?) -> Double {
            Double(mags?.count ?? 0)
        }
        
        private func compareSemesters(_ s1: String, _ s2: String) -> Bool {
            if let s1Year = Int(s1.suffix(2)),
               let s2Year = Int(s2.suffix(2)),
               s1Year != s2Year {
                return s1Year > s2Year
            }

            let validSemesterStrings = ["sp", "fa"]
            if let s1Semester = validSemesterStrings.firstIndex(of: String(s1.prefix(2))),
               let s2Semester = validSemesterStrings.firstIndex(of: String(s2.prefix(2))) {
                return s1Semester > s2Semester
            }

            return false
        }
    }
    
}
