//
//  Extensions.swift
//  WhiteBoard X
//
//  Created by Turner Eison on 6/10/21.
//

import Foundation
import UIKit
import SwiftUI

extension CGSize: Comparable {
    static let veryLarge = CGSize(width: 100000, height: 100000)
    
    public static func < (lhs: CGSize, rhs: CGSize) -> Bool {
        let lhsArea = lhs.width * lhs.height
        let rhsArea = rhs.width * rhs.height
        
        return lhsArea < rhsArea
    }
    
    static func +(lhs: CGSize, rhs: CGFloat) -> CGSize {
        CGSize(width: lhs.width + rhs, height: lhs.height + rhs)
    }
    
    static func /(lhs: CGSize, rhs: CGFloat) -> CGSize {
        CGSize(width: lhs.width / rhs, height: lhs.height / rhs)
    }
    
    var center: CGPoint {
        CGPoint(x: self.width / 2, y: self.height / 2)
    }
}

extension UIImage {
    
    func withBackground(color: UIColor) -> UIImage? {
        var image: UIImage?
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let imageRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(color.cgColor)
            context.fill(imageRect)
            draw(in: imageRect, blendMode: .normal, alpha: 1.0)
            image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image
        }
        return nil
    }
    
    func withAlpha(_ value:CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}

extension Color {
    
    /// Check if the color is light or dark, as defined by the injected lightness threshold.
    func isLight(threshold: Float = 0.5) -> Bool {
        guard let originalCGColor = self.cgColor else { return false }
        
        // Now we need to convert it to the RGB colorspace. UIColor.white / UIColor.black are greyscale and not RGB.
        // If you don't do this then you will crash when accessing components index 2 below when evaluating greyscale colors.
        let RGBCGColor = originalCGColor.converted(to: CGColorSpaceCreateDeviceRGB(), intent: .defaultIntent, options: nil)
        guard let components = RGBCGColor?.components else {
            return false
        }
        guard components.count >= 3 else {
            return false
        }
        
        let brightness = Float(((components[0] * 299) + (components[1] * 587) + (components[2] * 114)) / 1000)
        return (brightness > threshold)
    }
}
