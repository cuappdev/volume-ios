//
//  URLImageModel.swift
//  Volume
//
//  Created by Vin Bui on 4/4/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import SDWebImage
import SwiftUI

/// Fetches a provided image from URL and stores in a Published property
class URLImageModel: ObservableObject {

    // MARK: - Properties

    @Published var image: UIImage?
    var urlString: String?

    // MARK: - init

    init(urlString: String) {
        self.urlString = urlString
        loadImageFromURL()
    }

    // MARK: - Requests

    private func loadImageFromURL() {
        guard let urlString = urlString, let url = URL(string: urlString) else { return }

        SDWebImageManager.shared.loadImage(
            with: url,
            options: SDWebImageOptions(rawValue: 0),
            progress: nil
        ) { [weak self] (image, _, _, _, _, _) in
            self?.image = image
        }
    }
}
