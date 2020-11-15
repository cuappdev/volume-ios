//
//  UpToDateView.swift
//  Volume
//
//  Created by Cameron Russell on 10/30/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct UpToDate: View {
    
    var body: some View {
        VStack(spacing: 10) {
            Image("volume")
                .foregroundColor(.volumeOrange)
            Text("You're up to date!") // TODO: Begum
                .font(.system(size: 12, weight: .bold))
            Text("You've seen all new articles from the publications you're following.")
                .font(.custom("Helvetica-Regular", size: 10))
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(width: 205, height: 100)
    }
    
}

struct UpToDateView_Previews: PreviewProvider {
    static var previews: some View {
        UpToDate()
    }
}
