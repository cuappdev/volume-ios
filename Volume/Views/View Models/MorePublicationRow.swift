//
//  PublicationRow.swift
//  Volume
//
//  Created by Cameron Russell on 10/29/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import SwiftUI

/// `MorePublicationsRow`displays the basis information about a publications the user is not currently following
struct MorePublicationRow: View {
    
    var publication: Publication
    
    @State private var buttonTapped = false
        
    var body: some View {
        HStack(spacing: 10) {
            // The publication's image, name, description, and most recent article
            HStack(spacing: 20) {
                Image(publication.image)
                    .resizable()
                    .clipShape(Circle())
                    .frame(width: 58, height: 58)
                    .shadow(color: Color(white: 0, opacity: 0.1), radius: 5)
                    .padding(.bottom)
                    .offset(y: -5)
                
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(publication.name)
                            .font(.custom("Futura-Medium", size: 18))
                            .foregroundColor(.black)
                        Text(publication.description)
                            .font(.custom("Helvetica-Regular", size: 12))
                            .foregroundColor(Color(white: 151/255))
                            .lineLimit(2)
                            .truncationMode(.tail)
                            .lineSpacing(4)
                        HStack {
                            Text("|")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(._verylightGray)
                            Text("\"\(publication.recent)\"")
                                .font(.custom("Helvetica-Bold", size: 12))
                                .foregroundColor(.black)
                                .lineLimit(1)
                                .truncationMode(.tail)
                        }
                        .padding(.top, 2)
                    }
                    Spacer()
                }
                .frame(width: 265)
            }
                        
            // The button to add the publication to one's following
            VStack {
                Button(action: {
                    self.buttonTapped.toggle()
                    // TODO: Add to list of subscribers
                }) {
                    ZStack {
                        Rectangle()
                            .cornerRadius(8.0)
                            .frame(width: 25, height: 25)
                            .foregroundColor(buttonTapped ? ._orange : ._verylightGray)
                        Image(systemName: buttonTapped ? "checkmark" : "plus")
                            .resizable()
                            .frame(width: 12, height: 12)
                            .foregroundColor(buttonTapped ? ._verylightGray : ._orange)
                            .font(Font.title.weight(.bold))
                    }
                }
                Spacer()
            }
        }
    }
    
}

struct MorePublicationRow_Previews: PreviewProvider {
    static var previews: some View {
        MorePublicationRow(publication: publicationsData[0])
    }
}
