//
//  SearchQueryResults.swift
//  Volume
//
//  Created by Vian Nguyen on 11/25/22.
//  Copyright © 2022 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct SearchQueryResultsView: View {
    
    var searchQuery: String
    
    var body: some View {
        VStack {
            Text("Search Query Results")
            Text("\(searchQuery)")
        }
    }
    
}
