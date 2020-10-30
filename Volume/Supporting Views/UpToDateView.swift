//
//  UpToDateView.swift
//  Volume
//
//  Created by Cameron Russell on 10/30/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct UpToDateView: View {
    var body: some View {
        VStack(spacing: 10) {
            Image("volume")
                .foregroundColor(._orange)
            Text("You're up to date!")
                .font(.system(size: 12, weight: .bold))
            Text("You've seen all new articles from the publications you're following.")
                .font(.system(size: 10, weight: .medium))
                .lineLimit(2)
                .multilineTextAlignment(.center)
            
        }
        .frame(width: 205)
    }
}

struct UpToDateView_Previews: PreviewProvider {
    static var previews: some View {
        UpToDateView()
    }
}
