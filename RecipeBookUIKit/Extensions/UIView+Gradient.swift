//
//  UIView+Gradient.swift
//  RecipeBookUIKit
//
//  Created by Георгий on 28.06.2021.
//  Copyright © 2021 George Khaydenko. All rights reserved.
//

import UIKit

extension UIView {
    func setupGradientBackground() {
        self.layer.sublayers?.removeAll()
        backgroundColor = .clear
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.cornerRadius = layer.cornerRadius
        
        gradient.colors = [UIColor.brightRed.cgColor,
                           UIColor.honeyYellow.withAlphaComponent(0.8).cgColor,
                           UIColor.honeyYellow.withAlphaComponent(0.4).cgColor,
                           UIColor.honeyYellow.withAlphaComponent(0.2).cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradient.locations = [0, 0.15, 0.7, 1]

        self.layer.insertSublayer(gradient, at: 0)
    }
}

class GradientView: UIView {
    public enum ColorScheme {
        case wideHeader
        case addField
    }
    
    public var colorScheme: ColorScheme = .wideHeader {
        didSet {
            switch colorScheme {
            case .wideHeader:
                setupHeaderGradient()
            case .addField:
                setupAddFieldGradient()
            }
        }
    }
    
    override open class var layerClass: AnyClass {
       return CAGradientLayer.classForCoder()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    private func setupHeaderGradient() {
        let gradientLayer = layer as! CAGradientLayer
        gradientLayer.colors = [UIColor.warmBrown.cgColor,
//                                UIColor.honeyYellow.cgColor,
                                UIColor.honeyYellow.cgColor,
                                UIColor.white.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.locations = [0, 0.3, 0.7]
    }
    
    private func setupAddFieldGradient() {
        let gradientLayer = layer as! CAGradientLayer
        gradientLayer.colors = [UIColor.brightRed.cgColor,
                           UIColor.honeyYellow.cgColor,
                           UIColor.white.cgColor,
                           UIColor.white.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.locations = [0, 0.2, 0.5, 1]
    }
}
