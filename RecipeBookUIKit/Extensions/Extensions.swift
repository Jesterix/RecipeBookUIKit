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

//make button label under image
extension UIButton {
    func layoutVertically(padding: CGFloat = 6.0) {
        guard
            let imageViewSize = self.imageView?.frame.size,
            let titleLabelSize = self.titleLabel?.frame.size else {
            return
        }
        
        let totalHeight = imageViewSize.height + titleLabelSize.height + padding
        
        self.imageEdgeInsets = UIEdgeInsets(
            top: -(totalHeight - imageViewSize.height),
            left: 0.0,
            bottom: 0.0,
            right: -titleLabelSize.width
        )
        
        self.titleEdgeInsets = UIEdgeInsets(
            top: 0.0,
            left: -imageViewSize.width,
            bottom: -(totalHeight - titleLabelSize.height),
            right: 0.0
        )
        
        self.contentEdgeInsets = UIEdgeInsets(
            top: 0.0,
            left: 0.0,
            bottom: titleLabelSize.height,
            right: 0.0
        )
    }
}

