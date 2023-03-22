//
//  SemesterMenuView.swift
//  Volume
//
//  Created by Hanzheng Li on 11/24/22.
//  Copyright © 2022 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct SemesterMenuView: View {

    @Binding var selection: String?
    var options: [String]

    var body: some View {
        Menu {
            ForEach(options, id: \.self) { option in
                Button(Self.format(semesterString: option)) {
                    selection = option
                }
            }
        } label: {
            HStack {
                Text(Self.format(semesterString: selection ?? options.last ?? Constants.semesterPlaceholder))
                    .font(.helveticaNeueMedium(size: Constants.fontSize))
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
    
}

extension SemesterMenuView {

    private static func format(semesterString: String) -> String {
        if semesterString == "all" { return "All semesters" }
        
        let prefix = semesterString.prefix(2)
        let suffix = semesterString.suffix(2)

        var result = ""

        switch prefix {
        case "fa":
            result = "Fall"
        case "sp":
            result = "Spring"
        default:
            break
        }

        return "\(result) 20\(suffix)"
    }

    private struct Constants {
        static let fontSize: CGFloat = 12
        static let downArrowSize = CGSize(width: 20, height: 16)
        static let insets = EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 12)
        static let cornerRadius: CGFloat = 5
        static let strokeWidth: CGFloat = 1.5
        static let semesterPlaceholder = "Current Semester"
    }

    public struct Skeleton: View {
        var body: some View {
            HStack {
                SkeletonView()
                    .font(.helveticaNeueMedium(size: Constants.fontSize))
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
