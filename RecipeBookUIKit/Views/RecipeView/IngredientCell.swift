//
//  IngredientCell.swift
//  RecipeBookUIKit
//
//  Created by Георгий Хайденко on 21.07.2020.
//  Copyright © 2020 George Khaydenko. All rights reserved.
//

import UIKit
import MeasureLibrary

final class IngredientCell: CustomTableViewCell {
    static var reuseID = "IngredientCell"
    
    private var ingredient: Ingredient = Ingredient(title: "")
    public var ingredientChanged: ((Ingredient) -> Void)?

    private var titleTextField: InsettedTextField!
    private var valueTextField: InsettedTextField!
    private var measurementTextField: InsettedTextField!
    
    private var valueTextFieldDecorator: TextFieldDecorator?
    
    public var didTapMeasurement: (() -> Void)?

    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layoutContent(in: self.contentView)
        applyStyle()
        titleTextField.delegate = self
        measurementTextField.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - layoutContent
    private func layoutContent(in view: UIView) {
        titleTextField = layout(InsettedTextField()) { make in
            make.top.leading.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().offset(-5)
            make.width.equalToSuperview().dividedBy(2)
        }

        valueTextField = layout(InsettedTextField()) { make in
            make.centerY.equalTo(titleTextField)
            make.leading.equalTo(titleTextField.trailing).offset(5)
            make.width.equalToSuperview().dividedBy(5.5)
        }

        measurementTextField = layout(InsettedTextField()) { make in
            make.centerY.equalTo(titleTextField)
            make.leading.equalTo(valueTextField.trailing).offset(5)
            make.trailing.equalToSuperview().offset(-5)
        }
    }

    // MARK: - applyStyle
    private func applyStyle() {
        backgroundColor = .white
        selectionStyle = .none

        valueTextField.textAlignment = .right

        titleTextField.autocorrectionType = .no
        valueTextField.autocorrectionType = .no
        
        titleTextField.addStandartToolbar()
        valueTextField.addStandartToolbar()

        titleTextField.layer.borderColor = UIColor.warmBrown.cgColor
        setTitleStyle()
        titleTextField.backgroundColor = UIColor.honeyYellow.withAlphaComponent(0.5)
        valueTextField.backgroundColor = UIColor.honeyYellow.withAlphaComponent(0.5)
//        measurementTextField.backgroundColor = UIColor.warmBrown.withAlphaComponent(0.7)

        valueTextField.keyboardType = .decimalPad
        
        [titleTextField,
         valueTextField,
         measurementTextField].forEach { item in
            item?.font = .systemFont(ofSize: 15)
            item?.textColor = .darkBrown
            item?.layer.cornerRadius = 4
            item?.textInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        }
        
        valueTextFieldDecorator = TextFieldDecorator(forTextField: valueTextField)
        valueTextFieldDecorator?.mask = TextFieldMeasureValueMask()
        valueTextFieldDecorator?.delegate = self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if measurementTextField.isUserInteractionEnabled {
            measurementTextField.layer.sublayers?.removeAll()
            
            _ = measurementTextField.addGradient(
                startColor: .brightRed,
                throughColor: UIColor.honeyYellow.withAlphaComponent(0.5),
                endColor: UIColor.honeyYellow.withAlphaComponent(0.5),
                direction: .downLeft)
        }
    }
    
    private func setTitleStyle() {
        titleTextField.layer.borderWidth = 0
        Settings.basicIngredients.forEach { basic in
            if basic.title.caseInsensitiveCompare(ingredient.title) == .orderedSame || basic.titleLocalized.caseInsensitiveCompare(ingredient.title) == .orderedSame {
                titleTextField.layer.borderWidth = 2
            }
        }
    }

    func configureCell(with ingredient: Ingredient) {
        self.ingredient = ingredient
        
        titleTextField.text = ingredient.title
        
        setTitleStyle()

        guard let measure = ingredient.measurement else {
            valueTextField.text = ""
            measurementTextField.text = ""
            return
        }
        valueTextField.text = TextFieldMeasureValueMask.correct(value: "\(measure.value)")
        measurementTextField.text = "\(measure.shortSymbol)"
    }

    func configureHeader() {
        let paragraphStyle = NSMutableParagraphStyle()
        let paragraphStyleRight = NSMutableParagraphStyle()
        paragraphStyleRight.alignment = .right

        let headerTextAttributes: [NSAttributedString.Key : Any] = [
            .font: UIFont.systemFont(ofSize: 14, weight: .bold),
            .paragraphStyle: paragraphStyle,
            .foregroundColor: UIColor.darkBrown.withAlphaComponent(0.7)
        ]
        
        let headerValueTextAttributes: [NSAttributedString.Key : Any] = [
            .font: UIFont.systemFont(ofSize: 14, weight: .bold),
            .paragraphStyle: paragraphStyleRight,
            .foregroundColor: UIColor.darkBrown.withAlphaComponent(0.7)
        ]

        titleTextField.attributedText = NSAttributedString(
            string: "Ingredient.Title".localized(),
            attributes: headerTextAttributes)
        valueTextField.attributedText = NSAttributedString(
            string: "Ingredient.Value".localized(),
            attributes: headerValueTextAttributes)
        measurementTextField.attributedText = NSAttributedString(
            string: "Ingredient.Measure".localized(),
            attributes: headerTextAttributes)
        
        titleTextField.backgroundColor = .clear
        valueTextField.backgroundColor = .clear
//        measurementTextField.backgroundColor = .warmBrown
        
        titleTextField.isUserInteractionEnabled = false
        valueTextField.isUserInteractionEnabled = false
        measurementTextField.isUserInteractionEnabled = false
    }
    
    func getViewToTransiteFrom() -> UIView? {
        measurementTextField
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        applyStyle()
        titleTextField.isUserInteractionEnabled = true
        valueTextField.isUserInteractionEnabled = true
        measurementTextField.isUserInteractionEnabled = true
    }
}

//MARK:- UITextFieldDelegate
extension IngredientCell: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        switch textField {
        case measurementTextField:
            ingredient.measurement?.symbol = textField.text ?? ""
            
        default:
            ingredient.title = textField.text ?? ""
            setTitleStyle()
        }
        ingredientChanged?(self.ingredient)
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
        case measurementTextField:
            self.endEditing(true)
            didTapMeasurement?()
            return false
        default:
            return true
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        ingredientChanged?(ingredient)
    }
}

extension IngredientCell: TextFieldDecoratorDelegate {
    public func didChangeTextField(_ textField: UITextField) {
        guard let text = textField.text, let value = Double(text) else {
            return
        }
        if ingredient.measurement != nil {
            ingredient.measurement?.value = value
        } else {
            ingredient.measurement = Measure(value: value, symbol: "")
        }
        
        ingredientChanged?(self.ingredient)
    }
    
    public func didEndEditingTextField(_ textField: UITextField) {
        if let text = textField.text {
            textField.text = TextFieldMeasureValueMask.correct(value: text)
        }
         
        ingredientChanged?(self.ingredient)
    }
}
///Think about setting ingredient title equal to basic ingredient if they match
//switch textField {
//case titleTextField:
//    Settings.basicIngredients.forEach { basic in
//        if basic.title.caseInsensitiveCompare(ingredient.title) == .orderedSame {
//            textField.text = basic.title
//            ingredient.title = basic.title
//        } else if basic.titleLocalized.caseInsensitiveCompare(ingredient.title) == .orderedSame {
//            textField.text = basic.titleLocalized
//            ingredient.title = basic.titleLocalized
//        }
//    }
//default:
//    return
//}

