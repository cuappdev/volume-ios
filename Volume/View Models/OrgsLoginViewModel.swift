//
//  OrgsLoginViewModel.swift
//  Volume
//
//  Created by Vin Bui on 9/29/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import Combine
import SwiftUI

extension OrgsLoginView {

    @MainActor
    class ViewModel: ObservableObject {

        // MARK: - Properties

        @AppStorage("orgAccessCode") var orgAccessCode: String = ""
        @AppStorage("orgSlug") var orgSlug: String = ""

        @Published var accessCode: String = ""
        @Published var buttonEnabled: Bool = false
        @Published var isAuthenticated: Bool = false
        @Published var isInfoSaved: Bool = false
        @Published var showErrorMessage: Bool = false
        @Published var showSpinner: Bool = false
        @Published var slug: String = ""
        @Published var organization: Organization?

        var orgLoginInfo: [String] {[
            accessCode,
            slug
        ]}

        private var networkState: NetworkState?
        private var queryBag = Set<AnyCancellable>()

        // MARK: - Logic Constants

        private struct Constants {
            static let maxAccessCodeLength: Int = 6
        }

        // MARK: - Public Requests

        func authenticate(accessCode: String, slug: String) async {
            organization = nil // Reset
            showSpinner = true

            Network.shared.publisher(for: CheckAccessCodeQuery(accessCode: accessCode, slug: slug))
                .compactMap { $0.organization?.fragments.organizationFields }
                .sink { [weak self] completion in
                    switch completion {
                    case .failure(let error):
                        print("Error in OrgsLoginViewModel.authenticate: \(error)")
                        self?.showErrorMessage = true
                        self?.isAuthenticated = false
                        self?.showSpinner = false
                    default:
                        break
                    }
                } receiveValue: { [weak self] organizationFields in
                    self?.organization = Organization(from: organizationFields)
                    self?.showErrorMessage = false
                    self?.isAuthenticated = true
                    self?.showSpinner = false

                    // Save/unsave login
                    if let self = self {
                        if self.isInfoSaved {
                            UserDefaults.standard.setValue(self.slug, forKey: "orgSlug")
                            UserDefaults.standard.setValue(self.accessCode, forKey: "orgAccessCode")
                        } else {
                            UserDefaults.standard.setValue("", forKey: "orgSlug")
                            UserDefaults.standard.setValue("", forKey: "orgAccessCode")
                        }
                    }
                }
                .store(in: &queryBag)
        }

        // MARK: - Helpers

        func updateAuthenticateButton() {
            withAnimation(.easeOut(duration: 0.3)) {
                buttonEnabled = accessCode.count == Constants.maxAccessCodeLength && !slug.isEmpty
            }
        }

        func fetchSavedInfo() {
            accessCode = orgAccessCode
            slug = orgSlug
            isInfoSaved = !orgAccessCode.isEmpty && !orgSlug.isEmpty
        }

    }

}
