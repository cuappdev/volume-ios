//
//  SettingsView.swift
//  Volume
//
//  Created by Cameron Russell on 4/12/21.
//  Copyright © 2021 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct SettingsData {
    static let mappings = ["AboutUs": AboutUsView()]  // Is this a singleton??
    static let pages = [
        Page(destination: .externalLink("https://www.cornellappdev.com/feedback/"), imageName: "flag", info: "Send Feedback"),
        Page(destination: .externalLink("https://www.cornellappdev.com/"), imageName: "link", info: "Visit Our Website"),
        Page(destination: .internalView("AboutUs"), imageName: "info", info: "About Us"),
    ]
}

struct SettingsView: View {
    init() {
        UINavigationBar.appearance().titleTextAttributes = [.font : UIFont(name: "Begum-Medium", size: 20)!]
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            ForEach (0..<SettingsData.pages.count) { index in
                PageRow(page: SettingsData.pages[index])
            }
        }
        .navigationBarTitle(Text("Settings"), displayMode: .inline)
        .background(Color.volume.backgroundGray)
    }
}

struct Page: Identifiable {
    let id = UUID()
    
    let destination: Destination
    let imageName: String
    let info: String
    
    enum Destination {
        case externalLink(String)
        case internalView(String)
    }
}

struct PageRow: View {
    let page: Page
    
    private var row: some View {
        HStack {
            Image(page.imageName)
                .resizable()
                .renderingMode(.template)
                .foregroundColor(Color.volume.lightGray)
                .frame(width: 24, height: 24)
                .padding()
            Text(page.info)
                .font(.helveticaRegular(size: 16))
                .foregroundColor(.black)
            Spacer()
            Image("back-arrow")
                .rotationEffect(Angle(degrees: 180))
                .padding()
        }
        .padding([.leading, .trailing])
    }
    
    var body: some View {
        switch page.destination {
        case .externalLink(let urlString):
            if let url = URL(string: urlString) {
                Link(destination: url) {
                    row
                }
            }
        case .internalView(let view):
            NavigationLink(destination: SettingsData.mappings[view]) {
                row
            }
        }
    }
}

//struct SettingsView_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingsView()
//    }
//}
