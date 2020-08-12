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

    private var recipe: Recipe {
        didSet {
            dataManager.update(recipe: recipe)
            recipeView.ingredientTableView.reloadData()
        }
    }
    
    private let dataManager = DataBaseManager()

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
        recipeView.titleField.text = recipe.title
        recipeView.titleField.delegate = self
        recipeView.ingredientTableView.dataSource = self
        recipeView.ingredientTableView.delegate = self
        recipeView.ingredientTableView.register(
            IngredientCell.self,
            forCellReuseIdentifier: IngredientCell.reuseID)
        recipeView.addIngredientTextField.addingDelegate = self
        recipeView.textView.delegate = self
        recipeView.textView.text = recipe.text

        hideKeyboardOnTap()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addKeyboardObservers(#selector(keyboardWillChange(notification:)))
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardObservers()
    }

    @objc func keyboardWillChange(notification: Notification) {
        guard let notification = KeyboardNotification(notification) else {
            return
        }

        if recipeView.textView.isFirstResponder {
            adjustView(with: notification)
        }
    }
}

extension RecipeViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        recipe.ingredients.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: IngredientCell.reuseID) as? IngredientCell else {
            return UITableViewCell()
        }
        cell.configureCell(with: recipe.ingredients[indexPath.row])
        
        cell.ingredientChanged { [weak tableView] (ingredient: Ingredient) in
            self.recipe.ingredients[indexPath.row] = ingredient
//            TODO: fix jumping
//            DispatchQueue.main.async {
//                tableView?.beginUpdates()
//                tableView?.endUpdates()
//            }
        }

        cell.tableView = tableView

        return cell
    }
}

extension RecipeViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)

        let vc = MeasureViewController()

        if let measure = recipe.ingredients[indexPath.row].measurement {
            vc.measure = measure
        }

        vc.onClose = { [unowned self] measure in
            self.recipe.ingredients[indexPath.row].measurement = measure
        }
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        navigationController?.present(vc, animated: true, completion: nil)
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

extension RecipeViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        recipe.text = textView.text
    }
}

extension RecipeViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        recipe.title = textField.text ?? ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
