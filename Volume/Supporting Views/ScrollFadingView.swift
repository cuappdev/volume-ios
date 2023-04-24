//
//  ScrollFadingView.swift
//  Volume
//
//  Created by Vin Bui on 4/23/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import SwiftUI

/// `fadesDown` if the fade gets stronger (more opaque) at the bottom
struct ScrollFadingView: View {
    
    // MARK: - Properties
    
    let fadesDown: Bool
    
    var body: some View {
        if fadesDown {
            Spacer()
        }
        
        LinearGradient(
            gradient: Gradient(
                colors: [
                    .clear,
                    .white
                ]
            ),
            startPoint: fadesDown ? .top : .bottom,
            endPoint: fadesDown ? .bottom : .top
        )
        .frame(height: 50)
        
        if !fadesDown {
            Spacer()
        }
    }
    
}

// MARK: - Uncomment below if needed

//struct ScrollFadingView_Previews: PreviewProvider {
//    static var previews: some View {
//        ScrollFadingView()
//    }
//}
