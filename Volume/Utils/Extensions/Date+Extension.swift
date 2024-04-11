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

    /**
     * This `Date` in the format M/D. For example, August 18th is 8/18
     */
    var simpleString: String {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("M/dd")
        return formatter.string(from: self)
    }

    /// This `Date` in the format "EEE, MMMM d". For example, Tuesday April 11 is Tue, April 11
    var flyerDateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, MMMM d"
        return formatter.string(from: self)
    }

    /// This `Date` in UTC ISO 8601 format
    var flyerUTCISOString: String {
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = NSTimeZone(abbreviation: "UTC") as? TimeZone
        return formatter.string(from: self)
    }

    /// This `Date` in the format "h:mm a" with trailing 00 removed. For example, 8:00PM is 8PM
    var flyerTimeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"

        // Remove trailing 00
        let formatted = formatter.string(from: self)
        if formatted.hasSuffix("00 AM") || formatted.hasSuffix("00 PM"),
           let colonPos = formatted.firstIndex(of: ":"),
           let spacePos = formatted.firstIndex(of: " ") {

            let first = formatted[..<colonPos]
            let last = formatted[formatted.index(spacePos, offsetBy: 1)...]
            return String(first + last)
        }

        return formatted
    }

    /// Returns true if this `Date` is between the two given dates. False otherwise.
    func isBetween(_ date1: Date, and date2: Date) -> Bool {
        (min(date1, date2) ... max(date1, date2)).contains(self)
    }

}
