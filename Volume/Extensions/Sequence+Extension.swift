//
//  Sequence+Extension.swift
//  Volume
//
//  Created by Hanzheng Li on 2/6/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import Foundation

extension Sequence {

    func asyncMap<T>(_ transform: (Element) async throws -> T) async rethrows -> [T] {
        var values = [T]()
        for element in self {
            try await values.append(transform(element))
        }
        return values
    }

}
