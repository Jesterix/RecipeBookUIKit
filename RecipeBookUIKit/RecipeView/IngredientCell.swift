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
    private var measurementTextField: UITextField!

    weak var tableView: UITableView?

    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layoutContent(in: self)
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

        measurementTextField = layout(UITextField()) { make in
            make.centerY.equalTo(titleTextField)
            make.leading.equalTo(valueTextField.trailing).offset(5)
            make.trailing.equalToSuperview()
        }
        measurementTextField.tag = 2
    }

    // MARK: - applyStyle
    private func applyStyle() {
        backgroundColor = .white
        
        titleTextField.font = .systemFont(ofSize: 15)
        valueTextField.font = .systemFont(ofSize: 15)
        measurementTextField.font = .systemFont(ofSize: 15)
        
        titleTextField.textColor = .black
        valueTextField.textColor = .black
        measurementTextField.textColor = .black

        valueTextField.textAlignment = .right

        titleTextField.autocorrectionType = .no
        valueTextField.autocorrectionType = .no

        titleTextField.backgroundColor = .systemTeal
        valueTextField.backgroundColor = .systemPink
        measurementTextField.backgroundColor = .systemOrange
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
 
    func ingredientChanged(action: @escaping (Ingredient) -> Void) {
        self.ingredientChanged = action
    }

    private func selectRow() {
        guard
            let tableView = self.tableView,
            let indexpath = tableView.indexPath(for: self) else { return }

        tableView.selectRow(
            at: indexpath,
            animated: true,
            scrollPosition: .none)
        tableView.delegate?.tableView?(
            tableView,
            didSelectRowAt: indexpath)
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
                ingredient.measurement = Measure(value: value, symbol: "")
            }

        case 2:
            ingredient.measurement?.symbol = textField.text ?? ""
            
        default: ingredient.title = textField.text ?? ""
        }
        
        ingredientChanged?(ingredient)
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 2:
            self.endEditing(true)
            selectRow()
            return false
        default:
            return true
        }
    }
}

