//
//  ConvertPortionsView.swift
//  RecipeBookUIKit
//
//  Created by Георгий Хайденко on 14.08.2020.
//  Copyright © 2020 George Khaydenko. All rights reserved.
//

import UIKit

final class ConvertPortionsView: UIView {
    enum State {
        case normal, converting
    }

    var state: State = .normal {
        didSet {
            print("state change")
        }
    }

    var textField: UITextField!
    var button: Button!

    init() {
        super.init(frame: .zero)
        layoutContent(in: self)
        applyStyle()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: - layoutContent
    private func layoutContent(in view: UIView) {
        textField = layout(UITextField()) { make in
            make.leading.equalToSuperview()
            make.height.equalTo(30)
            make.width.equalTo(50)
        }

        button = layout(Button.convert) { make in
            make.top.bottom.equalToSuperview()
            make.leading.lessThanOrEqualTo(textField.trailing)
            make.centerX.equalTo(view.trailing).offset(-40)
            make.top.equalTo(textField).offset(-3)
        }
    }

    // MARK: - applyStyle
    private func applyStyle() {
        backgroundColor = .clear

        textField.keyboardType = .decimalPad
        textField.layer.cornerRadius = 10
        textField.font = .systemFont(ofSize: 15)
        textField.textColor = .black
        textField.borderStyle = .roundedRect
        textField.textAlignment = .right
    }
}
