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
                .shadow(color: ._verylightGray, radius: 2)
            Text(publication.name)
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.black)
                .lineLimit(2)
        }
        .frame(width: 90)
    }
}

struct PublicationRow_Previews: PreviewProvider {
    static var previews: some View {
        PublicationRow(publication: publicationsData[0])
    }
}
