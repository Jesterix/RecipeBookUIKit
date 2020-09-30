//
//  TwoModeTextField.swift
//  RecipeBookUIKit
//
//  Created by Георгий Хайденко on 03.08.2020.
//  Copyright © 2020 George Khaydenko. All rights reserved.
//

import UIKit

final class TwoModeTextField: InsettedTextField {
    var defaultInput: UIView?

    var pickerData: [String] = [] {
        didSet {
            guard let picker = inputView as? UIPickerView else {
                return
            }
            picker.reloadAllComponents()

            pickerSelectCurrentValue()
        }
    }
    
    var additionalPickerData: [String] = []

    private weak var _delegate: UITextFieldDelegate?
    public override var delegate: UITextFieldDelegate? {
        get {
            return self._delegate
        }
        set {
            self._delegate = newValue
        }
    }

    var mode: Mode = .disabled {
        didSet {
            applyStyle()
        }
    }

    init() {
        super.init(frame: .zero)
        applyStyle()
        defaultInput = inputView
        super.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - applyStyle
    private func applyStyle() {
        switch mode {
        case .editable:
            self.alpha = 1
            self.backgroundColor = .milkWhite
            self.borderStyle = .roundedRect
            self.isEnabled = true
            self.tintColor = .darkBrown
            inputView = defaultInput
        case .changeable:
            self.alpha = 1
            self.backgroundColor = .lightlyGray
            self.borderStyle = .roundedRect
            self.isEnabled = true
            self.tintColor = .clear
            setupPicker()
        case .disabled:
            self.alpha = 0.5
            self.backgroundColor = .clear
            self.borderStyle = .none
            self.isEnabled = false
            inputView = defaultInput
        }
        textInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    }

    private func setupPicker() {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        picker.backgroundColor = .milkWhite
        inputView = picker
        pickerSelectCurrentValue()
    }
    
    private func pickerSelectCurrentValue() {
        guard
            let picker = inputView as? UIPickerView,
            let text = text,
            let index = pickerData.firstIndex(of: text)
                ?? additionalPickerData.firstIndex(of: text) else {
                    return
        }
        picker.selectRow(index, inComponent: 0, animated: false)
    }
}

extension TwoModeTextField {
    enum Mode {
        case editable
        case changeable
        case disabled
    }
}

extension TwoModeTextField: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        pickerData.count > 0 ? 1 : 0
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        pickerData.count
    }
}

extension TwoModeTextField: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel(text: pickerData[row])
        label.font = .systemFont(ofSize: 20)
        label.textColor = .darkBrown
        label.textAlignment = .center
        return label
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        text = pickerData[row]
    }
}

extension TwoModeTextField: UITextFieldDelegate {
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
        switch mode {
        case .editable:
            break
        case .changeable:
            textField.selectedTextRange = nil
        default: break
        }

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
