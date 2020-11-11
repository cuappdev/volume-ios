//
//  Font+Extension.swift
//  Volume
//
//  Created by Daniel Vebman on 11/7/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import SwiftUI

extension Font {

    private static let futuraBold = "Futura-Bold"
    private static let helveticaBold = "Helvetica-Bold"
    private static let helveticaRegular = "Helvetica-Regular"

    static let sectionHeader1: Font = .custom(Font.futuraBold, size: 18)
    static let sectionHeader2: Font = .custom(Font.futuraBold, size: 15)

    static let bodyHeader1: Font = .custom(Font.helveticaBold, size: 18)
    static let body: Font = .custom(Font.helveticaRegular, size: 14)

    static let detail1: Font = .custom(Font.helveticaRegular, size: 12)
    static let detail2: Font = .custom(Font.helveticaRegular, size: 10)

    static let ctaPrimary: Font = .custom(Font.helveticaBold, size: 12)
    static let ctaSecondary: Font = .custom(Font.helveticaRegular, size: 12)

//    public static let _lightGray = Color(white: 153/255, opacity: 1)

//    public static let _orange = Color(red: 208/255, green: 112/255, blue: 0/255, opacity: 1)

}
