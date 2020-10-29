//
//  PublicationRow.swift
//  Volume
//
//  Created by Cameron Russell on 10/29/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct PublicationRow: View {
    
    var publication: Publication
    
    var body: some View {
        VStack(spacing: 10) {
            Image(publication.image)
                .resizable()
                .clipShape(Circle())
                .frame(width: 75, height: 75)
                .overlay(Circle().stroke(Color.black, lineWidth: 0.5))
                .shadow(radius: 5)
            Text(publication.name)
                .lineLimit(2)
                .truncationMode(.tail)
                .frame(width: 90)
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.black)
        }
    }
}

struct PublicationRow_Previews: PreviewProvider {
    static var previews: some View {
        PublicationRow(publication: publicationsData[0])
    }
}
