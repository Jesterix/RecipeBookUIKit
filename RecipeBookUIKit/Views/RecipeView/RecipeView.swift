//
//  RecipeView.swift
//  RecipeBookUIKit
//
//  Created by Георгий Хайденко on 21.07.2020.
//  Copyright © 2020 George Khaydenko. All rights reserved.
//

import UIKit

final class RecipeView: UIView {
    var titleField: UITextField!
    var convertPortionsView: ConvertPortionsView!
    var addIngredientTextField: AddTextField!
    var ingredientTableView: UITableView!
    var textView: UITextView!

    init() {
        super.init(frame: .zero)
        layoutContent(in: self)
        applyStyle()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - layoutContent
    private func layoutContent(in view: UIView) {
        convertPortionsView = layout(ConvertPortionsView()) { make in
            make.top.equalTo(safeArea).offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.width.equalTo(125)
        }
        
        titleField = layout(UITextField()) { make in
            make.centerY.equalTo(convertPortionsView)
            make.leading.equalToSuperview().offset(10)
            make.trailing.lessThanOrEqualTo(convertPortionsView.leading)
        }
        
        addIngredientTextField = layout(AddTextField()) { make in
            make.top.equalTo(convertPortionsView.bottom).offset(10)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.height.equalTo(40)
        }

        ingredientTableView = layout(UITableView()) { make in
            make.top.equalTo(addIngredientTextField.bottom).offset(10)
            make.leading.trailing.equalTo(addIngredientTextField)
            make.bottom.equalTo(safeArea).dividedBy(2)
        }

        textView = layout(UITextView()) { make in
            make.top.equalTo(ingredientTableView.bottom).offset(10)
            make.leading.trailing.equalTo(addIngredientTextField)
            make.bottom.equalTo(safeArea).offset(-10)
        }
    }

    // MARK: - applyStyle
    private func applyStyle() {
        backgroundColor = .white
        
        titleField.font = .systemFont(ofSize: 21)
        titleField.textColor = .darkBrown
        titleField.autocorrectionType = .no

        addIngredientTextField.placeholder = "Recipe.Add.Placeholder".localized()
        
        ingredientTableView.backgroundColor = .milkWhite
        ingredientTableView.allowsSelection = false

        textView.autocorrectionType = .no

//        let color = #colorLiteral(red: 0.9609501958, green: 0.8888508081, blue: 0.8478230238, alpha: 0.9998855591)
        textView.backgroundColor = .lightlyGray
        textView.layer.cornerRadius = 10
        textView.font = .systemFont(ofSize: 15)
        textView.textColor = .darkBrown
    }
}

