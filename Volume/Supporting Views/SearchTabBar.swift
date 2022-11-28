//
//  SearchTabBar.swift
//  Volume
//
//  Created by Vian Nguyen on 11/27/22.
//  Copyright © 2022 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct SearchTabBar: View {
    @Binding var selectedTab: SearchTab
    
    var body: some View {
        HStack(spacing: 0) {
            TabBarItem(label: "Articles", isSelected: .constant(selectedTab == .articles))
                .onTapGesture { onItemTapped(tab: .articles) }
            
            #if DEBUG
            TabBarItem(label: "Magazines", isSelected: .constant(selectedTab == .magazines))
                .onTapGesture { onItemTapped(tab: .magazines) }
            #endif
            
            Spacer()
        }
    }
    
    private func onItemTapped(tab: SearchTab) {
        withAnimation { selectedTab = tab }
    }
}

struct TabBarItem: View {
    let label: String
    @Binding var isSelected: Bool
    
    struct Constants {
        static let labelPadding: CGFloat = 6
        static let labelSize: CGFloat = 18
        static let underlinePadding: CGFloat = 2
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Text(label)
                .font(.newYorkMedium(size: Constants.labelSize))
                .foregroundColor(isSelected ? .volume.orange : .black)
                .frame(alignment: .center)
                .padding(EdgeInsets(top: 0, leading: Constants.labelPadding, bottom:
                        Constants.underlinePadding, trailing: Constants.labelPadding))
            Rectangle()
                .fill(isSelected ? Color.volume.orange : Color.volume.transparentGray)
                .frame(maxWidth: .infinity)
                .frame(height: Constants.underlinePadding)
        }
        .fixedSize()
    }
}


