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
    
    @State private var expanded: Bool = false

    private func determineTruncation(_ geometry: GeometryProxy) {
            // Calculate the bounding box we'd need to render the
            // text given the width from the GeometryReader.
        let total = publication.description.boundingRect(
                with: CGSize(
                    width: geometry.size.width,
                    height: .greatestFiniteMagnitude
                ),
                options: .usesLineFragmentOrigin,
                attributes: [.font: UIFont.systemFont(ofSize: 11)],
                context: nil
            )

            if total.size.height > geometry.size.height {
                self.expanded = true
            }
    }
    
    var body: some View {
        HStack(spacing: 10) {
                // Publication image
            VStack {
                Image(publication.image)
                    .resizable()
                    .clipShape(Circle())
                    .frame(width: 75, height: 75)
                    .offset(y: -5)
                Spacer()
            }
                
            // Name, description, most recent article
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text(publication.name)
                        .font(.custom("Futura-Medium", size: 18))
                        .foregroundColor(.black)
                    Text(publication.description)
                        .font(.custom("Helvetica-Regular", size: 12))
                        .foregroundColor(Color(white: 151/255))
                        //.lineLimit(2)
                        .truncationMode(.tail)
                        .lineSpacing(4)
                        .background(GeometryReader { geometry in
                            Color.clear.onAppear {
                                self.determineTruncation(geometry)
                            }
                        })
                        .lineLimit(self.expanded ? 2 : 1)
                    
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
                    Spacer()
                }
                .frame(width: 265, alignment: .leading)
                
                
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
        .frame(height: expanded ? 100 : 82)
    }
    
}

struct MorePublicationRow_Previews: PreviewProvider {
    static var previews: some View {
        MorePublicationRow(publication: publicationsData[0])
        MorePublicationRow(publication: publicationsData[1])
    }
}
