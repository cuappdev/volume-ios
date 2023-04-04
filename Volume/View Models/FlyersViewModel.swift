//
//  FlyersViewModel.swift
//  Volume
//
//  Created by Vin Bui on 4/3/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import SwiftUI

extension FlyersView {
    
    @MainActor
    class ViewModel: ObservableObject {
        // MARK: - Properties
        
        // TODO: Remove dummy data
        
        @Published var allCategories: [String]? = ["All", "Dance", "Music", "Academic", "Sports"]
        @Published var pastFlyers: [Flyer]? = FlyerDummyData.pastFlyers
        @Published var selectedCategory: String? = "All"
        @Published var thisWeekFlyers: [Flyer]? = FlyerDummyData.thisWeekFlyers
        @Published var upcomingFlyers: [Flyer]? = FlyerDummyData.upcomingFlyers
        
        var disableScrolling: Bool {
            // TODO: Revert back
            return false
//            thisWeekFlyers == .none
        }
        
    }
    
}
