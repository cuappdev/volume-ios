//
//  UIFont+Extension.swift
//  Volume
//
//  Created by Hanzheng Li on 3/14/22.
//  Copyright © 2022 Cornell AppDev. All rights reserved.
//

import UIKit

extension UIFont {
    static func newYorkMedium(size: CGFloat) -> UIFont {
        let descriptor = UIFont.systemFont(ofSize: 24, weight: .medium).fontDescriptor
        return UIFont(descriptor: descriptor.withDesign(.serif) ?? descriptor, size: size)
    }
}
