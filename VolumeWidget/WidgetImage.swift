//
//  WidgetImage.swift
//  Volume
//
//  Created by Vin Bui on 11/16/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import SwiftUI

/// Loads images synchronously given a URL
struct WidgetImage: View {

    let url: URL?

    var body: some View {
        Group {
            if let url,
               let imageData = try? Data(contentsOf: url),
               let uiImage = UIImage(data: imageData) {

                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
        }
    }

}
