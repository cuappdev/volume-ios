//
//  AboutUsView.swift
//  Volume
//
//  Created by Cameron Russell on 4/12/21.
//  Copyright © 2021 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct AboutUsView: View {
    var body: some View {
        let subteams = Constants.subteams.map { $0.key }
        let subteamMembers = Constants.subteams.map { $0.value }
        
        return Group {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    Header("Our Mission")
                    Text(Constants.missionStatement)
                        .font(.helveticaRegular(size: 16))
                        .lineSpacing(2)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding([.bottom, .top])
                    
                    Header("The Team")
                    Text(Constants.teamInfo)
                        .font(.helveticaRegular(size: 16))
                        .lineSpacing(2)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding([.bottom, .top])

                    ForEach(subteams.indices) { index in
                        HStack {
                            VStack {
                                Text("📣")
                                Spacer()
                            }
                            VStack(alignment: .leading, spacing: 3) {
                                Text(subteams[index])
                                    .font(.helveticaBold(size: 16))
                                    .fixedSize(horizontal: false, vertical: true)
                                Text(subteamMembers[index].joined(separator: ", "))
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                        .padding([.bottom, .trailing], 15)
                    }
                }
            }
            .navigationBarTitle("About Us", displayMode: .inline)
        }
        .padding(20)
        .background(Color.volume.backgroundGray)
    }
}

//struct AboutUsView_Previews: PreviewProvider {
//    static var previews: some View {
//        AboutUsView()
//    }
//}
