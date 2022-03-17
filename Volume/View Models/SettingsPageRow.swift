//
//  SettingsPageRow.swift
//  Volume
//
//  Created by Cameron Russell on 4/15/21.
//  Copyright © 2021 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct SettingsPageRow: View {
    let page: SettingsPage
    
    private var row: some View {
        HStack {
            Image(page.imageName)
                .resizable()
                .renderingMode(.template)
                .foregroundColor(.volume.lightGray)
                .frame(width: 24, height: 24)
                .padding()
            Text(page.info)
                .font(.helveticaRegular(size: 16))
                .foregroundColor(.black)
            Spacer()
            Image.volume.backArrow
                .rotationEffect(Angle(degrees: 180))
                .padding()
        }
        .padding([.leading, .trailing])
    }
    
    var body: some View {
        switch page.destination {
        case .externalLink(let urlString):
            if let url = URL(string: urlString) {
                Link(destination: url) {
                    row
                }
            }
        case .internalView(let view):
            NavigationLink(destination: SettingsView.getView(for: view)) {
                row
            }
        }
    }
}

//struct SettingsPageRow_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingsPageRow()
//    }
//}
