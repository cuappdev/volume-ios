//
//  WebImage+Extension.swift
//  Volume
//
//  Created by Daniel Vebman on 12/6/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import SDWebImageSwiftUI
import SwiftUI

extension WebImage {
    func grayBackground() -> WebImage {
        self.placeholder { Rectangle().foregroundColor(.gray) }
    }
}
