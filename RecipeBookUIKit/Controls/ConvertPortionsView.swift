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

    var state: State = .normal

    private var label: UILabel!
    private var textField: UITextField!
    private var button: Button!
    var coefficient: Double = 1 {
        didSet {
            textField.text = String(coefficient)
        }
    }
    
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
        button = layout(Button.convert) { make in
            make.top.bottom.equalToSuperview()
            make.centerX.equalTo(view.trailing).offset(-40)
        }
        
        label = layout(UILabel(text: "Portions.Convert.Text".localized())) { make in
            make.top.leading.equalToSuperview()
        }
        
        textField = layout(UITextField()) { make in
            make.leading.equalToSuperview()
            make.height.equalTo(30)
            make.bottom.equalTo(button.bottom)
            make.trailing.lessThanOrEqualTo(button.leading)
        }
    }
    
    // MARK: - applyStyle
    private func applyStyle() {
        backgroundColor = .clear
        
        label.font = .systemFont(ofSize: 10)
        label.textColor = .black

        textField.keyboardType = .decimalPad
        textField.layer.cornerRadius = 10
        textField.font = .systemFont(ofSize: 15)
        textField.textColor = .black
        textField.borderStyle = .roundedRect
        textField.textAlignment = .right
    }
    
    private func setup() {
        button.addTarget(
            self,
            action: #selector(stateToggle),
            for: .touchUpInside)
        
        textField.delegate = self
    }
    
    @objc func stateToggle() {
        button.isPrimary.toggle()
        state = button.isPrimary ? .normal : .converting
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
