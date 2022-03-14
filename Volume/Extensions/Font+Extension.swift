//
//  Font+Extension.swift
//  Volume
//
//  Created by Daniel Vebman on 11/7/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import SwiftUI

extension Font {
    static func helveticaRegular(size: CGFloat) -> Font {
        .custom("Helvetica-Regular", size: size)
    }

    static func helveticaBold(size: CGFloat) -> Font {
        .custom("Helvetica-Bold", size: size)
    }
    
    static func helveticaNeueMedium(size: CGFloat) -> Font {
        .custom("HelveticaNeue-Medium", size: size)
    }
    
    static func newYorkRegular(size: CGFloat) -> Font {
        let descriptor = UIFont.systemFont(ofSize: 24, weight: .regular).fontDescriptor
        return Font(UIFont(descriptor: descriptor.withDesign(.serif) ?? descriptor, size: size))
    }
    
    static func newYorkMedium(size: CGFloat) -> Font {
        let descriptor = UIFont.systemFont(ofSize: 24, weight: .medium).fontDescriptor
        return Font(UIFont(descriptor: descriptor.withDesign(.serif) ?? descriptor, size: size))
    }
    
    static func newYorkBold(size: CGFloat) -> Font {
        let descriptor = UIFont.systemFont(ofSize: 24, weight: .bold).fontDescriptor
        return Font(UIFont(descriptor: descriptor.withDesign(.serif) ?? descriptor, size: size))
    }
}
