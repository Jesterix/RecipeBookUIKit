//
//  MainViewController.swift
//  RecipeBookUIKit
//
//  Created by Георгий Хайденко on 20.07.2020.
//  Copyright © 2020 George Khaydenko. All rights reserved.
//

import UIKit
import MeasureLibrary

final class MainViewController: UIViewController {
    private var mainView: MainView!
    private let dataManager: DataManager = DataBaseManager()
    private var customProvider: CustomMeasureProvider = DataStorage.shared

    override func loadView() {
        self.mainView = MainView()
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Main.Recipes.Title".localized()

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
        dataManager.createDefaultData()
        self.mainView.recipeTableView.reloadData()
    }

    private func doFirstFetch() {
        customProvider.customMeasures = dataManager.getCustomMeasures()
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
            title: "Main.Delete.Action".localized()
        ) { _, _, _ in
            self.dataManager.remove(
                recipe: self.dataManager.getRecipes()[indexPath.row])
            tableView.reloadData()
        }
        deleteAction.backgroundColor = .brightRed

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

extension MainViewController: ObjectFromStringAdding {
    func addObject(from string: String) {
        dataManager.update(recipe: Recipe(title: string))
        mainView.recipeTableView.reloadData()
    }
}

