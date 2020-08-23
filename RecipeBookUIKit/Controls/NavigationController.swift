//
//  NavigationController.swift
//  RecipeBookUIKit
//
//  Created by Georgy Khaydenko on 23.08.2020.
//  Copyright © 2020 George Khaydenko. All rights reserved.
//

import UIKit

final class NavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientBackground()
        setupTitle()
    }
    
    private func setupTitle() {
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.darkBrown]
        navigationBar.titleTextAttributes = textAttributes
        navigationBar.tintColor = .darkBrown
//        navigationBar.barTintColor = .darkBrown
    }
    
    private func setupGradientBackground() {
        let gradient = CAGradientLayer()
        var bounds = navigationBar.bounds
        let height = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        bounds.size.height += height
        gradient.frame = bounds
        
        gradient.colors = [UIColor.warmBrown.cgColor, UIColor.honeyYellow.cgColor, UIColor.honeyYellow.cgColor, UIColor.brightRed.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 1)
        gradient.endPoint = CGPoint(x: 1, y: 0)
        gradient.locations = [0, 0.4, 0.5, 1]

        if let image = getImageFrom(gradientLayer: gradient) {
            navigationBar.setBackgroundImage(image, for: UIBarMetrics.default)
        }
    }

    private func getImageFrom(gradientLayer:CAGradientLayer) -> UIImage? {
        var gradientImage:UIImage?
        UIGraphicsBeginImageContext(gradientLayer.frame.size)
        if let context = UIGraphicsGetCurrentContext() {
            gradientLayer.render(in: context)
            gradientImage = UIGraphicsGetImageFromCurrentImageContext()?.resizableImage(
                withCapInsets: UIEdgeInsets.zero,
                resizingMode: .stretch)
        }
        UIGraphicsEndImageContext()
        return gradientImage
    }
}
