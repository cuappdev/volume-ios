//
//  Calendar+Extension.swift
//  Volume
//
//  Created by Vin Bui on 5/24/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import Foundation

extension Calendar {
    
    private var currentDate: Date { return Date() }
    
    /// Returns `True` if `date` is within this week. `False` otherwise.
    func isDateInThisWeek(_ date: Date) -> Bool {
        return isDate(date, equalTo: currentDate, toGranularity: .weekOfYear)
    }
    
}
