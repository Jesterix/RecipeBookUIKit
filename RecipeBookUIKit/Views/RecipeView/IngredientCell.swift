//
//  IngredientCell.swift
//  RecipeBookUIKit
//
//  Created by Георгий Хайденко on 21.07.2020.
//  Copyright © 2020 George Khaydenko. All rights reserved.
//

import UIKit
import MeasureLibrary

final class IngredientCell: UITableViewCell {
    static var reuseID = "IngredientCell"
    
    private var ingredient: Ingredient = Ingredient(title: "")
    private var ingredientChanged: ((Ingredient) -> Void)?

    private var titleTextField: InsettedTextField!
    private var valueTextField: InsettedTextField!
    private var measurementTextField: InsettedTextField!
    
    public var didTapMeasurement: (() -> Void)?

    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layoutContent(in: self.contentView)
        applyStyle()
        titleTextField.delegate = self
        valueTextField.delegate = self
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
            make.trailing.equalToSuperview()
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

        titleTextField.backgroundColor = .lightlyGray
        valueTextField.backgroundColor = .warmGray
        measurementTextField.backgroundColor = .warmBrown

        valueTextField.keyboardType = .decimalPad
        
        [titleTextField,
         valueTextField,
         measurementTextField].forEach { item in
            item?.font = .systemFont(ofSize: 15)
            item?.textColor = .darkBrown
            item?.layer.cornerRadius = 3
            item?.textInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        }
    }

    func configureCell(with ingredient: Ingredient) {
        self.ingredient = ingredient
        
        titleTextField.text = ingredient.title

        guard let measure = ingredient.measurement else {
            return
        }
        valueTextField.text = "\(measure.value)"
        measurementTextField.text = "\(measure.symbol)"
    }

    func configureHeader() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center

        let headerTextAttributes: [NSAttributedString.Key : Any] = [
            .font: UIFont.systemFont(ofSize: 14, weight: .bold),
            .paragraphStyle: paragraphStyle,
            .foregroundColor: UIColor.darkBrown.withAlphaComponent(0.7)
        ]

        titleTextField.attributedText = NSAttributedString(
            string: "Ingredient.Title".localized(),
            attributes: headerTextAttributes)
        valueTextField.attributedText = NSAttributedString(
            string: "Ingredient.Value".localized(),
            attributes: headerTextAttributes)
        measurementTextField.attributedText = NSAttributedString(
            string: "Ingredient.Measure".localized(),
            attributes: headerTextAttributes)
        
        titleTextField.backgroundColor = UIColor.lightlyGray.withAlphaComponent(0.3)
        valueTextField.backgroundColor = UIColor.warmGray.withAlphaComponent(0.3)
        measurementTextField.backgroundColor = UIColor.warmBrown.withAlphaComponent(0.3)
        
        titleTextField.isUserInteractionEnabled = false
        valueTextField.isUserInteractionEnabled = false
        measurementTextField.isUserInteractionEnabled = false
    }
 
    func ingredientChanged(action: @escaping (Ingredient) -> Void) {
        self.ingredientChanged = action
    }
}

extension IngredientCell: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        switch textField {
        case valueTextField:
            guard let text = textField.text, let value = Double(text) else {
                return
            }
            if ingredient.measurement != nil {
                ingredient.measurement?.value = value
            } else {
                ingredient.measurement = Measure(value: value, symbol: "")
            }

        case measurementTextField:
            ingredient.measurement?.symbol = textField.text ?? ""
            
        default: ingredient.title = textField.text ?? ""
        }
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

