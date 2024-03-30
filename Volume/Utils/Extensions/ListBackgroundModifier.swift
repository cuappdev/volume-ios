//
//  ListBackgroundModifier.swift
//  Volume
//
//  Created by Hanzheng Li on 10/27/22.
//  Copyright © 2022 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct ListBackgroundModifier: ViewModifier {

    @ViewBuilder
    func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            content
                .scrollContentBackground(.hidden)
        } else {
            content
        }
    }

}
