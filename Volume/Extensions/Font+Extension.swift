//
//  Font+Extension.swift
//  Volume
//
//  Created by Daniel Vebman on 11/7/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import SwiftUI

extension Font {
    static func begumRegular(size: CGFloat) -> Font {
        .custom("Begum-Regular", size: size)
    }

    static func begumMedium(size: CGFloat) -> Font {
        .custom("Begum-Medium", size: size)
    }

    static func begumBold(size: CGFloat) -> Font {
        .custom("Begum-Bold", size: size)
    }

    static func helveticaRegular(size: CGFloat) -> Font {
        .custom("Helvetica-Regular", size: size)
    }

    static func helveticaBold(size: CGFloat) -> Font {
        .custom("Helvetica-Bold", size: size)
    }
    
    static func latoRegular(size: CGFloat) -> Font {
        .custom("Lato-Regular", size: size)
    }
    
    static func latoMedium(size: CGFloat) -> Font {
        .custom("Lato-Medium", size: size)
    }
    
    static func latoBold(size: CGFloat) -> Font {
        .custom("Lato-Bold", size: size)
    }
}
