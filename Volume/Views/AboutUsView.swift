//
//  AboutUsView.swift
//  Volume
//
//  Created by Cameron Russell on 4/12/21.
//  Copyright © 2021 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct AboutUsView: View {
    private let subteams = Constants.subteams.keys.sorted { a, b in
        a.uppercased() < b.uppercased()
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
                Header("Our Mission")
                Text(Constants.missionStatement)
                    .font(.helveticaRegular(size: 16))
                    .lineSpacing(2)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding([.bottom, .top])
                
                Header("The Team")
                    .padding(.top)
                Text(Constants.teamInfo)
                    .font(.helveticaRegular(size: 16))
                    .lineSpacing(2)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding([.bottom, .top])

                ForEach(subteams, id: \.self) { subteam in
                    HStack {
                        VStack {
                            Text("📣")
                            Spacer()
                        }
                        VStack(alignment: .leading, spacing: 3) {
                            Text(subteam)
                                .font(.helveticaNeueMedium(size: 16))
                                .fixedSize(horizontal: false, vertical: true)
                            Text(Constants.subteams[subteam]!.joined(separator: ", "))
                                .font(.helveticaRegular(size: 16))
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    .padding([.bottom, .trailing], 15)
                }
            }
        }
        .navigationBarTitle("About Us", displayMode: .inline)
        .padding(20)
        .background(Color.white)
    }
}

//struct AboutUsView_Previews: PreviewProvider {
//    static var previews: some View {
//        AboutUsView()
//    }
//}
