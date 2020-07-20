//
//  MainView.swift
//  RecipeBookUIKit
//
//  Created by Георгий Хайденко on 20.07.2020.
//  Copyright © 2020 George Khaydenko. All rights reserved.
//

import UIKit

final class MainView: UIView {
    var addRecipeTextField: UITextField!
    var recipeTableView: UITableView!

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
        addRecipeTextField = layout(UITextField()) { make in
            make.top.equalTo(safeArea).offset(10)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }

        recipeTableView = layout(UITableView()) { make in
            make.top.equalTo(addRecipeTextField.bottom).offset(10)
            make.leading.trailing.equalTo(addRecipeTextField)
            make.bottom.equalTo(safeArea).offset(-10)
        }
    }

    // MARK: - applyStyle
    private func applyStyle() {
        backgroundColor = .white

        addRecipeTextField.borderStyle = .roundedRect
    }
}

