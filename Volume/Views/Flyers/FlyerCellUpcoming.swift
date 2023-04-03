//
//  FlyerCellUpcoming.swift
//  Volume
//
//  Created by Vin Bui on 4/3/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct FlyerCellUpcoming: View {
    
    // MARK: - Constants
    
    private struct Constants {
        static let frameHeight: CGFloat = 92
        static let frameWidth: CGFloat = 92
    }
    
    // MARK: - UI
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

extension FlyerCellUpcoming {
    
    struct Skeleton: View {
        var body: some View {
            HStack {
                SkeletonView()
                    .frame(width: Constants.frameWidth, height: Constants.frameHeight)
                
                VStack(alignment: .leading) {
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
    
}

struct FlyerCellUpcoming_Previews: PreviewProvider {
    static var previews: some View {
        FlyerCellUpcoming()
    }
}
