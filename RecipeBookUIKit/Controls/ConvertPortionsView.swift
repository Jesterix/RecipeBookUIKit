//
//  ConvertPortionsView.swift
//  RecipeBookUIKit
//
//  Created by Георгий Хайденко on 14.08.2020.
//  Copyright © 2020 George Khaydenko. All rights reserved.
//

import UIKit
import SnapKit

final class ConvertPortionsView: UIView {
    var state: CustomControlState = .normal {
        didSet {
            UIView.animate(withDuration: 0.3, animations: {
                self.layoutContentIfNeeded()
            })
        }
    }

    private var label: UILabel!
    private var textField: InsettedTextField!
    private var convertButton: Button!
    private var cancelButton: Button!
    var coefficient: Double = 1 {
        didSet {
            textField.text = String(coefficient)
        }
    }
    private var previousCoefficient: Double = 1
    
    private weak var _delegate: UITextFieldDelegate?
    public var delegate: UITextFieldDelegate? {
        get {
            return self._delegate
        }
        set {
            self._delegate = newValue
        }
    }

    init() {
        super.init(frame: .zero)
        layoutContent(in: self)
        applyStyle()
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: - layoutContent
    private func layoutContent(in view: UIView) {
        cancelButton = layout(Button.cancel) { make in
            make.top.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
        }

        convertButton = layout(Button.converted) { make in
            make.top.bottom.equalToSuperview()
            make.trailing.equalTo(cancelButton.leading).offset(-5)
        }

        textField = layout(InsettedTextField()) { make in
            textFieldConstraints(make: make)
        }

        label = layout(UILabel(text: "Portions.Convert.Text".localized())) { make in
            labelConstraints(make: make)
        }
    }

    private func layoutContentIfNeeded() {
        convertButton.snp.remakeConstraints { make in
            make.top.bottom.equalToSuperview()
            switch state {
            case .normal:
                make.trailing.equalToSuperview()
            case .extended:
                make.trailing.equalTo(cancelButton.leading).offset(-5)
            }
        }

        textField.snp.remakeConstraints { make in
            textFieldConstraints(make: make)
        }

        label.snp.remakeConstraints { make in
            labelConstraints(make: make)
        }

        switch state {
        case .normal:
            cancelButton.alpha = 0
        case .extended:
            cancelButton.alpha = 1
        }
        layoutIfNeeded()
    }

    private func textFieldConstraints(make: ConstraintMaker) {
        make.height.equalTo(30)
        make.width.equalTo(50)
        make.bottom.equalTo(convertButton.bottom)
        make.trailing.lessThanOrEqualTo(convertButton.leading).offset(-5)
    }

    private func labelConstraints(make: ConstraintMaker) {
        make.top.equalToSuperview()
        make.leading.equalTo(textField)
    }
    
    // MARK: - applyStyle
    private func applyStyle() {
        backgroundColor = .clear

        label.font = .systemFont(ofSize: 10)
        label.textColor = .darkBrown

        textField.keyboardType = .decimalPad
        textField.layer.cornerRadius = 5
        textField.font = .systemFont(ofSize: 15)
        textField.textColor = .darkBrown
        textField.textAlignment = .right
        textField.backgroundColor = .warmGray
        textField.textInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        textField.addStandartToolbar()
    }
    
    private func setup() {
        convertButton.addTarget(
            self,
            action: #selector(convertTapped),
            for: .touchUpInside)

        cancelButton.addTarget(
            self,
            action: #selector(cancelTapped),
            for: .touchUpInside)
        
        textField.delegate = self

        layoutContentIfNeeded()
    }
    
    func stateToggle() {
        convertButton.isPrimary.toggle()
        state = convertButton.isPrimary ? .normal : .extended
    }

    @objc func convertTapped() {
        stateToggle()
        switch state {
        case .normal:
            label.text = "Portions.Convert.Text".localized()
            textField.text = String(coefficient)
        case .extended:
            previousCoefficient = coefficient
            label.text = String(coefficient) + "Portions.Label.Text".localized()
            textField.text = ""
        }
    }

    @objc func cancelTapped() {
        coefficient = previousCoefficient
        self._delegate?.textFieldDidEndEditing?(textField)
        label.text = "Portions.Convert.Text".localized()
        textField.text = String(coefficient)
        stateToggle()
    }
}

extension ConvertPortionsView: UITextFieldDelegate {
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        self._delegate?.textField?(
            textField,
            shouldChangeCharactersIn: range,
            replacementString: string) ?? true
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        if #available(iOS 13.0, *) {
            self._delegate?.textFieldDidChangeSelection?(textField)
        }
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return self._delegate?.textFieldShouldBeginEditing?(textField) ?? true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        self._delegate?.textFieldDidBeginEditing?(textField)
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return self._delegate?.textFieldShouldEndEditing?(textField) ?? true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text, let value = Double(text) else {
            return
        }
        coefficient = value
        self._delegate?.textFieldDidEndEditing?(textField)
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return self._delegate?.textFieldShouldClear?(textField) ?? true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return self._delegate?.textFieldShouldReturn?(textField) ?? true
    }
}
