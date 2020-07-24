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

    private var titleLabel: UILabel!
    private var valueLabel: UILabel!
    private var measurementLabel: UILabel!

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
        titleLabel = layout(UILabel(text: "")) { make in
            make.top.leading.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().offset(-5)
            make.width.equalToSuperview().dividedBy(2)
        }

        valueLabel = layout(UILabel(text: "")) { make in
            make.centerY.equalTo(titleLabel)
            make.leading.equalTo(titleLabel.trailing).offset(5)
            make.width.equalToSuperview().dividedBy(6)
        }

        measurementLabel = layout(UILabel(text: "")) { make in
            make.centerY.equalTo(titleLabel)
            make.leading.equalTo(valueLabel.trailing).offset(5)
        }
    }

    // MARK: - applyStyle
    private func applyStyle() {
        backgroundColor = .white
        
        titleLabel.font = .systemFont(ofSize: 13)
        valueLabel.font = .systemFont(ofSize: 13)
        measurementLabel.font = .systemFont(ofSize: 13)
        
        titleLabel.textColor = .black
        valueLabel.textColor = .black
        measurementLabel.textColor = .black

        valueLabel.textAlignment = .right
    }

    func configureCell(with ingredient: Ingredient) {
        titleLabel.text = ingredient.title

        guard let measure = ingredient.measurement else {
            return
        }
        valueLabel.text = "\(measure.value)"
        measurementLabel.text = "\(measure.unit.symbol)"
    }
}

