//
//  FlyerUploadViewModel.swift
//  Volume
//
//  Created by Vin Bui on 9/29/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import Combine
import SwiftUI

extension FlyerUploadView {
    
    @MainActor
    class ViewModel: ObservableObject {
        
        // MARK: - Properties
        
        @Published var endIsFocused: Bool = false
        @Published var flyerEnd: Date = Date.now
        @Published var flyerLocation: String = ""
        @Published var flyerName: String = ""
        @Published var flyerStart: Date = Date.now
        @Published var startIsFocused: Bool = false
        
        // MARK: - Public Requests
        
    }
    
}
