//
//  NoConnectionView.swift
//  Volume
//
//  Created by Sergio Diaz on 4/10/21.
//  Copyright © 2021 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct ConnectionFailedView: View {
    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            Image("no-connection")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 64, height: 64)
                .padding(.bottom, 20)

            Text("No Connection")
                .font(.begumMedium(size: 25))
                .padding(.bottom, 2)

            Text("Please try again later")
                .font(.system(size: 18))

            Spacer()
            Spacer() // second spacer adjusts content to top third of view
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
        .background(Color.volume.backgroundGray)
    }
}
