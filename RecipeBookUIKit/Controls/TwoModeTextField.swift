//
//  TwoModeTextField.swift
//  RecipeBookUIKit
//
//  Created by Георгий Хайденко on 03.08.2020.
//  Copyright © 2020 George Khaydenko. All rights reserved.
//

import UIKit

final class TwoModeTextField: UITextField {
    var mode: Mode = .disabled {
        didSet {
            applyStyle()
        }
    }

    init() {
        super.init(frame: .zero)
        applyStyle()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func applyStyle() {
        switch mode {
        case .editable:
            self.alpha = 1
            self.backgroundColor = .systemBackground
            self.borderStyle = .roundedRect
            self.isEnabled = true
        case .changeable:
            self.alpha = 1
            self.backgroundColor = .systemGray3
            self.borderStyle = .roundedRect
            self.isEnabled = true
        case .disabled:
            self.alpha = 0.5
            self.backgroundColor = .clear
            self.borderStyle = .none
            self.isEnabled = false
        }
    }
}

extension TwoModeTextField {
    enum Mode {
        case editable
        case changeable
        case disabled
    }
}
