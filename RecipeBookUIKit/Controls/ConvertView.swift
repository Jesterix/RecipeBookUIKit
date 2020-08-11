//
//  ConvertView.swift
//  RecipeBookUIKit
//
//  Created by Георгий Хайденко on 03.08.2020.
//  Copyright © 2020 George Khaydenko. All rights reserved.
//

import UIKit

final class ConvertView: UIView {
    enum State {
        case normal, editing, converting
    }

    var state: State = .normal {
        didSet {
            toggleTextFieldsVisibility()
        }
    }

    private var measureSet = false
    var measure: Measure? {
        didSet {
            if !measureSet {
                setupText()
                measureSet.toggle()
            }
        }
    }

    private var amountTextField: TwoModeTextField!
    private var unitTextField: TwoModeTextField!

    private var baseUnitLabel: UILabel!

    private var baseAmountTextField: TwoModeTextField!
    private var baseUnitTextField: TwoModeTextField!

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

        unitTextField = layout(TwoModeTextField()) { make in
            make.top.equalTo(amountTextField)
            make.leading.equalTo(amountTextField.trailing).offset(5)
            make.trailing.equalToSuperview()
            make.height.equalTo(amountTextField)
        }

        baseUnitLabel = layout(UILabel(text: "base units:")) { make in
            make.top.equalTo(amountTextField.bottom).offset(10)
            make.leading.equalTo(amountTextField).offset(5)
        }

        baseAmountTextField = layout(TwoModeTextField()) { make in
            make.top.equalTo(baseUnitLabel.bottom)
            make.leading.width.equalTo(amountTextField)
            make.height.equalTo(amountTextField)
        }

        baseUnitTextField = layout(TwoModeTextField()) { make in
            make.top.equalTo(baseAmountTextField)
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
        amountTextField.textAlignment = .right
        amountTextField.mode = .editable

        unitTextField.autocorrectionType = .no
        unitTextField.mode = .changeable

        baseUnitLabel.font = .systemFont(ofSize: 10)

        baseAmountTextField.autocorrectionType = .no
        baseAmountTextField.textAlignment = .right
        baseAmountTextField.mode = .disabled

        baseUnitTextField.autocorrectionType = .no
        baseUnitTextField.mode = .disabled

        //Demo
        amountTextField.text = "5"
        baseAmountTextField.text = "100"
        unitTextField.text = "spoon"
        baseUnitTextField.text = "gramm"
    }

//    MARK: - methods

    private func toggleTextFieldsVisibility() {
        switch state {
        case .normal, .converting:
            amountTextField.mode = .editable
            unitTextField.mode = .changeable
            baseAmountTextField.mode = .disabled
            baseUnitTextField.mode = .disabled
        case .editing:
            amountTextField.mode = .disabled
            amountTextField.text = "1"
            unitTextField.mode = .editable
            baseAmountTextField.mode = .editable
            baseUnitTextField.mode = .disabled
        }
    }

    private func setupText() {
        guard let measurement = measure else {
            return
        }
        amountTextField.text = "\(measurement.value)"
        unitTextField.text = measurement.symbol
        baseAmountTextField.text = String(measurement.coefficient)
        baseUnitTextField.text = measurement.baseUnit.symbol
    }
}

