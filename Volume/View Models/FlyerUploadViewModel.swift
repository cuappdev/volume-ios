//
//  FlyerUploadViewModel.swift
//  Volume
//
//  Created by Vin Bui on 9/29/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import Combine
import PhotosUI
import SwiftUI

extension FlyerUploadView {

    @MainActor
    class ViewModel: ObservableObject {

        // MARK: - Properties

        @Published var allCategories: [String] = []
        @Published var buttonEnabled: Bool = false
        @Published var endIsFocused: Bool = false
        @Published var flyerCategory: String! = ""
        @Published var flyerEnd: Date = Date.now
        @Published var flyerImageData: Data?
        @Published var flyerImageItem: PhotosPickerItem?
        @Published var flyerLocation: String = ""
        @Published var flyerName: String = ""
        @Published var flyerStart: Date = Date.now
        @Published var flyerURL: String = ""
        @Published var showErrorMessage: Bool = false
        @Published var showSpinner: Bool = false
        @Published var startIsFocused: Bool = false
        @Published var uploadSuccessful: Bool?

        private var networkState: NetworkState?
        private var queryBag = Set<AnyCancellable>()

        var flyerStringInfo: [String?] {[
            flyerCategory,
            flyerLocation,
            flyerName,
            flyerURL
        ]}

        var flyerDateInfo: [Date] {[
            flyerEnd,
            flyerStart
        ]}

        // MARK: - Public Requests

        func fetchCategories() async {
            Network.shared.publisher(for: GetAllFlyerCategoriesQuery())
                .map { $0.getAllFlyerCategories }
                .sink { [weak self] completion in
                    self?.networkState?.handleCompletion(screen: .flyers, completion)
                } receiveValue: { [weak self] categories in
                    self?.flyerCategory = categories.first
                    self?.allCategories = categories.sorted { $0 < $1 }
                }
                .store(in: &queryBag)
        }

        func uploadFlyer(for organizationID: String?) async {
            uploadSuccessful = nil
            showSpinner = true

            if let flyerImageB64 = flyerImageData?.base64EncodedString(),
               let organizationID = organizationID {
                Network.shared.publisher(
                    for: CreateFlyerMutation(
                        title: flyerName,
                        startDate: flyerStart.flyerUTCISOString,
                        organizationID: organizationID,
                        location: flyerLocation,
                        imageB64: flyerImageB64,
                        flyerURL: formatFlyerURL(flyerURL),
                        endDate: flyerEnd.flyerUTCISOString,
                        categorySlug: flyerCategory
                    )
                )
                .map(\.createFlyer.fragments.flyerFields)
                .sink { [weak self] completion in
                    if case let .failure(error) = completion {
                        print("Error: CreateFlyerMutation failed on FlyerUploadView: \(error)")
                        self?.uploadSuccessful = false
                        self?.showSpinner = false
                    }
                } receiveValue: { [weak self] _ in
                    self?.uploadSuccessful = true
                    self?.showSpinner = false
                }
                .store(in: &queryBag)
            }
        }

        // MARK: - Helpers

        /**
         Format the given string to be passed into the network request

         If `flyerURL` is an empty string, return an empty string.
         Otherwise, prepend "http://" if the string does not contain "http://" and "https://".
         */
        private func formatFlyerURL(_ flyerURL: String) -> String {
            if flyerURL.isEmpty {
                return ""
            } else if !flyerURL.contains("http://") && !flyerURL.contains("https://") {
                return "http://\(flyerURL)"
            }
            return flyerURL
        }

    }

}
