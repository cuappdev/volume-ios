//
//  UIImage+Extension.swift
//  Volume
//
//  Created by Vin Bui on 4/4/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import UIKit

extension UIImage {
    
    /// Returns a `UIColor` representing the average color of this `UIImage, nil if not found
    var averageColor: UIColor? {
        // Convert to CIImage
        guard let inputImage = CIImage(image: self) else { return nil }
        
        // Create an extent vector with the same width and height as our image
        let extentVector = CIVector(
            x: inputImage.extent.origin.x,
            y: inputImage.extent.origin.y,
            z: inputImage.extent.size.width,
            w: inputImage.extent.size.height
        )

        // Create a CIFilter to help us pull the average color
        guard let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) else { return nil }
        guard let outputImage = filter.outputImage else { return nil }

        // Create a bitmap consiting of a (r,g,b,a) value
        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull as Any])
        
        // Render to a 1 by 1 image and pass it to our bit map
        context.render(
            outputImage,
            toBitmap: &bitmap,
            rowBytes: 4,
            bounds: CGRect(x: 0, y: 0, width: 1, height: 1),
            format: .RGBA8, colorSpace: nil
        )

        // Convert bitmap to UIColor
        return UIColor(
            red: CGFloat(bitmap[0]) / 255,
            green: CGFloat(bitmap[1]) / 255,
            blue: CGFloat(bitmap[2]) / 255,
            alpha: CGFloat(bitmap[3]) / 255
        )
    }
    
    /// Returns the average color of this `UIImage`'s starting from the bottom with a height of 60. Gray if null.
    var bottomAverageColor: UIColor? {
        // Crop bottom part of the image
        let cropRect = CGRect(x: 0, y: self.size.height - 60, width: self.size.width, height: 60)
        let cropCGImage = self.cgImage?.cropping(to: cropRect)
        
        if let cropCGImage = cropCGImage {
            // Return the average color
            return UIImage(cgImage: cropCGImage).averageColor
        }
        return .gray
    }
    
}
