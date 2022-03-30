//
//  SettingsView.swift
//  Volume
//
//  Created by Cameron Russell on 4/12/21.
//  Copyright © 2021 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    static let pages = [
        SettingsPage(destination: .externalLink(Secrets.feedbackForm), imageName: "flag", info: "Send Feedback"),
        SettingsPage(destination: .externalLink(Secrets.appdevWebsite), imageName: "link", info: "Visit Our Website"),
        SettingsPage(destination: .internalView(.aboutUs), imageName: "info", info: "About Us"),
    ]
    
    init() {
        UINavigationBar.appearance().titleTextAttributes = [
            .font : UIFont.newYorkMedium(size: 20),
        ]
    }
    
    static func getView(for view: NestedSettingsView) -> some View {
        switch view {
        case .aboutUs:
            return AboutUsView()
        }
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            ForEach(0..<SettingsView.pages.count) { index in
                SettingsPageRow(page: SettingsView.pages[index])
            }
        }
        .navigationBarTitle(Text("Settings"), displayMode: .inline)
        .background(Color.white)
    }
}

enum NestedSettingsView: String {
    case aboutUs
}

//struct SettingsView_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingsView()
//    }
//}
