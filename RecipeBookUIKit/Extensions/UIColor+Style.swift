//
//  UIColor+Style.swift
//  RecipeBookUIKit
//
//  Created by Georgy Khaydenko on 23.08.2020.
//  Copyright © 2020 George Khaydenko. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int, alpha: Double = 1.0) {
        self.init(
            red: Double(red) / 255.0,
            green: Double(green) / 255.0,
            blue: Double(blue) / 255.0,
            alpha: alpha)
    }

    convenience public init(red: Double, green: Double, blue: Double, alpha: Double = 1.0) {
        self.init(
            red: CGFloat(red),
            green: CGFloat(green),
            blue: CGFloat(blue),
            alpha: CGFloat(alpha))
    }
    
    //#A0877C
    static let coldBrown: UIColor = #colorLiteral(red: 0.6257153749, green: 0.5304419398, blue: 0.4844925404, alpha: 1) //.init(red: 160, green: 135, blue: 124)
    //#482C2E
    static let darkBrown: UIColor = #colorLiteral(red: 0.2823529412, green: 0.1725490196, blue: 0.1803921569, alpha: 1) //.init(red: 72, green: 44, blue: 46)
    //#FEFDFD
    static let milkWhite: UIColor = #colorLiteral(red: 0.9960784314, green: 0.9921568627, blue: 0.9921568627, alpha: 1) //.init(red: 254, green: 253, blue: 253)
    //#FD333A
    static let brightRed: UIColor = #colorLiteral(red: 0.9921568627, green: 0.2, blue: 0.2274509804, alpha: 1) //.init(red: 253, green: 51, blue: 58)
    //#BCB5BF
    static let warmGray: UIColor = #colorLiteral(red: 0.737254902, green: 0.7098039216, blue: 0.7490196078, alpha: 1) //.init(red: 188, green: 181, blue: 191)
    //#F1CB97
    static let honeyYellow: UIColor = #colorLiteral(red: 0.9450980392, green: 0.7960784314, blue: 0.5921568627, alpha: 1) //.init(red: 241, green: 203, blue: 151)
    //#D79E6E
    static let warmBrown: UIColor = #colorLiteral(red: 0.8431372549, green: 0.6196078431, blue: 0.431372549, alpha: 1) //.init(red: 215, green: 158, blue: 110)
    //#DBD3D1
    static let lightlyGray: UIColor = #colorLiteral(red: 0.8588235294, green: 0.8274509804, blue: 0.8196078431, alpha: 1) //.init(red: 219, green: 211, blue: 209)
}
