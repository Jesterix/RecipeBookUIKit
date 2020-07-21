//
//  RecipeViewController.swift
//  RecipeBookUIKit
//
//  Created by Георгий Хайденко on 21.07.2020.
//  Copyright © 2020 George Khaydenko. All rights reserved.
//

import UIKit

final class RecipeViewController: UIViewController {
    private var recipeView: RecipeView!

    private var recipe: Recipe

    init(_ recipe: Recipe) {
        self.recipe = recipe
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.recipeView = RecipeView()
        self.view = recipeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = recipe.title

        recipeView.ingredientTableView.dataSource = self
        recipeView.ingredientTableView.delegate = self
        recipeView.ingredientTableView.register(
            RecipeCell.self,
            forCellReuseIdentifier: RecipeCell.reuseID)
        recipeView.addIngredientTextField.addingDelegate = self

        hideKeyboardOnTap()
    }
}

extension RecipeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        recipe.ingredients.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecipeCell.reuseID) as? RecipeCell else {
            return UITableViewCell()
        }
//        cell.configureCell(with: recipe.ingredients[indexPath.row])
        cell.textLabel?.text = recipe.ingredients[indexPath.row].title

        return cell
    }
}

extension RecipeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {

        let deleteAction = UIContextualAction(
            style: .destructive,
            title: "Delete"
        ) { _, _, _ in
            self.recipe.ingredients.remove(at: indexPath.row)
            tableView.reloadData()
        }

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

extension RecipeViewController: ObjectFromStringAdding {
    func addObject(from string: String) {
        recipe.ingredients.append(Ingredient(title: string))
        recipeView.ingredientTableView.reloadData()
    }
}
