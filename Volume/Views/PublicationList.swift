//
//  PublicationList.swift
//  Volume
//
//  Created by Cameron Russell on 10/29/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct PublicationList: View {
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach (publicationsData) { publication in
                        NavigationLink(destination: PublicationDetail(publication: publication)) {
                            PublicationRow(publication: publication)
                        }
                    }
                }
            }
            
            VStack(spacing: 10) {
                ForEach (publicationsData) { publication in
                    NavigationLink(destination: PublicationDetail(publication: publication)) {
                        PublicationColumn(publication: publication)
                    }
                }
            }
        }
    }
}

struct PublicationList_Previews: PreviewProvider {
    static var previews: some View {
        PublicationList()
    }
}
