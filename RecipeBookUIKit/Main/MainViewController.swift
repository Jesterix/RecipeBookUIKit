//
//  MainViewController.swift
//  RecipeBookUIKit
//
//  Created by Георгий Хайденко on 20.07.2020.
//  Copyright © 2020 George Khaydenko. All rights reserved.
//

import UIKit

final class MainViewController: UIViewController {
    private var mainView: MainView!

    var recipes = [Recipe(title: "first", ingredients: [Ingredient(title: "Water")]), Recipe(title: "second", text: "recipeText here"), Recipe(title: "third")]

    override func loadView() {
        self.mainView = MainView()
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Recipes"

        mainView.recipeTableView.dataSource = self
        mainView.recipeTableView.delegate = self
        mainView.recipeTableView.register(
            RecipeCell.self,
            forCellReuseIdentifier: RecipeCell.reuseID)
        mainView.addRecipeTextField.addingDelegate = self

        hideKeyboardOnTap()
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        recipes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecipeCell.reuseID) as? RecipeCell else {
            return UITableViewCell()
        }
        cell.configureCell(with: recipes[indexPath.row])

        return cell
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        navigationController?.pushViewController(
            RecipeViewController(recipes[indexPath.row]),
            animated: true)
    }

    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {

        let deleteAction = UIContextualAction(
            style: .destructive,
            title: "Delete"
        ) { _, _, _ in
            self.recipes.remove(at: indexPath.row)
            tableView.reloadData()
        }

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

extension MainViewController: ObjectFromStringAdding {
    func addObject(from string: String) {
        recipes.append(Recipe(title: string))
        mainView.recipeTableView.reloadData()
    }
}

