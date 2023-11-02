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

        @Published var allSemesters: [String]?
        @Published var featuredMagazines: [Magazine]?
        @Published var moreMagazines: [Magazine]?

        @Published var hasMoreMagazines: Bool = true
        @Published var selectedSemester: String? = Constants.allSemestersIdentifier

        @Published var searchState: SearchView.SearchState = .searching
        @Published var searchText: String = ""

        var networkState: NetworkState?
        private var queryBag: Set = Set<AnyCancellable>()

        // MARK: - Logic Constants

        private struct Constants {
            static let featuredMagazinesLimit: Double = 7
            static let semesterCountLimit: Double = 50
            static let moreMagazinesLimit: Double = 4
            static let allSemestersIdentifier: String = "all"
        }

        // MARK: - Public Requests

        func fetchContent() async {
            await fetchFeaturedMagazines()
            await fetchMagazineSemesters()

            if moreMagazines == nil {
                await fetchMoreMagazinesSection()
            }
        }

        func refreshContent() async {
            Network.shared.clearCache()
            queryBag.removeAll()

            featuredMagazines = nil
            moreMagazines = nil
            hasMoreMagazines = true

            Task {
                await fetchContent()
            }
        }

        func fetchMoreMagazinesSection() async {
            moreMagazines = nil
            hasMoreMagazines = true

            if selectedSemester == Constants.allSemestersIdentifier {
                await fetchAllSemestersMagazines()
            } else {
                await fetchSemesterMagazines()
            }
        }

        func fetchNextPage() async {
            if selectedSemester == Constants.allSemestersIdentifier {
                await fetchAllSemestersNextPage()
            } else {
                await fetchSemesterNextPage()
            }
        }

        // MARK: - Hidden Requests

        private func fetchFeaturedMagazines() async {
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

        private func fetchMagazineSemesters() async {
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

        private func fetchSemesterMagazines() async {
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

        private func fetchAllSemestersMagazines() async {
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

        private func fetchSemesterNextPage() async {
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

        private func fetchAllSemestersNextPage() async {
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
