//
//  CategoryDropdown.swift
//  Volume
//
//  Created by Vin Bui on 10/6/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct CategoryDropdown: View {

    // MARK: - Properties

    var borderColor: Color = Color.volume.orange
    let categories: [String]
    let defaultSelected: String
    var font: Font = .helveticaRegular(size: 12)
    var insets = EdgeInsets(top: 6, leading: 15, bottom: 6, trailing: 11)
    @Binding var selected: String?
    var strokeWidth: CGFloat = 1.5
    var textColor: Color = Color.volume.orange

    // MARK: - Constants

    private struct Constants {
        static let cornerRadius: CGFloat = 4
        static let downArrowSize = CGSize(width: 20, height: 16)
    }

    // MARK: - UI

    var body: some View {
        Menu {
            ForEach(categories, id: \.self) { category in
                Button(category.titleCase()) {
                    selected = category
                }
            }
        } label: {
            dropdownTab
        }
    }

    private var dropdownTab: some View {
        HStack {
            Text(selected?.titleCase() ?? defaultSelected)
                .font(font)
                .fixedSize()

            Spacer()

            Image("down-arrow")
                .resizable()
                .renderingMode(.template)
                .aspectRatio(contentMode: .fit)
                .frame(width: Constants.downArrowSize.width, height: Constants.downArrowSize.height)
        }
        .padding(insets)
        .frame(maxWidth: .infinity)
        .foregroundColor(textColor)
        .overlay {
            RoundedRectangle(cornerRadius: Constants.cornerRadius)
                .stroke(borderColor, lineWidth: strokeWidth)
        }
    }

}

extension CategoryDropdown {

    struct Skeleton: View {
        var body: some View {
            HStack {
                SkeletonView()
                    .fixedSize()

                Image("down-arrow")
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: Constants.downArrowSize.width, height: Constants.downArrowSize.height)
            }
            .padding(EdgeInsets(top: 6, leading: 15, bottom: 6, trailing: 11))
            .foregroundColor(Color.volume.veryLightGray)
            .overlay {
                RoundedRectangle(cornerRadius: Constants.cornerRadius)
                    .stroke(Color.volume.veryLightGray, lineWidth: 1)
            }
        }
    }

}
