//
//  GradientTextField.swift
//  RecipeBookUIKit
//
//  Created by Георгий on 29.10.2021.
//  Copyright © 2021 George Khaydenko. All rights reserved.
//

import UIKit

class GradientTextField: UITextField {
    public var gradient = CAGradientLayer()

    public func setupGradient(startColor: UIColor, throughColor: UIColor? = nil, throughAnother: UIColor? = nil, endColor: UIColor, direction: GradientDirection) {
        
        gradient.frame = bounds
        gradient.cornerRadius = layer.cornerRadius
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        
        gradient.startPoint = direction.start
        gradient.endPoint = direction.end
        gradient.locations = [0, 0.8]
        if let color = throughColor {
            gradient.colors?.insert(color.cgColor, at: 1)
            gradient.locations?.insert(0.3, at: 1)
        }
        if let color = throughAnother, throughColor != nil {
            gradient.colors?.insert(color.cgColor, at: 2)
            gradient.locations = [0, 0.15, 0.7, 1]
        } else if let color = throughAnother {
            gradient.colors?.insert(color.cgColor, at: 1)
            gradient.locations?.insert(0.3, at: 1)
        }
        
        self.layer.insertSublayer(gradient, at: 0)
    }
}
