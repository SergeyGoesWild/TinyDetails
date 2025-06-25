//
//  TouchableImageView.swift
//  TinyDetails
//
//  Created by Sergey Telnov on 22/06/2025.
//
import UIKit

class TouchableImageView: UIImageView {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard let image = self.image else { return false }

        // Convert touch point to image pixel coordinate
        let size = self.bounds.size
        let xRatio = point.x / size.width
        let yRatio = point.y / size.height

        let pixelX = Int(CGFloat(image.size.width) * xRatio)
        let pixelY = Int(CGFloat(image.size.height) * yRatio)

        guard let cgImage = image.cgImage,
              let data = cgImage.dataProvider?.data,
              let bytes = CFDataGetBytePtr(data) else {
            return false
        }

        let bytesPerPixel = 4
        let bytesPerRow = cgImage.bytesPerRow
        let byteIndex = pixelY * bytesPerRow + pixelX * bytesPerPixel

        let alpha = bytes[byteIndex + 3]
        return alpha > 10 // adjust threshold for better accuracy
    }
}
