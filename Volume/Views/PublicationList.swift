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
                    .padding(EdgeInsets(top: 10, leading: 20.25, bottom: 0, trailing: 0))
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 24) {
                        ForEach (publicationsData) { publication in
                            NavigationLink(destination: PublicationDetail(publication: publication)) {
                                FollowingPublicationRow(publication: publication)
                            }
                        }
                    }
                    .padding([.leading, .bottom, .trailing], 10)
                }
                
                Text("MORE PUBLICATIONS")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(EdgeInsets(top: 0, leading: 20.25, bottom: 10, trailing: 0))
                VStack(spacing: 24) {
                    ForEach (publicationsData) { publication in
                        NavigationLink(destination: PublicationDetail(publication: publication)) {
                            MorePublicationRow(publication: publication)
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
