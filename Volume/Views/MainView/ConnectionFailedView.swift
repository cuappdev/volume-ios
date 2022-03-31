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

            Image.volume.noConnection
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 58, height: 58)
                .padding(.bottom, 20)

            Text("No Connection")
                .font(.newYorkMedium(size: 23))
                .padding(.bottom, 2)

            Text("Please try again later")
                .font(.system(size: 17))

            Spacer()
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
        .offset(x: 0, y: -20)
        .background(Color.white)
    }
}
