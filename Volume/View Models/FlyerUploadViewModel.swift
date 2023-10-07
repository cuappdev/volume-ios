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
        @Published var flyerImage: PhotosPickerItem? = nil
        @Published var flyerLocation: String = ""
        @Published var flyerName: String = ""
        @Published var flyerStart: Date = Date.now
        @Published var flyerURL: String = ""
        @Published var showErrorMessage: Bool = false
        @Published var startIsFocused: Bool = false
        
        private var networkState: NetworkState?
        private var queryBag = Set<AnyCancellable>()
        
        var flyerStringInfo: [String] {[
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
        
    }
    
}
