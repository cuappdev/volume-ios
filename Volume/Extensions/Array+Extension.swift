//
//  Array+Extension.swift
//  Volume
//
//  Created by Vin Bui on 4/11/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import Foundation

// TODO: Remove this once backend is finished implementing
extension Array {
        
    /// Picks `n` random elements from this `Aray`
    subscript (randomPick n: Int) -> [Element] {
        var copy = self
        for i in stride(from: count - 1, to: count - n - 1, by: -1) {
            copy.swapAt(i, Int(arc4random_uniform(UInt32(i + 1))))
        }
        return Array(copy.suffix(n))
    }
    
}
