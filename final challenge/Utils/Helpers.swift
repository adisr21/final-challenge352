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
    func shapedBackground() {
        self.backgroundColor = UIColor.orangeS
    }
    
    public func addRoundedBorder(ofWidth width: CGFloat, radius: CGFloat,  color: CGColor) {
        self.layer.cornerRadius = radius
        self.layer.borderWidth = width
        self.layer.borderColor = color
        self.clipsToBounds = true
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
