//
//  TwoModeTextField.swift
//  RecipeBookUIKit
//
//  Created by Георгий Хайденко on 03.08.2020.
//  Copyright © 2020 George Khaydenko. All rights reserved.
//

import UIKit

final class TwoModeTextField: UITextField {
    var defaultInput: UIView?

    var pickerData: [String] = [] {
        didSet {
            guard let picker = inputView as? UIPickerView else {
                return
            }
            picker.reloadAllComponents()
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
            inputView = defaultInput
        case .changeable:
            self.alpha = 1
            self.backgroundColor = .systemGray3
            self.borderStyle = .roundedRect
            self.isEnabled = true
            setupPicker()
        case .disabled:
            self.alpha = 0.5
            self.backgroundColor = .clear
            self.borderStyle = .none
            self.isEnabled = false
            inputView = defaultInput
        }
    }

    private func setupPicker() {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        inputView = picker
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
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        pickerData[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        text = pickerData[row]
    }
}
