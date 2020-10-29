//
//  PublicationRow.swift
//  Volume
//
//  Created by Cameron Russell on 10/29/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct PublicationColumn: View {
    
    var publication: Publication!
    
    @State private var buttonTapped = false
        
    var body: some View {
        HStack(spacing: 20) {
            Image(publication.image)
                .resizable()
                .clipShape(Circle())
                .frame(width: 50, height: 50)
                .shadow(color: ._lightGray, radius: 1.5)
                .padding(.bottom)
            VStack(alignment: .leading, spacing: 5) {
                Text(publication.name)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(Color(white: 51/255, opacity: 1))
                Text(publication.description)
                    .font(.system(size: 12))
                    .foregroundColor(Color(white: 151/255, opacity: 1))
                    .lineLimit(2)
                    .truncationMode(.tail)
                HStack {
                    Text("|")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(._lightGray)
                    Text("\"\(publication.recent)\"")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(Color(white: 51/255, opacity: 1))
                        .lineLimit(1)
                        .truncationMode(.tail)
                }
            }
            Button(action: {
                self.buttonTapped.toggle()
                // TODO: Add to list of subscribers
            }) {
                ZStack {
                    Rectangle()
                        .cornerRadius(8.0)
                        .frame(width: 24, height: 24)
                        .foregroundColor(buttonTapped ? ._orange : ._verylightGray)
                    Image(systemName: buttonTapped ? "checkmark" : "plus")
                        .resizable()
                        .frame(width: 10, height: 8)
                        .foregroundColor(buttonTapped ? ._lightGray : ._orange)
                }
            }
        }
        .ignoresSafeArea()
    }
}

struct PublicationColumn_Previews: PreviewProvider {
    static var previews: some View {
        PublicationColumn()
    }
}
