//
//  AboutUsView.swift
//  Volume
//
//  Created by Cameron Russell on 4/12/21.
//  Copyright © 2021 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct AboutUsView: View {
    private var volume: VolumeInfo {
        let filepath = Bundle.main.url(forResource: "VolumeInfo", withExtension: "json")!
        let data = try! Data(contentsOf: filepath)
        let result = try! JSONDecoder().decode(VolumeInfo.self, from: data)
        return result
    }
    
    var body: some View {
        let keys = volume.subteams.map { $0.key }
        let values = volume.subteams.map { $0.value }
        
        return Group {
            ScrollView(showsIndicators: false) {
                Header("Our Mission")
                Text(volume.messages.ourMission)
                    .font(.helveticaRegular(size: 16))
                    .lineSpacing(2)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding([.bottom, .top])
                
                Header("The Team")
                Text(volume.messages.teamInfo)
                    .font(.helveticaRegular(size: 16))
                    .fixedSize(horizontal: false, vertical: true)
                    .padding([.bottom, .top])


                ForEach(keys.indices) { index in
//                    SubteamMembersView(subteam: keys[index], names: values[index])
                }
            }
            .navigationBarTitle("About Us", displayMode: .inline)
        }
        .padding(20)
        .background(Color.volume.backgroundGray)
    }
}

struct SubteamMembersView: View {
    let subteam: String
    let names: [String]
    
    var body: some View {
        HStack {
            VStack {
                Text("📣")
                    .padding([.leading, .trailing])
                Spacer()
            }
            VStack(alignment: .leading) {
                Text(subteam)
                    .font(.helveticaBold(size: 16))
                Text(names.joined(separator: ", "))
            }
        }
    }
}

struct VolumeInfo: Codable {
    var messages: Messages
    var subteams: [String: [String]]
}

struct Messages: Codable {
    var ourMission: String
    var teamInfo: String
}

struct AboutUsView_Previews: PreviewProvider {
    static var previews: some View {
        AboutUsView()
    }
}
