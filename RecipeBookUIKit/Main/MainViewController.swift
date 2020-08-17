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
    private let dataManager = DataBaseManager()

    override func loadView() {
        self.mainView = MainView()
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Recipes"

        setupDelegates()
        hideKeyboardOnTap()
        getDataFromDatabase()
        doFirstFetch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        mainView.recipeTableView.reloadData()
    }
    
    private func setupDelegates() {
        mainView.recipeTableView.dataSource = self
        mainView.recipeTableView.delegate = self
        mainView.recipeTableView.register(
            RecipeCell.self,
            forCellReuseIdentifier: RecipeCell.reuseID)
        mainView.addRecipeTextField.addingDelegate = self
    }
    
    private func getDataFromDatabase() {
        dataManager.createBaseData()
        self.mainView.recipeTableView.reloadData()
    }

    private func doFirstFetch() {
        DataStorage.shared.userMeasures = dataManager.getUserMeasures()
        DataStorage.shared.customMeasures = dataManager.getCustomMeasues()
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        dataManager.getRecipes().count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecipeCell.reuseID) as? RecipeCell else {
            return UITableViewCell()
        }
        cell.configureCell(with: dataManager.getRecipes()[indexPath.row])

        return cell
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)

        navigationController?.pushViewController(
            RecipeViewController(dataManager.getRecipes()[indexPath.row]),
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
            self.dataManager.remove(
                recipe: self.dataManager.getRecipes()[indexPath.row])
            tableView.reloadData()
        }

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

extension MainViewController: ObjectFromStringAdding {
    func addObject(from string: String) {
        dataManager.update(recipe: Recipe(title: string))
        mainView.recipeTableView.reloadData()
    }
}

