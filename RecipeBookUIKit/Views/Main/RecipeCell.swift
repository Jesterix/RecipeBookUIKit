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

    private var recipeInfoLabel: InsettedLabel!

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
        recipeInfoLabel = layout(InsettedLabel(text: "recipe info")) { make in
            make.top.equalToSuperview().offset(5)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-5)
            make.height.equalTo(40)
        }
    }

    // MARK: - applyStyle
    private func applyStyle() {
        backgroundColor = .white
        recipeInfoLabel.contentInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        recipeInfoLabel.textColor = .darkBrown
        recipeInfoLabel.font = .systemFont(ofSize: 17)
        recipeInfoLabel.backgroundColor = .honeyYellow
        recipeInfoLabel.layer.cornerRadius = 5
        recipeInfoLabel.layer.masksToBounds = true
    }

    func configureCell(with recipe: Recipe) {
        recipeInfoLabel.text = recipe.title
        if recipe.text.count > 0 {
            recipeInfoLabel.text?.append(contentsOf: ", \(recipe.text)")
        }
    }
}
