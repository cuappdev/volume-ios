//
//  String+Extension.swift
//  Volume
//
//  Created by Vin Bui on 10/6/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    /**
     Returns the given camelCase string in Title Case.
     
     The first letter is always capitalized. Every subsequent capital letter in camelCase is also capitalized following a space.
     
     For example, `titleCase("foodDrinks")` returns `"Food Drinks"`.
     */
    func titleCase() -> String {
        return self
            .replacingOccurrences(of: "([A-Z])",
                                  with: " $1",
                                  options: .regularExpression,
                                  range: range(of: self))
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .capitalized
    }
    
}
