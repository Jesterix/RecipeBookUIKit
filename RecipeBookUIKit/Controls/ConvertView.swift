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
            setMeasureFromText()
            onStateChange?(state)
        }
    }

    var measure: Measure? {
        didSet {
            setupText()
            guard let measure = measure else {
                return
            }
            onMeasureChange?(measure)
        }
    }

    var onMeasureChange: ((Measure) -> Void)?
    var onStateChange: ((State) -> Void)?
    var onBaseUnitChange: ((Measure) -> Void)?

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
    
    func onClose() {
        setMeasureFromText()
    }

    private func toggleTextFieldsVisibility() {
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
            baseAmountTextField.mode = .disabled
        }
    }
    
    private func setMeasureFromText() {
        guard
            let symbol = unitTextField.text,
            let textValue = amountTextField.text else {
                return
        }
        let value = Double(textValue) ?? 0.0
        
        let newMeasure = Measure.init(
            customProvider: DataStorage.shared,
            value: value,
            symbol: symbol) ?? Measure.init(value: value, symbol: symbol)
        measure = newMeasure
    }

    private func setupText() {
        guard let measurement = measure else {
            return
        }
        
        switch state {
        case .normal, .converting:
            amountTextField.text = "\(measurement.value)"
        case .editing:
            amountTextField.text = "1.0"
        }
        
        unitTextField.text = measurement.symbol
        baseAmountTextField.text = convertedBaseUnit()
        baseUnitTextField.text = measurement.baseUnitSymbol
    }

    //MARK: - input of new dimension
    func setPickerData(with dimension: DimensionType) {
        switch dimension {
        case .mass:
            unitTextField.pickerData = DimensionType.allMass
            unitTextField.additionalPickerData = DimensionType.allMassSymbols
        case .volume:
            unitTextField.pickerData = DimensionType.allVolume
            unitTextField.additionalPickerData = DimensionType.allVolumeSymbols
        case .custom:
            unitTextField.pickerData = DataStorage.shared.customMeasures.map {
                $0.title
            }
        }
        
        switch state {
        case .editing:
            baseUnitTextField.text = dimension.baseSymbol
        default:
            return
        }
    }

    private func convertedBaseUnit() -> String {
        guard
            let measure = measure,
            let converted = Converter.convertToBaseUnit(measure) else {
                return ""
        }
        return converted
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
        setMeasureFromText()
    }
    
    private func handleAmountConverting(textAmount: String) {
        guard
            let valueToConvert = Double(textAmount),
            let symbol = unitTextField.text else {
                return
        }
        let measureToConvert = Measure.init(
            customProvider: DataStorage.shared,
            value: valueToConvert,
            symbol: symbol) ?? Measure.init(
                value: valueToConvert,
                symbol: symbol)
        
        baseAmountTextField.text = Converter.convertToBaseUnit(measureToConvert)
    }
}

//MARK: - TextFieldDelegate
extension ConvertView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text else {
            return
        }
        switch state {
        case .normal:
            switch textField {
            case amountTextField:
                print("normal, amountTextField")
                handleAmountConverting(textAmount: text)
                
            case unitTextField:
                print("normal, unitTextField")
                setMeasureFromText()
                
            default:
                break
            }
        case .editing:
            switch textField {
            case unitTextField:
                print("editing, unitTextField")
                let newMeasure = Measure(
                    customProvider: DataStorage.shared,
                    value: 1,
                    symbol: text) ?? Measure(value: 1, symbol: text)
                
                baseUnitTextField.text = newMeasure.baseUnitSymbol
                baseAmountTextField.mode = baseUnitTextField.text == "" ? .editable : .disabled
                onBaseUnitChange?(newMeasure)
                
            default:
                break
            }
            
        case .converting:
            switch textField {
            case amountTextField:
                print("converting, amountTextField")
                handleAmountConverting(textAmount: text)
                
            case unitTextField:
                print("converting, unitTextField")
                
                guard
                    let textToConvert = baseAmountTextField.text,
                    let valueToConvert = Double(textToConvert),
                    let symbol = baseUnitTextField.text else {
                    break
                }
                let baseMeasure = Measure(value: valueToConvert, symbol: symbol)
                amountTextField.text = Converter.convertBaseToUnit(baseMeasure, to: text)

            default:
                break
            }
        }
    }
}

