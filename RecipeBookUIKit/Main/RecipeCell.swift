//
//  RecipeCell.swift
//  RecipeBookUIKit
//
//  Created by Георгий Хайденко on 20.07.2020.
//  Copyright © 2020 George Khaydenko. All rights reserved.
//

import UIKit

final class RecipeCell: UITableViewCell {
    static var reuseID = "RecipeCell"

    private var recipeInfoLabel: UILabel!

    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layoutContent(in: self)
        applyStyle()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - layoutContent
    private func layoutContent(in view: UIView) {
        recipeInfoLabel = layout(UILabel(text: "recipe info")) { make in
            make.top.leading.equalToSuperview().offset(5)
            make.trailing.bottom.equalToSuperview().offset(-5)
        }
    }

    // MARK: - applyStyle
    private func applyStyle() {
        recipeInfoLabel.font = .systemFont(ofSize: 13)
    }

    func configureCell(with recipe: Recipe) {
        recipeInfoLabel.text = recipe.title
        if recipe.text.count > 0 {
            recipeInfoLabel.text?.append(contentsOf: ", \(recipe.text)")
        }
    }
}
