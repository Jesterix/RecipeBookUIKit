//
//  InsettedTextField.swift
//  RecipeBookUIKit
//
//  Created by Георгий on 26.09.2020.
//  Copyright © 2020 George Khaydenko. All rights reserved.
//

import UIKit

class InsettedTextField: GradientTextField {
    // MARK: - TextField Insets
    public var textInsets = UIEdgeInsets.zero {
        didSet {
            setNeedsDisplay()
        }
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInsets)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInsets)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInsets)
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
    }
}
