//
//  JSONDecoder+Extension.swift
//  Volume
//
//  Created by Vin Bui on 4/20/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import Foundation

extension JSONDecoder {
    
    /// Return a `JSONDecoder` for flyers with the date format of "MMM d yy h:mm a"
    static var flyersDecoder: JSONDecoder {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d yy h:mm a"
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(formatter)
        
        return decoder
    }
    
}
