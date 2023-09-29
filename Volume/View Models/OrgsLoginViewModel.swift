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
        
        @Published var accessCode: String = ""
        @Published var buttonEnabled: Bool = false
        @Published var showErrorMessage: Bool = false
        @Published var slug: String = ""
        @Published var organization: Organization?
        
        private var networkState: NetworkState?
        private var queryBag = Set<AnyCancellable>()
        
        // MARK: - Public Requests
        
        func authenticate(accessCode: String, slug: String) async {
            organization = nil // Reset
            
            Network.shared.publisher(for: CheckAccessCodeQuery(accessCode: accessCode, slug: slug))
                .compactMap { $0.organization?.fragments.organizationFields }
                .sink { [weak self] completion in
                    switch completion {
                    case .failure(let error):
                        print("Error in OrgsLoginViewModel.authenticate: \(error)")
                        self?.showErrorMessage = true
                    default:
                        break
                    }
                } receiveValue: { [weak self] organizationFields in
                    self?.organization = Organization(from: organizationFields)
                    self?.showErrorMessage = false
                }
                .store(in: &queryBag)
        }
        
    }
    
}
