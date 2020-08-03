//
//  ConvertView.swift
//  RecipeBookUIKit
//
//  Created by Георгий Хайденко on 03.08.2020.
//  Copyright © 2020 George Khaydenko. All rights reserved.
//

import UIKit

final class ConvertView: UIView {
    var amountTextField: TwoModeTextField!
    var baseAmountTextField: TwoModeTextField!

    var unitTextField: TwoModeTextField!
    var baseUnitTextField: TwoModeTextField!

    init() {
        super.init(frame: .zero)
        layoutContent(in: self)
        applyStyle()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - layoutContent
    private func layoutContent(in view: UIView) {
        amountTextField = layout(TwoModeTextField()) { make in
            make.leading.top.equalToSuperview()
            make.height.equalTo(30)
            make.width.equalTo(50)
        }

        baseAmountTextField = layout(TwoModeTextField()) { make in
            make.top.equalTo(amountTextField.bottom).offset(5)
            make.leading.width.equalTo(amountTextField)
            make.height.equalTo(amountTextField)
        }

        unitTextField = layout(TwoModeTextField()) { make in
            make.top.equalTo(amountTextField)
            make.leading.equalTo(amountTextField.trailing).offset(5)
            make.trailing.equalToSuperview()
            make.height.equalTo(amountTextField)
        }

        baseUnitTextField = layout(TwoModeTextField()) { make in
            make.top.equalTo(unitTextField.bottom).offset(5)
            make.leading.trailing.equalTo(unitTextField)
            make.height.equalTo(amountTextField)
            make.bottom.equalToSuperview()
        }
//TODO: add padding with TextField extension and remove it in will
//        let fram = CGRect(x: 0, y: 0, width: 5, height: 30)
//        let padding = UIView(frame: fram)
//        baseUnitTextField.leftViewMode = .always
//        baseUnitTextField.leftView = padding
    }

    // MARK: - applyStyle
    private func applyStyle() {
        amountTextField.autocorrectionType = .no
        unitTextField.autocorrectionType = .no

        amountTextField.isEnabled = false
        baseAmountTextField.isEnabled = false
        unitTextField.isEnabled = false
        baseUnitTextField.isEnabled = false

        amountTextField.textAlignment = .right
        baseAmountTextField.textAlignment = .right

        //Demo
        amountTextField.text = "5"
        baseAmountTextField.text = "100"
        unitTextField.text = "spoon"
        baseUnitTextField.text = "gramm"
    }
}

