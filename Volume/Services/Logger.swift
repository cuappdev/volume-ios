//
//  Logger.swift
//  Volume
//
//  Created by Vin Bui on 3/30/24.
//  Copyright © 2024 Cornell AppDev. All rights reserved.
//

import OSLog

/// Manage Volume's logging system.
extension Logger {

    /// The logger's subsystem.
    private static var subsystem = Bundle.main.bundleIdentifier!

    /// All logs related to data such as decoding error, parsing issues, etc.
    static let data = Logger(subsystem: subsystem, category: "data")

    /// All logs related to services such as network calls, location, etc.
    static let services = Logger(subsystem: subsystem, category: "services")

    /// All logs related to tracking and analytics.
    static let statistics = Logger(subsystem: subsystem, category: "statistics")

}
