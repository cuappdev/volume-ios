//
//  SettingsView.swift
//  Volume
//
//  Created by Cameron Russell on 4/12/21.
//  Copyright © 2021 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    private var mappings = ["AboutUs": AboutUsView()]
    private let pages = [
        Page(destination: .externalLink("https://www.cornellappdev.com/feedback/"), imageName: "flag", info: "Send Feedback"),
        Page(destination: .externalLink("https://www.cornellappdev.com/"), imageName: "link", info: "Visit Our Website"),
        Page(destination: .internalView("AboutUs"), imageName: "info", info: "About Us"),
    ]
    
    init() {
        UINavigationBar.appearance().titleTextAttributes = [.font : UIFont(name: "Begum-Medium", size: 20)!]
    }
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                ForEach (0..<pages.count) { index in
                    PageRow(page: pages[index])
                }
            }
            .background(Color.volume.backgroundGray)
            .navigationBarTitle(Text("Settings"), displayMode: .inline)
        }
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
    
    var body: some View {
        HStack {
            Image(page.imageName)
                .resizable()
                .renderingMode(.template)
                .foregroundColor(Color.volume.lightGray)
                .frame(width: 24, height: 24)
                .padding()
            Text(page.info)
                .font(.helveticaRegular(size: 16))
            Spacer()
            Image("back-arrow")
                .rotationEffect(Angle(degrees: 180))
                .padding()
        }
    }
}

//struct SettingsView_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingsView()
//    }
//}
