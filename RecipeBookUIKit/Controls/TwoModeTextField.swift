//
//  TwoModeTextField.swift
//  RecipeBookUIKit
//
//  Created by Георгий Хайденко on 03.08.2020.
//  Copyright © 2020 George Khaydenko. All rights reserved.
//

import UIKit

final class TwoModeTextField: UITextField {
    init() {
        super.init(frame: .zero)
        applyStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isEnabled: Bool {
        get {
            super.isEnabled
        }
        set {
            super.isEnabled = newValue
            applyStyle()
        }
    }

    private func applyStyle() {
        if isEnabled {
            self.alpha = 1
            self.backgroundColor = .systemBackground
            self.borderStyle = .roundedRect
        } else {
            self.alpha = 0.5
            self.backgroundColor = .clear
            self.borderStyle = .none
        }
    }
}
