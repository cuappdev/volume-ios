//
//  Keys.swift
//  Volume
//
//  Created by Daniel Vebman on 12/7/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import Foundation

struct Secrets {
    #if DEBUG
    static let endpoint = URL(string: keyDict["graphql-endpoint-debug"] as! String)!
    #else
    static let endpoint = URL(string: keyDict["graphql-endpoint-production"] as! String)!
    #endif
    
    private static let keyDict: NSDictionary = {
       guard let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
             let dict = NSDictionary(contentsOfFile: path)
       else { return [:] }
       return dict
   }()
}
