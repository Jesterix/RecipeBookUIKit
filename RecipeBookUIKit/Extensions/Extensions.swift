//
//  Extensions.swift
//  RecipeBookUIKit
//
//  Created by Георгий Хайденко on 20.07.2020.
//  Copyright © 2020 George Khaydenko. All rights reserved.
//

import UIKit

extension UILabel {
    convenience init(text: String = "") {
        self.init(frame: .zero)
        self.attributedText = .init(string: text)
    }
}

extension UIViewController {
    internal func hideKeyboardOnTap() {
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(hideKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)

        if let navC = self.navigationController {
            let tapToNavController = UITapGestureRecognizer(
            target: self,
            action: #selector(hideKeyboard))

            tapToNavController.cancelsTouchesInView = false
            navC.navigationBar.addGestureRecognizer(tapToNavController)
        }
    }

    @objc private func hideKeyboard(){
        view.endEditing(true)
    }
}

//MARK: blur with custom intensity
class CustomVisualEffectView: UIVisualEffectView {
    private var animator: UIViewPropertyAnimator!
    /// Create visual effect view with given effect and its intensity
    ///
    /// - Parameters:
    ///   - effect: visual effect, eg UIBlurEffect(style: .dark)
    ///   - intensity: custom intensity from 0.0 (no effect) to 1.0 (full effect) using linear scale
    init(effect: UIVisualEffect, intensity: CGFloat) {
        super.init(effect: nil)
        animator = UIViewPropertyAnimator(duration: 1, curve: .linear)
        { [unowned self] in
            self.effect = effect
        }
        animator.fractionComplete = intensity
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}

extension UIView {
    func layoutBlur(in view: UIView, intensity: CGFloat) {
        let blur = UIBlurEffect(style: .light)
        let blurEffectView = CustomVisualEffectView(
            effect: blur,
            intensity: intensity)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurEffectView)
    }
}

//MARK: - UIButton opacity
extension UIButton {
    func enable(_ bool: Bool) {
        isEnabled = bool
        alpha = isEnabled ? 1 : 0.5
    }
}

//MARK: - Gradient to UIView
extension UIView {
    enum GradientDirection {
        case up, down, left, right, upLeft, upRight, downLeft, downRight
        
        var start: CGPoint {
            switch self {
            case .up:
                return CGPoint(x: 0.5, y: 1)
            case .down:
                return CGPoint(x: 0.5, y: 0)
            case .left:
                return CGPoint(x: 1, y: 0.5)
            case .right:
                return CGPoint(x: 0, y: 0.5)
            case .upLeft:
                return CGPoint(x: 1, y: 1)
            case .upRight:
                return CGPoint(x: 0, y: 1)
            case .downLeft:
                return CGPoint(x: 1, y: 0)
            case .downRight:
                return CGPoint(x: 0, y: 0)
            }
        }
        
        var end: CGPoint {
            switch self {
            case .up:
                return CGPoint(x: 0.5, y: 0)
            case .down:
                return CGPoint(x: 0.5, y: 1)
            case .left:
                return CGPoint(x: 0, y: 0.5)
            case .right:
                return CGPoint(x: 1, y: 0.5)
            case .upLeft:
                return CGPoint(x: 0, y: 0)
            case .upRight:
                return CGPoint(x: 1, y: 0)
            case .downLeft:
                return CGPoint(x: 0, y: 1)
            case .downRight:
                return CGPoint(x: 1, y: 1)
            }
        }
    }
    
    func addGradient(startColor: UIColor, endColor: UIColor, direction: GradientDirection) {
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        
        gradient.startPoint = direction.start
        gradient.endPoint = direction.end
        
        self.layer.insertSublayer(gradient, at: 0)
    }
}
