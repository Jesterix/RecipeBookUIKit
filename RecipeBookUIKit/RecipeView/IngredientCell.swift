//
//  IngredientCell.swift
//  RecipeBookUIKit
//
//  Created by Георгий Хайденко on 21.07.2020.
//  Copyright © 2020 George Khaydenko. All rights reserved.
//

import UIKit

final class IngredientCell: UITableViewCell {
    static var reuseID = "IngredientCell"
    
    private var ingredient: Ingredient = Ingredient(title: "")
    private var ingredientChanged: ((Ingredient) -> Void)?

    private var titleTextField: UITextField!
    private var valueTextField: UITextField!
    private var measurementLabel: UILabel!

    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layoutContent(in: self)
        applyStyle()
        titleTextField.delegate = self
        valueTextField.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - layoutContent
    private func layoutContent(in view: UIView) {
        titleTextField = layout(UITextField()) { make in
            make.top.leading.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().offset(-5)
            make.width.equalToSuperview().dividedBy(2)
        }

        valueTextField = layout(UITextField()) { make in
            make.centerY.equalTo(titleTextField)
            make.leading.equalTo(titleTextField.trailing).offset(5)
            make.width.equalToSuperview().dividedBy(6)
        }
        valueTextField.tag = 1

        measurementLabel = layout(UILabel(text: "")) { make in
            make.centerY.equalTo(titleTextField)
            make.leading.equalTo(valueTextField.trailing).offset(5)
        }
    }

    // MARK: - applyStyle
    private func applyStyle() {
        backgroundColor = .white
        
        titleTextField.font = .systemFont(ofSize: 15)
        valueTextField.font = .systemFont(ofSize: 15)
        measurementLabel.font = .systemFont(ofSize: 15)
        
        titleTextField.textColor = .black
        valueTextField.textColor = .black
        measurementLabel.textColor = .black

        valueTextField.textAlignment = .right
    }

    func configureCell(with ingredient: Ingredient) {
        self.ingredient = ingredient
        
        titleTextField.text = ingredient.title

        guard let measure = ingredient.measurement else {
            return
        }
        valueTextField.text = "\(measure.value)"
        measurementLabel.text = "\(measure.unit.symbol)"
    }
 
    func ingredientChanged(action: @escaping (Ingredient) -> Void) {
        self.ingredientChanged = action
    }
}

extension IngredientCell: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        switch textField.tag {
            
        case 1:
            guard let text = textField.text, let value = Double(text) else {
                return
            }
            if ingredient.measurement != nil {
                ingredient.measurement?.value = value
            } else {
                ingredient.measurement = Measurement(
                    value: value,
                    unit: Unit(symbol: ""))
            }
            
        default: ingredient.title = textField.text ?? ""
        }
        
        ingredientChanged?(ingredient)
    }
}

