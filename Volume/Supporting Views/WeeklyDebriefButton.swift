//
//  WeeklyDebriefButton.swift
//  Volume
//
//  Created by Hanzheng Li on 10/29/22.
//  Copyright © 2022 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct WeeklyDebriefButton: View {
    @Binding var buttonPressed: Bool

    var body: some View {
        Button {
            buttonPressed = true
        } label: {
            ZStack(alignment: .leading) {
                Image.volume.weeklyDebriefCurves
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fill)

                HStack(alignment: .top) {
                    Text(Constants.titleText)
                        .font(.newYorkRegular(size: Constants.titleTextFontSize))
                        .foregroundColor(.volume.orange)
                        .padding(.leading)
                        .multilineTextAlignment(.leading)

                    Spacer()

                    Image.volume.rightArrow
                        .padding(.trailing)
                }
            }
        }
        .frame(height: Constants.height)
        .shadow(color: .volume.shadowBlack, radius: Constants.shadowRadius, x: 0, y: 0)
    }
}

extension WeeklyDebriefButton {
    private struct Constants {
        static let titleText: String = "Your\nWeekly\nDebrief"
        static let titleTextFontSize: CGFloat = 18
        static let height: CGFloat = 92
        static let shadowRadius: CGFloat = 5
    }
}
