//
//  MeasureViewController.swift
//  RecipeBookUIKit
//
//  Created by Georgy Khaydenko on 28.07.2020.
//  Copyright © 2020 George Khaydenko. All rights reserved.
//

import UIKit
import Foundation

final class MeasureViewController: UIViewController {
    private var measureView: MeasureView!
    var measurement: Measurement<Unit>?

    override func loadView() {
        self.measureView = MeasureView()
        self.view = measureView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        measureView.addButton.addTarget(
            self,
            action: #selector(tapAdd),
            for: .touchUpInside)

        measureView.convertButton.addTarget(
            self,
            action: #selector(tapConvert),
            for: .touchUpInside)

        measureView.cancelButton.addTarget(
            self,
            action: #selector(tapCancel),
            for: .touchUpInside)

        measureView.pickerView.delegate = self

        measureView.closeButton.addTarget(
            self,
            action: #selector(close),
            for: .touchUpInside)
    }

    @objc private func tapAdd() {
        print(#function)
        toggleVisibility()
    }

    @objc private func tapCancel() {
        print(#function)
        toggleVisibility()
    }

    @objc private func tapConvert() {
        print(#function)
        measureView.convertButton.isPrimary.toggle()
        measureView.addButton.isEnabled = measureView.convertButton.isPrimary
    }

    private func toggleVisibility() {
        toggleButtonsVisibility()
        toggleTextFieldsVisibility()
    }

    private func toggleButtonsVisibility() {
        measureView.addButton.isPrimary.toggle()
        measureView.cancelButton.isHidden = measureView.addButton.isPrimary
        measureView.convertButton.isEnabled = measureView.addButton.isPrimary
        measureView.closeButton.enable(measureView.addButton.isPrimary)
    }

    private func toggleTextFieldsVisibility() {
        if !measureView.addButton.isPrimary, measureView.convertButton.isPrimary {
            measureView.convertView.amountTextField.mode = .disabled
            measureView.convertView.amountTextField.text = "1"
            measureView.convertView.unitTextField.mode = .editable
            measureView.convertView.baseAmountTextField.mode = .editable
            measureView.convertView.baseUnitTextField.mode = .disabled
        } else {
            measureView.convertView.amountTextField.mode = .editable
            measureView.convertView.unitTextField.mode = .changeable
            measureView.convertView.baseAmountTextField.mode = .disabled
            measureView.convertView.baseUnitTextField.mode = .disabled
        }
    }
    
    @objc func close(){
        self.dismiss(animated: true, completion: nil)
    }
}

extension MeasureViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("row selected in controller: ", row)
    }
}
