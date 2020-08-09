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

extension UIButton {
    func enable(_ bool: Bool) {
        isEnabled = bool
        alpha = isEnabled ? 1 : 0.5
    }
}
