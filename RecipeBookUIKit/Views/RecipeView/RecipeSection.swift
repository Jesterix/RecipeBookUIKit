//
//  RecipeSection.swift
//  RecipeBookUIKit
//
//  Created by Георгий on 25.03.2021.
//  Copyright © 2021 George Khaydenko. All rights reserved.
//

import UIKit

final class RecipeSection: DefaultSectionWithBackground {
    private let headerCellIdentifier = "HeaderCell"
    private let cellIdentifier = IngredientCell.reuseID
    private let placeholderIdentifier = PlaceholderCell.reuseID
    
    private var recipe: Recipe
    
//    public var didSelect: ((Int) -> Void)?
    public var didTapMeasurement: ((Int, CGRect) -> Void)?
    public var didChangeRecipe: ((Recipe) -> Void)?
    
    init(recipe: Recipe) {
        self.recipe = recipe
        super.init()
    }
    
    public func update(viewModel: Recipe) {
        recipe = viewModel
        reloadSectionAnimated()
    }

    // MARK: - Cells

    override var cellReuseIdentifiers: [String: UITableViewCell.Type] {
        return [
            headerCellIdentifier: IngredientCell.self,
            cellIdentifier: IngredientCell.self,
            placeholderIdentifier: PlaceholderCell.self
        ]
    }

    override var numberOfRows: Int {
        return recipe.ingredients.count + 1
    }

    override func cellView(forIndex index: Int) -> CustomTableViewCell {
        if recipe.ingredients.count > 0 {
            if index == 0 {
                let cell: IngredientCell = dequeueCell(forReuseIdentifier: headerCellIdentifier)
                cell.configureHeader()
                return cell
            } else {
                let cell: IngredientCell = dequeueCell(forReuseIdentifier: cellIdentifier)
                cell.configureCell(with: recipe.ingredients[index - 1])
                
                cell.ingredientChanged = { [unowned self] ingredient in
                    self.recipe.ingredients[index - 1] = ingredient
                    self.didChangeRecipe?(self.recipe)
                }
                cell.didTapMeasurement = { [unowned self] in
                    if let viewToTransiteFrom = cell.getViewToTransiteFrom(),
                       let frameToTransiteFrom = viewToTransiteFrom.globalFrame {
                        self.didTapMeasurement?(index - 1, frameToTransiteFrom)
                    }
                }
                return cell
            }
        } else {
            let cell: PlaceholderCell = dequeueCell(forReuseIdentifier: placeholderIdentifier)
            cell.configureEmptyView(
                image: UIImage(),
                title: "Placeholder.Ingredients.Text".localized(),
                description: "")
            return cell
        }
    }
    
    override func didSelectRow(atIndex: Int) {
        print("didSelect row", atIndex)
//        didSelect?(atIndex)
    }
}

