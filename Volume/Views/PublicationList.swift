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
                Header(text: "FOLLOWING")
                    .padding(.top)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 24) {
                        ForEach (publicationsData) { publication in
                            NavigationLink(destination: PublicationDetail(publication: publication)) {
                                FollowingPublicationRow(publication: publication)
                            }
                        }
                    }
                    .padding([.leading, .trailing], 10)
                }
                
                Header(text: "MORE PUBLICATIONS")
                VStack(spacing: 16) {
                    ForEach (publicationsData) { publication in
                        NavigationLink(destination: PublicationDetail(publication: publication)) {
                            MorePublicationRow(publication: publication)
                        }
                    }
                }
                .padding(.bottom)
            }
            .buttonStyle(PlainButtonStyle())
            .navigationTitle("Publications.")
        }
    }
    
}

// TODO: replace w/ Volume specific design
private struct Header : View {
    
    @State var text: String!
    
    var body : some View {
        Text(text)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(EdgeInsets(top: 0, leading: 20.25, bottom: 10, trailing: 0))
    }
    
}

struct PublicationList_Previews: PreviewProvider {
    static var previews: some View {
        PublicationList()
    }
}
