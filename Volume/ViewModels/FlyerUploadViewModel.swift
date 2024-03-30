//
//  FlyerUploadViewModel.swift
//  Volume
//
//  Created by Vin Bui on 9/29/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import Alamofire
import Combine
import PhotosUI
import SwiftUI

extension FlyerUploadView {

    @MainActor
    class ViewModel: ObservableObject {

        // MARK: - Properties

        @Published var allCategories: [String] = []
        @Published var buttonEnabled: Bool = false
        @Published var deleteEditSuccess: Bool = false
        @Published var endIsFocused: Bool = false
        @Published var flyerCategory: String! = ""
        @Published var flyerEnd: Date = Date.now
        @Published var flyerImageData: Data?
        @Published var flyerImageItem: PhotosPickerItem?
        @Published var flyerLocation: String = ""
        @Published var flyerName: String = ""
        @Published var flyerStart: Date = Date.now
        @Published var flyerURL: String = ""
        @Published var showConfirmation: Bool = false
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
            Network.client.queryPublisher(query: VolumeAPI.GetAllFlyerCategoriesQuery())
                .compactMap { $0.data?.getAllFlyerCategories }
                .sink { [weak self] completion in
                    self?.networkState?.handleCompletion(screen: .bookmarks, completion)
                } receiveValue: { [weak self] categories in
                    guard let self = self else { return }

                    if self.flyerCategory == nil || self.flyerCategory.isEmpty {
                        self.flyerCategory = categories.first
                    }
                    self.allCategories = categories.sorted { $0 < $1 }
                }
                .store(in: &queryBag)
        }

        func uploadFlyer(for organizationID: String?) async {
            uploadSuccessful = nil
            showSpinner = true

            if let imageData = flyerImageData,
               let organizationID = organizationID,
               let url = URL(string: "\(Secrets.endpointServer)/flyers/") {

                // Create HTTP Request
                let parameters = [
                    "title": flyerName,
                    "startDate": flyerStart.flyerUTCISOString,
                    "organizationID": organizationID,
                    "location": flyerLocation,
                    "flyerURL": formatFlyerURL(flyerURL),
                    "endDate": flyerEnd.flyerUTCISOString,
                    "categorySlug": flyerCategory ?? ""
                ]

                AF.upload(
                    multipartFormData: { formData in
                        formData.append(imageData, withName: "image", fileName: "file.png", mimeType: "image/png")
                        for (key, value) in parameters {
                            formData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                        }
                    },
                    to: url,
                    method: .post
                )
                .validate()
                .response { [weak self] response in
                    switch response.result {
                    case .success:
                        self?.uploadSuccessful = true
                        self?.showSpinner = false
                    case .failure(let error):
                        print("Error: CreateFlyerRequest failed on FlyerUploadView: \(error)")
                        self?.uploadSuccessful = false
                        self?.showSpinner = false
                    }
                }
            }
        }

        func deleteFlyer(flyerID: String) async {
            showSpinner = true

            Network.client.mutationPublisher(mutation: VolumeAPI.DeleteFlyerMutation(id: flyerID))
                .sink { [weak self] completion in
                    if case let .failure(error) = completion {
                        print("Error: DeleteFlyerMutation failed on FlyerUploadView: \(error)")
                        self?.showSpinner = false
                        self?.deleteEditSuccess = false
                    }
                } receiveValue: { [weak self] _ in
                    self?.deleteEditSuccess = true
                    self?.showSpinner = false
                }
                .store(in: &queryBag)
        }

        func editFlyer(_ flyer: Flyer) async {
            showSpinner = true

            // Create HTTP Request
            guard let url = URL(string: "\(Secrets.endpointServer)/flyers/edit/") else { return }
            let parameters = [
                "flyerID": flyer.id,
                "title": flyerName,
                "startDate": flyerStart.flyerUTCISOString,
                "location": flyerLocation,
                "flyerURL": formatFlyerURL(flyerURL),
                "endDate": flyerEnd.flyerUTCISOString,
                "categorySlug": flyerCategory ?? ""
            ]

            AF.upload(
                multipartFormData: { [weak self] formData in
                    if let imageData = self?.flyerImageData {
                        formData.append(imageData, withName: "image", fileName: "file.png", mimeType: "image/png")
                    }
                    for (key, value) in parameters {
                        formData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                    }
                },
                to: url,
                method: .post
            )
            .validate()
            .response { [weak self] response in
                switch response.result {
                case .success:
                    self?.deleteEditSuccess = true
                    self?.showSpinner = false
                case .failure(let error):
                    print("Error: EditFlyerRequest failed on FlyerUploadView: \(error)")
                    self?.deleteEditSuccess = false
                    self?.showSpinner = false
                }
            }
        }

        // MARK: - Helpers

        func checkCriteria(_ isEditing: Bool) {
            if isEditing {
                buttonEnabled = !flyerName.isEmpty &&
                !flyerLocation.isEmpty && !flyerCategory.isEmpty &&
                (flyerStart < flyerEnd)
            } else {
                buttonEnabled = !flyerName.isEmpty &&
                !flyerLocation.isEmpty && !flyerCategory.isEmpty &&
                (flyerStart < flyerEnd) && flyerImageItem != nil
            }

            if flyerStart > flyerEnd {
                flyerEnd = flyerStart
            }
        }

        func loadEdit(_ flyer: Flyer) {
            flyerCategory = flyer.categorySlug.titleCase()
            flyerEnd = flyer.endDate
            flyerLocation = flyer.location
            flyerName = flyer.title
            flyerStart = flyer.startDate
            flyerURL = flyer.flyerUrl?.absoluteString ?? ""
        }

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
