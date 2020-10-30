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
        NavigationView {
            ScrollView(showsIndicators: false) {
                
                Text("FOLLOWING")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 20)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach (publicationsData) { publication in
                            NavigationLink(destination: PublicationDetail(publication: publication)) {
                                PublicationRow(publication: publication)
                            }
                        }
                    }
                    .padding([.bottom, .leading, .trailing])
                }
                
                Text("MORE PUBLICATIONS")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 20)
                VStack(spacing: 12.5) {
                    ForEach (publicationsData) { publication in
                        NavigationLink(destination: PublicationDetail(publication: publication)) {
                            PublicationColumn(publication: publication)
                        }
                    }
                }
                
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.bottom)
            .navigationTitle("Publications.")
        }
    }
}

struct PublicationList_Previews: PreviewProvider {
    static var previews: some View {
        PublicationList()
    }
}
