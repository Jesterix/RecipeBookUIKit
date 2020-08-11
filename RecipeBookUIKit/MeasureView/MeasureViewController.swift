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
    var measurement: Measure?

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

        setupPickerView()

        measureView.closeButton.addTarget(
            self,
            action: #selector(close),
            for: .touchUpInside)

        measureView.convertView.measure = measurement
        measureView.convertView.onMeasureChange = { [unowned self] measure in
            self.measurement = measure
        }
        hideKeyboardOnTap()
    }

    @objc private func tapAdd() {
        print(#function)
        toggleVisibility()
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
        guard let measure = measurement else {
            return
        }
        onClose?(measure)
        self.dismiss(animated: true, completion: nil)
    }

    private func passPickerData(row: Int) {
        let dimension = Settings.defaultDimensions[row]
        measureView.convertView.setPickerDataForMeasurement(with: dimension)
    }

    private func setupPickerView() {
        measureView.pickerView.delegate = self

        var row = 0
        switch measurement?.type {
        case .mass:
            row = 0
        case .volume:
            row = 1
        case .undefined:
            row = 2
        default:
            return
        }
        measureView.pickerView.selectRow(row: row, inComponent: 0)
        passPickerData(row: row)
    }
}

extension MeasureViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("row selected in controller: ", row)
        passPickerData(row: row)
    }
}
