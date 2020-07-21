//
//  RecipeView.swift
//  RecipeBookUIKit
//
//  Created by Георгий Хайденко on 21.07.2020.
//  Copyright © 2020 George Khaydenko. All rights reserved.
//

import UIKit

final class RecipeView: UIView {
    var addIngredientTextField: AddTextField!
    var ingredientTableView: UITableView!

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
        addIngredientTextField = layout(AddTextField()) { make in
            make.top.equalTo(safeArea).offset(10)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.height.equalTo(30)
        }

        ingredientTableView = layout(UITableView()) { make in
            make.top.equalTo(addIngredientTextField.bottom).offset(10)
            make.leading.trailing.equalTo(addIngredientTextField)
            make.bottom.equalTo(safeArea).offset(-10)
        }
    }

    // MARK: - applyStyle
    private func applyStyle() {
        backgroundColor = .white
        addIngredientTextField.placeholder = "Add ingredient"
    }
}

