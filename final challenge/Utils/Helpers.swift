//
//  utils.swift
//  spiki
//
//  Created by Adi Sukarno Rachman on 01/02/19.
//  Copyright © 2019 Adi Sukarno Rachman. All rights reserved.
//

import Foundation
import UIKit

extension Date {
    public func toString(format: String = "dd-MM-yy") -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}

extension String {
    public func toDate(withFormat format: String = "dd/MM/yyyy") -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        guard let date = dateFormatter.date(from: self) else {
            preconditionFailure("Take a look to your format")
        }
        return date
    }
}

extension UIView {
    func setAnchorPoint(anchorPoint: CGPoint) {
        
        var newPoint = CGPoint(x: self.bounds.size.width * anchorPoint.x, y: self.bounds.size.height * anchorPoint.y)
        var oldPoint = CGPoint(x: self.bounds.size.width * self.layer.anchorPoint.x, y: self.bounds.size.height * self.layer.anchorPoint.y)
        
        newPoint = newPoint.applying(self.transform)
        oldPoint = oldPoint.applying(self.transform)
        
        var position : CGPoint = self.layer.position
        
        position.x -= oldPoint.x
        position.x += newPoint.x;
        
        position.y -= oldPoint.y;
        position.y += newPoint.y;
        
        self.layer.position = position;
        self.layer.anchorPoint = anchorPoint;
    }
    
    func shapedBackground() {
        self.backgroundColor = UIColor.orangeS
    }
    
    public func addRoundedBorder(ofWidth width: CGFloat, radius: CGFloat,  color: CGColor) {
        self.layer.cornerRadius = radius
        self.layer.borderWidth = width
        self.layer.borderColor = color
        self.clipsToBounds = true
    }
    
    /// Helper to get pre transform frame
    var originalFrame: CGRect {
        let currentTransform = transform
        transform = .identity
        let originalFrame = frame
        transform = currentTransform
        return originalFrame
    }
    
    /// Helper to get point offset from center
    func centerOffset(_ point: CGPoint) -> CGPoint {
        return CGPoint(x: point.x - center.x, y: point.y - center.y)
    }
    
    /// Helper to get point back relative to center
    func pointRelativeToCenter(_ point: CGPoint) -> CGPoint {
        return CGPoint(x: point.x + center.x, y: point.y + center.y)
    }
    
    /// Helper to get point relative to transformed coords
    func newPointInView(_ point: CGPoint) -> CGPoint {
        // get offset from center
        let offset = centerOffset(point)
        // get transformed point
        let transformedPoint = offset.applying(transform)
        // make relative to center
        return pointRelativeToCenter(transformedPoint)
    }
    
    var newTopLeft: CGPoint {
        return newPointInView(originalFrame.origin)
    }
    
    var newTopRight: CGPoint {
        var point = originalFrame.origin
        point.x += originalFrame.width
        return newPointInView(point)
    }
    
    var newBottomLeft: CGPoint {
        var point = originalFrame.origin
        point.y += originalFrame.height
        return newPointInView(point)
    }
    
    var newBottomRight: CGPoint {
        var point = originalFrame.origin
        point.x += originalFrame.width
        point.y += originalFrame.height
        return newPointInView(point)
    }

}


extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(fromHex: Int) {
        self.init(
            red: (fromHex >> 16) & 0xFF,
            green: (fromHex >> 8) & 0xFF,
            blue: fromHex & 0xFF
        )
    }
    
    //Colors below are the used color palette
    @nonobjc class var orangeS: UIColor {
        return UIColor(displayP3Red: 241.0/255.0, green: 153.0/255.0, blue: 56.0/255.0, alpha: 1.0)
    }
    
    
    @nonobjc class var darkBlue: UIColor {
        return UIColor(red: 27.0 / 255.0, green: 36.0 / 255.0, blue: 81.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var reddishOrange: UIColor {
        return UIColor(red: 238.0 / 255.0, green: 97.0 / 255.0, blue: 43.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var paleOrange: UIColor {
        return UIColor(red: 247.0 / 255.0, green: 154.0 / 255.0, blue: 104.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var fadedBlue: UIColor {
        return UIColor(red: 84.0 / 255.0, green: 141.0 / 255.0, blue: 202.0 / 255.0, alpha: 1.0)
    }
}


extension BinaryInteger {
    var degreesToRadians: CGFloat { return CGFloat(Int(self)) * .pi / 180 }
}

extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}
