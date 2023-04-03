//
//  FlyerCellThisWeek.swift
//  Volume
//
//  Created by Vin Bui on 4/3/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct FlyerCellThisWeek: View {
    
    // MARK: - Constants
    
    private struct Constants {
        static let frameHeight: CGFloat = 256
        static let frameWidth: CGFloat = 256
    }
    
    // MARK: - UI
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

extension FlyerCellThisWeek {
    
    struct Skeleton: View {
        var body: some View {
            VStack(alignment: .leading) {
                SkeletonView()
                    .frame(width: Constants.frameWidth, height: Constants.frameHeight)
                
                SkeletonView()
                    .frame(width: 130, height: 15)
                
                SkeletonView()
                    .frame(width: 200, height: 20)
                
                SkeletonView()
                    .frame(width: 180, height: 15)
                
                SkeletonView()
                    .frame(width: 100, height: 15)
            }
        }
    }
    
}

struct FlyerCellThisWeek_Previews: PreviewProvider {
    static var previews: some View {
        FlyerCellThisWeek.Skeleton()
    }
}
