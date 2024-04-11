//
//  HamburgerMenuView.swift
//  Volume
//
//  Created by Vin Bui on 4/3/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct HamburgerMenuView: View {

    // MARK: - Constants

    private struct Constants {
        static let hamburgerLineHeight: CGFloat = 1
        static let hamburgerLineSpacing: CGFloat = 7
        static let hamburgerLineWidth: CGFloat = 25
        static let hamburgerPadding: CGFloat = 10
    }

    // MARK: - UI

    var body: some View {
        Group {
            VStack(spacing: Constants.hamburgerLineSpacing) {
                Rectangle()
                    .frame(width: Constants.hamburgerLineWidth, height: Constants.hamburgerLineHeight)
                Rectangle()
                    .frame(width: Constants.hamburgerLineWidth, height: Constants.hamburgerLineHeight)
                Rectangle()
                    .frame(width: Constants.hamburgerLineWidth, height: Constants.hamburgerLineHeight)
            }
            .contentShape(Rectangle())
        }
        .padding(.init(
            top: Constants.hamburgerPadding,
            leading: Constants.hamburgerPadding,
            bottom: Constants.hamburgerPadding,
            trailing: Constants.hamburgerPadding
        ))
    }

}
