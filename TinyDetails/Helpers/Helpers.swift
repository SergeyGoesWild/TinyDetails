//
//  Helpers.swift
//  TinyDetails
//
//  Created by Sergey Telnov on 18/04/2025.
//

import Foundation
import UIKit

extension UIImage {
    func cropped(to rect: CGRect, scale: CGFloat = 1.0) -> UIImage? {
        guard let cgImage = self.cgImage else { return nil }
        
        let scaledRect = CGRect(
            x: rect.origin.x * scale,
            y: rect.origin.y * scale,
            width: rect.size.width * scale,
            height: rect.size.height * scale
        )
        
        guard let croppedCGImage = cgImage.cropping(to: scaledRect) else { return nil }
        return UIImage(cgImage: croppedCGImage, scale: self.scale, orientation: self.imageOrientation)
    }
}
