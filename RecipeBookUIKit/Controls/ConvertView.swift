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
            setupText()
        }
    }

    var measure: Measure? {
        didSet {
            if oldValue == nil {
                setupText()
                convertBaseUnit()
            }
            toggleTextFieldsVisibility()
            guard let measure = measure else {
                return
            }
            onMeasureChange?(measure)
        }
    }

    var onMeasureChange: ((Measure) -> Void)?

    private var amountTextField: TwoModeTextField!
    private var unitTextField: TwoModeTextField!

    private var baseUnitLabel: UILabel!

    private var baseAmountTextField: TwoModeTextField!
    private var baseUnitTextField: TwoModeTextField!
    
    private let dataManager = DataBaseManager()

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
            make.width.equalTo(100)
        }
        amountTextField.delegate = self

        unitTextField = layout(TwoModeTextField()) { make in
            make.top.equalTo(amountTextField)
            make.leading.equalTo(amountTextField.trailing).offset(5)
            make.trailing.equalToSuperview()
            make.height.equalTo(amountTextField)
        }
        unitTextField.delegate = self

        baseUnitLabel = layout(UILabel(text: "base units:")) { make in
            make.top.equalTo(amountTextField.bottom).offset(10)
            make.leading.equalTo(amountTextField).offset(5)
        }

        baseAmountTextField = layout(TwoModeTextField()) { make in
            make.top.equalTo(baseUnitLabel.bottom)
            make.leading.width.equalTo(amountTextField)
            make.height.equalTo(amountTextField)
        }
        baseAmountTextField.delegate = self

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
        amountTextField.keyboardType = .decimalPad

        unitTextField.autocorrectionType = .no
        unitTextField.mode = .changeable

        baseUnitLabel.font = .systemFont(ofSize: 10)

        baseAmountTextField.autocorrectionType = .no
        baseAmountTextField.textAlignment = .right
        baseAmountTextField.mode = .disabled
        baseAmountTextField.keyboardType = .decimalPad

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
        guard let measurement = measure else {
            return
        }
        switch state {
        case .normal, .converting:
            amountTextField.mode = .editable
            unitTextField.mode = .changeable
            baseAmountTextField.mode = .disabled
            baseUnitTextField.mode = .disabled
        case .editing:
            amountTextField.mode = .disabled
            unitTextField.mode = .editable
            baseUnitTextField.mode = .disabled
            if measurement.symbol.isUnitMass || measurement.symbol.isUnitVolume {
                baseAmountTextField.mode = .disabled
            } else {
                baseAmountTextField.mode = .editable
            }
        }
    }

    private func setupText() {
        guard let measurement = measure else {
            return
        }
        
        switch state {
        case .normal, .converting:
            amountTextField.text = "\(measurement.value)"
        case .editing:
            measure?.value = 1
            guard let newMeasure = measure else {
                return
            }
            amountTextField.text = "\(newMeasure.value)"
        }
        
        unitTextField.text = measurement.symbol
        baseAmountTextField.text = convertedBaseUnit()
        baseUnitTextField.text = measurement.baseUnitSymbol
    }

    //MARK: - input of new dimension
    func setPickerDataForMeasurement(with dimension: DimensionType) {
        switch dimension {
        case .mass:
            unitTextField.pickerData = DimensionType.allMassCases
        case .volume:
            unitTextField.pickerData = DimensionType.allVolumeCases
        case .custom:
            unitTextField.pickerData = DataStorage.shared.customMeasures.map {
                $0.title
            }
        }
        if state == .editing {
            baseUnitTextField.text = dimension.baseSymbol
        }
    }

    private func convertedAmount() -> String {
        guard let measure = measure, let text = unitTextField.text else {
            print("measure or text == nil")
            return ""
        }

        let type: DimensionType = .init(with: text)
        guard let converted = Converter.convert(measure: measure, to: type) else {
            print("converter failed")
            return ""
        }

        return converted
    }

    private func convertAmount() {
        amountTextField.text = convertedAmount()
        measure?.value = Double(convertedAmount()) ?? 0
    }

    private func convertedBaseUnit() -> String {
        guard let measure = measure else {
            return ""
        }
        guard let converted = Converter.convertToBaseUnit(measure) else {
            return ""
        }
        return converted
    }

    private func convertBaseUnit() {
        baseAmountTextField.text = convertedBaseUnit()
    }
    
    func saveCustomMeasure() {
        guard
            let title = unitTextField.text,
            let baseUnit = baseUnitTextField.text,
            let baseAmountText = baseAmountTextField.text,
            let coef = Double(baseAmountText) else {
            return
        }
        
        let customMeasure: CustomMeasure = CustomMeasure(
            title: title,
            baseUnitSymbol: baseUnit,
            coefficient: coef)
        dataManager.update(measure: customMeasure)
        DataStorage.shared.updateMeasures(dataManager.getCustomMeasures())
    }
    
    private func setupMeasureFromCustomMeasure(with title: String) {
        guard let customMeasure = (DataStorage.shared.customMeasures.first { $0.title == title }) else {
            return
        }
        measure?.symbol = title
        measure?.baseUnitSymbol = customMeasure.baseUnitSymbol
        measure?.coefficient = customMeasure.coefficient
    }
}

//MARK: - TextFieldDelegate
extension ConvertView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }

//    TODO: covertion of custom units
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text, let measurement = measure else {
            return
        }
        switch state {
        case .normal:
            switch textField {
            case amountTextField:
                guard let valueToConvert = Double(text) else {
                    break
                }
                let measureToConvert: Measure = .init(
                    value: valueToConvert,
                    symbol: measurement.symbol)
                baseAmountTextField.text = Converter.convertToBaseUnit(measureToConvert)
                
            case unitTextField:
                
                if !measurement.isStandart {
                    setupMeasureFromCustomMeasure(with: text)
                } else {
                    measure?.symbol = text
                }
                guard let newMeasure = measure else {
                    return
                }
                baseUnitTextField.text = newMeasure.baseUnitSymbol
                convertBaseUnit()
            default:
                break
            }
        case .editing:
            switch textField {
            case unitTextField:
                measure?.symbol = text
                baseUnitTextField.text = measurement.baseUnitSymbol
            default:
                break
            }
        case .converting:
            switch textField {
            case unitTextField:
                convertAmount()
                measure?.symbol = text
            default:
                break
            }
        }

        switch textField {
        case baseAmountTextField:
            measure?.coefficient = Double(text) ?? 0

        default:
            return
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else {
            return
        }
        switch state {
        case .normal:
            switch textField {
            case amountTextField:
                measure?.value = Double(text) ?? 0
            default:
                break
            }
        default:
            break
        }
    }
}

