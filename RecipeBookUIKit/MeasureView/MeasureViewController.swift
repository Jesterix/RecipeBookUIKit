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
    var measure: Measure = Measure(value: 0, symbol: "")

    var onClose: ((Measure) -> Void)?

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

        measureView.closeButton.addTarget(
            self,
            action: #selector(close),
            for: .touchUpInside)

        measureView.convertView.measure = measure
        measureView.convertView.onMeasureChange = { [unowned self] measure in
            self.measure = measure
        }
        measureView.convertView.onStateChange = { [unowned self] state in
            self.measureView.pickerView.isUserInteractionEnabled = state != .converting
            switch state {
            case .converting:
                self.measureView.pickerView.alpha = 0.5
            default:
                self.measureView.pickerView.alpha = 1
            }
        }

        setupPickerView()

        hideKeyboardOnTap()
    }

    @objc private func tapAdd() {
        print(#function)
        toggleVisibility()
        if measureView.convertView.state == .editing {
            measureView.convertView.saveCustomMeasure()
        }
        measureView.convertView.state = measureView.addButton.isPrimary ? .normal : .editing
    }

    @objc private func tapCancel() {
        print(#function)
        toggleVisibility()
        measureView.convertView.state = .normal
    }

    @objc private func tapConvert() {
        print(#function)
        measureView.convertButton.isPrimary.toggle()
        measureView.addButton.isEnabled = measureView.convertButton.isPrimary

        measureView.convertView.state = measureView.convertButton.isPrimary ? .normal : .converting
    }

    private func toggleVisibility() {
        toggleButtonsVisibility()
    }

    private func toggleButtonsVisibility() {
        measureView.addButton.isPrimary.toggle()
        measureView.cancelButton.isHidden = measureView.addButton.isPrimary
        measureView.convertButton.isEnabled = measureView.addButton.isPrimary
        measureView.closeButton.enable(measureView.addButton.isPrimary)
    }
    
    @objc func close(){
        onClose?(measure)
        self.dismiss(animated: true, completion: nil)
    }

    private func passPickerData(row: Int) {
        let dimension = Settings.defaultDimensions[row]
        measureView.convertView.setPickerDataForMeasurement(with: dimension)
    }

    private func setupPickerView() {
        measureView.pickerView.delegate = self

        var row = 2
        if measure.symbol.isUnitMass {
            row = 0
        } else if measure.symbol.isUnitVolume {
            row = 1
        }

        passPickerData(row: row)
        measureView.pickerView.selectRow(row: row, inComponent: 0)
    }
}

extension MeasureViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("row selected in controller: ", row)
        passPickerData(row: row)
    }
}
