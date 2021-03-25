//
//  RecipeHeaderView.swift
//  RecipeBookUIKit
//
//  Created by Георгий Хайденко on 21.07.2020.
//  Copyright © 2020 George Khaydenko. All rights reserved.
//

import UIKit

final class RecipeHeaderView: UIView {
    var titleField: UITextField!
    var convertPortionsView: ConvertPortionsView!
    var addIngredientTextField: AddTextField!
    
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
            make.top.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.width.equalTo(175)
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
            make.bottom.equalToSuperview().inset(10)
        }
    }

    // MARK: - applyStyle
    private func applyStyle() {
        backgroundColor = .white
        
        titleField.font = .systemFont(ofSize: 21)
        titleField.textColor = .darkBrown
        titleField.autocorrectionType = .no
        titleField.addStandartToolbar()

        addIngredientTextField.setPlaceholder(text: "Recipe.Add.Placeholder".localized())
    }
}
