//
//  ConvertView.swift
//  RecipeBookUIKit
//
//  Created by Георгий Хайденко on 03.08.2020.
//  Copyright © 2020 George Khaydenko. All rights reserved.
//

import UIKit
import MeasureLibrary

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
    var measureIsStandart: ((Bool) -> Void)?
    
    private var amountLabel: UILabel!
    private var unitLabel: UILabel!

    private var amountTextField: TwoModeTextField!
    private var unitTextField: TwoModeTextField!

    private var baseUnitLabel: UILabel!

    private var baseAmountTextField: TwoModeTextField!
    private var baseUnitTextField: TwoModeTextField!
    
    private let dataManager: DataManager = DataBaseManager()
    private var customProvider: CustomMeasureProvider = DataStorage.shared

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
            make.leading.equalToSuperview()
            make.height.equalTo(30)
            make.width.equalTo(100)
        }
        amountTextField.delegate = self
        
        amountLabel = layout(UILabel(text: "Quantity.Label.Text".localized())) { make in
            make.top.equalToSuperview()
            make.centerX.equalTo(amountTextField)
            make.bottom.equalTo(amountTextField.top).offset(-5)
        }

        unitTextField = layout(TwoModeTextField()) { make in
            make.top.equalTo(amountTextField)
            make.leading.equalTo(amountTextField.trailing).offset(5)
            make.trailing.equalToSuperview()
            make.height.equalTo(amountTextField)
        }
        unitTextField.delegate = self
        
        unitLabel = layout(UILabel(text: "Unit.Label.Text".localized())) { make in
            make.top.equalToSuperview()
            make.centerX.equalTo(unitTextField)
            make.bottom.equalTo(unitTextField.top).offset(-5)
        }

        baseUnitLabel = layout(UILabel(text: "BaseUnit.Label.Text".localized())) { make in
            make.top.equalTo(amountTextField.bottom).offset(20)
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
        amountTextField.textColor = .darkBrown

        unitTextField.autocorrectionType = .no
        unitTextField.mode = .changeable
        unitTextField.textColor = .darkBrown
        
        amountLabel.font = .systemFont(ofSize: 10)
        amountLabel.textColor = .darkBrown
        unitLabel.font = .systemFont(ofSize: 10)
        unitLabel.textColor = .darkBrown

        baseUnitLabel.font = .systemFont(ofSize: 10)
        baseUnitLabel.textColor = .darkBrown

        baseAmountTextField.autocorrectionType = .no
        baseAmountTextField.textAlignment = .right
        baseAmountTextField.mode = .disabled
        baseAmountTextField.keyboardType = .decimalPad
        baseAmountTextField.textColor = .darkBrown

        baseUnitTextField.autocorrectionType = .no
        baseUnitTextField.mode = .disabled
        baseUnitTextField.textColor = .darkBrown
        
        let placeholderAttributes: [NSAttributedString.Key: Any]? = [
            .foregroundColor: UIColor.coldBrown.withAlphaComponent(0.7),
            .font: UIFont.systemFont(ofSize: 13)
        ]
        baseAmountTextField.attributedPlaceholder = NSAttributedString(
            string: "-",
            attributes: placeholderAttributes)
        baseUnitTextField.attributedPlaceholder = NSAttributedString(
            string: "Placeholder.NotSet".localized(),
            attributes: placeholderAttributes)

//        //Demo
//        amountTextField.text = "5"
//        baseAmountTextField.text = "100"
//        unitTextField.text = "spoon"
//        baseUnitTextField.text = "gramm"
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
            customProvider: customProvider,
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
            unitTextField.pickerData = customProvider.customMeasures.map {
                $0.title
            }
        }
        
        switch state {
        case .editing:
            baseUnitTextField.text = dimension.baseSymbol.localized()
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
        guard let title = unitTextField.text else {
            return
        }
        
        var customCoef: Double = 1.0
        if let baseAmount = baseAmountTextField.text, let coef = Double(baseAmount) {
            customCoef = coef
        }
        
        let customMeasure: CustomMeasure = CustomMeasure(
            title: title,
            baseUnitSymbol: baseUnitTextField.text ?? "",
            coefficient: customCoef)
        dataManager.update(measure: customMeasure)
        customProvider.updateMeasures(dataManager.getCustomMeasures())
        setMeasureFromText()
    }
    
    private func handleAmountConverting(textAmount: String) {
        guard
            let valueToConvert = Double(textAmount),
            let symbol = unitTextField.text else {
                return
        }
        let measureToConvert = Measure.init(
            customProvider: customProvider,
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
                    customProvider: customProvider,
                    value: 1,
                    symbol: text) ?? Measure(value: 1, symbol: text)
                measureIsStandart?(newMeasure.isStandart || customProvider.customMeasures.contains(where: { $0.title == text }))
                baseUnitTextField.text = newMeasure.baseUnitSymbol
                baseAmountTextField.mode = baseUnitTextField.text == "" ? .editable : .disabled
                onBaseUnitChange?(newMeasure)
                
            default:
                break
            }
            
        case .converting:
            switch textField {
            case amountTextField:
                print("extended, amountTextField")
                handleAmountConverting(textAmount: text)
                
            case unitTextField:
                print("extended, unitTextField")
                
                guard
                    let textToConvert = baseAmountTextField.text,
                    let valueToConvert = Double(textToConvert),
                    let symbol = baseUnitTextField.text else {
                    break
                }
                let baseMeasure = Measure(value: valueToConvert, symbol: symbol)
                amountTextField.text = Converter.convertBaseToUnit(baseMeasure, to: text, with: customProvider)

            default:
                break
            }
        }
    }
    
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        switch textField {
        case amountTextField, baseAmountTextField:
            if let text = (textField.text as NSString?)?.replacingCharacters(
                in: range,
                with: string), text.contains(",") {
                textField.text = text.replacingOccurrences(of: ",", with: ".")
                return false
            } else {
                return true
            }
            
        default:
            return true
        }
    }
}

