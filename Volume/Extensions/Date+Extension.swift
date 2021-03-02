//
//  Date+Extension.swift
//  Volume
//
//  Created by Cameron Russell on 11/15/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import Foundation

extension Date {
    var fullString: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: Date())
    }

    /// This `Date` in the format yyyy-MM-dd
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }

    static func from(iso8601 date: String) -> Date {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withFullDate, .withTime, .withDashSeparatorInDate, .withColonSeparatorInTime]
        return dateFormatter.date(from: date) ?? Date()
    }
}
