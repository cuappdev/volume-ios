//
//  FlyerCategoryMenu.swift
//  Volume
//
//  Created by Vin Bui on 4/3/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct FlyerCategoryMenu: View {
    
    // MARK: - Properties

    let categories: [String]
    @Binding var selected: String?
    
    // MARK: - Constants
    
    private struct Constants {
        static let cornerRadius: CGFloat = 5
        static let defaultSelected: String = "All"
        static let downArrowSize = CGSize(width: 20, height: 16)
        static let font: Font = .helveticaRegular(size: 12)
        static let insets = EdgeInsets(top: 6, leading: 15, bottom: 6, trailing: 11)
        static let strokeWidth: CGFloat = 1.5
    }
    
    // MARK: - UI
    
    var body: some View {
        Menu {
            ForEach(categories, id: \.self) { category in
                Button(category) {
                    selected = category
                }
            }
        } label: {
            dropdownTab
        }
    }
    
    private var dropdownTab: some View {
        HStack {
            Text(selected ?? Constants.defaultSelected)
                .font(Constants.font)
                .fixedSize()
            
            Image("down-arrow")
                .resizable()
                .renderingMode(.template)
                .aspectRatio(contentMode: .fit)
                .frame(width: Constants.downArrowSize.width, height: Constants.downArrowSize.height)
        }
        .padding(Constants.insets)
        .foregroundColor(.volume.orange)
        .overlay {
            RoundedRectangle(cornerRadius: Constants.cornerRadius)
                .stroke(Color.volume.orange, lineWidth: Constants.strokeWidth)
        }
    }
    
}

extension FlyerCategoryMenu {
    
    struct Skeleton: View {
        var body: some View {
            HStack {
                SkeletonView()
                    .font(Constants.font)
                    .fixedSize()

                Image("down-arrow")
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: Constants.downArrowSize.width, height: Constants.downArrowSize.height)
            }
            .padding(Constants.insets)
            .foregroundColor(.volume.veryLightGray)
            .overlay {
                RoundedRectangle(cornerRadius: Constants.cornerRadius)
                    .stroke(Color.volume.orange, lineWidth: Constants.strokeWidth)
            }
        }
    }
    
}

// MARK: - Uncomment below if needed

//struct FlyerCategoryMenu_Previews: PreviewProvider {
//    static var previews: some View {
//        FlyerCategoryMenu(categories: ["Dance", "Music", "Academic", "Sports"], selected: .constant("All"))
//    }
//}
