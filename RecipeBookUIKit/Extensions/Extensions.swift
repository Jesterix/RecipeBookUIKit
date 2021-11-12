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
        tap.name = "HideKeyboard"
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
    
    //TODO: remove recognizers on dismiss
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
    func layoutBlur(intensity: CGFloat) {
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
        case measureView, addField
        
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
            case .downLeft, .measureView:
                return CGPoint(x: 1, y: 0)
            case .downRight, .addField:
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
            case .right, .addField:
                return CGPoint(x: 1, y: 0.5)
            case .upLeft:
                return CGPoint(x: 0, y: 0)
            case .upRight:
                return CGPoint(x: 1, y: 0)
            case .downLeft:
                return CGPoint(x: 0, y: 1)
            case .downRight:
                return CGPoint(x: 1, y: 1)
            case .measureView:
                return CGPoint(x: 0.75, y: 0.75)
            }
        }
    }
    
    func addGradient(startColor: UIColor, throughColor: UIColor? = nil, throughAnother: UIColor? = nil, endColor: UIColor, direction: GradientDirection) -> CAGradientLayer {
        let gradient = CAGradientLayer()
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
        return gradient
    }
}

//MARK: - String exts
extension String {
    func firstWord() -> String {
        return String(self.split(separator: " ", omittingEmptySubsequences: true)[0])
    }

    func dropFirstWord() -> String {
        return String(self.split(separator: " ", omittingEmptySubsequences: true)
            .dropFirst()
            .joined(separator: " "))
    }
    
    public func height(
        withConstrainedWidth width: CGFloat,
        font: UIFont
    ) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

        return ceil(boundingBox.height)
    }

    public func width(
        withConstrainedHeight height: CGFloat,
        font: UIFont
    ) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

        return ceil(boundingBox.width)
    }
}

//MARK: - UIImage resize
extension UIImage {
    func resizeToFit(size: CGSize) -> UIImage? {
        if self.size.width <= size.width && self.size.height <= size.height {
            return self
        }
        
        let widthScaleFactor = self.size.width / size.width
        let heightScaleFactor = self.size.height / size.height
        
        var newSize: CGSize!
        if widthScaleFactor > heightScaleFactor {
            newSize = CGSize(
                width: self.size.width / widthScaleFactor,
                height: self.size.height / widthScaleFactor)
        } else {
            newSize = CGSize(
                width: self.size.width / heightScaleFactor,
                height: self.size.height / heightScaleFactor)
        }
        
        return resizeWithUIKit(to: newSize)
    }
    
    private func resizeWithUIKit(to newSize: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(newSize, true, 1.0)
        self.draw(in: CGRect(origin: .zero, size: newSize))
        defer { UIGraphicsEndImageContext() }
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    //rotating before saving
    func rotateUpwards() -> UIImage? {
        if (self.imageOrientation == UIImage.Orientation.up ) {
            return self
        }
        UIGraphicsBeginImageContext(self.size)
        self.draw(in: CGRect(origin: CGPoint.zero, size: self.size))
        let copy = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return copy
    }
}

//MARK: - UITextView image inserting
extension UITextView {
    func insertImage(
        _ image: UIImage,
        widthScale: CGFloat = 1,
        heightScale: CGFloat = 1
    ) {
        let textAttachment = NSTextAttachment()
        
        let sizeToFit = CGSize(
            width: frame.size.width * widthScale - 10,
            height: frame.size.width * widthScale)
        
        textAttachment.image = image.resizeToFit(size: sizeToFit)
        
        let attrStringWithImage = NSAttributedString(attachment: textAttachment)
        
        if let selectedRange = self.selectedTextRange {
            let cursorPosition = self.offset(
                from: self.beginningOfDocument,
                to: selectedRange.start)
            textStorage.insert(attrStringWithImage, at: cursorPosition)
        }
        selectedRange = NSRange(location: selectedRange.location + 1, length: 0)
    }
}

//MARK:- UIView global coordinates
extension UIView {
    var globalPoint: CGPoint? {
        return self.superview?.convert(self.frame.origin, to: nil)
    }
    
    var globalFrame: CGRect? {
        return self.superview?.convert(self.frame, to: nil)
    }
}

//MARK:- Double removeZerosFromEnd
extension Double {
    func removeZerosFromEnd() -> String {
        let formatter = NumberFormatter()
        let number = NSNumber(value: self)
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 16 //maximum digits in Double after dot (maximum precision)
        return String(formatter.string(from: number) ?? "")
    }
}
