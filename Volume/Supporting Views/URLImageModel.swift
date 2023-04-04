//
//  URLImageModel.swift
//  Volume
//
//  Created by Vin Bui on 4/4/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

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
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: getImageFromResponse(data:response:error:))
        task.resume()
    }
    
    func getImageFromResponse(data: Data?, response: URLResponse?, error: Error?) {
        guard error == nil else {
            print("Error getting image: \(error!.localizedDescription)")
            return
        }
        
        guard let data = data else {
            print("Unable to retrieve image data")
            return
        }
        
        DispatchQueue.main.async {
            guard let loadedImage = UIImage(data: data) else { return }
            self.image = loadedImage
        }
    }
    
}
