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
        NavigationView {
            ScrollView(showsIndicators: false) {
                Header("Our Mission")
                
                if let filepath = Bundle.main.path(forResource: "MissionStatement", ofType: "txt") {
                    let contents = try! String(contentsOfFile: filepath)
                    Text(contents)
                }
                            
                Header("The Team")
                Text("Blurb")
                // subteam view
            }
            .background(Color.volume.backgroundGray)
        }
    }
}

struct SubteamMembersView: View {
    let subteam: String
    let names: [String]
    
    var body: some View {
        HStack {
            Text("")
                .padding()
            VStack {
                Text(subteam)
                    .font(.helveticaBold(size: 16))
                Text(names.joined(separator: ", ").dropLast(2)) // what if only one member on subteam
            }
        }
    }
}

struct AboutUsView_Previews: PreviewProvider {
    static var previews: some View {
        AboutUsView()
    }
}
