//
//  RecipeViewController.swift
//  RecipeBookUIKit
//
//  Created by Георгий Хайденко on 21.07.2020.
//  Copyright © 2020 George Khaydenko. All rights reserved.
//

import UIKit

final class RecipeViewController: UIViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    
    private var recipeView: RecipeView!

    private var recipe: Recipe {
        didSet {
            dataManager.update(recipe: recipe)
            recipeView.ingredientTableView.reloadData()
        }
    }
    
    private let dataManager: DataManager = DataBaseManager()

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
        recipeView.showTextViewPlaceholder(recipe.text.isEmpty)
        
        recipeView.convertPortionsView.coefficient = recipe.numberOfPortions ?? 1
        recipeView.convertPortionsView.delegate = self
        
        recipeView.showTablePlaceholder(recipe.ingredients.isEmpty)

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

    @objc private func tapConvert() {
        recipeView.convertPortionsView.stateToggle()
    }
    
    private func convertPortions(with coefficient: Double) {
        RecipeDataHandler.convertPortions(in: &recipe, with: coefficient)
    }
}

extension RecipeViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        recipe.ingredients.count + 1
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: IngredientCell.reuseID) as? IngredientCell else {
            return UITableViewCell()
        }
        
        if indexPath.row == 0 {
            cell.configureHeader()
        } else {
            cell.configureCell(with: recipe.ingredients[indexPath.row - 1])

            cell.ingredientChanged { [unowned self] (ingredient: Ingredient) in
                self.recipe.ingredients[indexPath.row - 1] = ingredient
            }
            cell.tableView = tableView
        }

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

        if let measure = recipe.ingredients[indexPath.row - 1].measurement {
            vc.measure = measure
        }

        vc.onClose = { [unowned self] measure in
            self.recipe.ingredients[indexPath.row - 1].measurement = measure
        }
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        navigationController?.present(vc, animated: true, completion: nil)
    }

    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        if indexPath.row == 0 {
            return UISwipeActionsConfiguration(actions: [])
        } else {
            let deleteAction = UIContextualAction(
                style: .destructive,
                title: "Main.Delete.Action".localized()
            ) { [unowned self] _, _, _ in
                self.recipe.ingredients.remove(at: indexPath.row - 1)
                self.recipeView.showTablePlaceholder(self.recipe.ingredients.isEmpty)
            }
            deleteAction.backgroundColor = .brightRed
            
            return UISwipeActionsConfiguration(actions: [deleteAction])
        }
    }
}

extension RecipeViewController: ObjectFromStringAdding {
    func addObject(from string: String) {
        recipe.ingredients.append(Ingredient(title: string))
        recipeView.showTablePlaceholder(recipe.ingredients.isEmpty)
        recipeView.ingredientTableView.reloadData()
    }
}

extension RecipeViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        recipe.text = textView.text
    }
    
    func textView(
        _ textView: UITextView,
        shouldChangeTextIn range: NSRange,
        replacementText text: String
    ) -> Bool {
        let currentText: String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(
            in: range,
            with: text)
        
        if updatedText.isEmpty {
            recipeView.showTextViewPlaceholder(true)
            textView.selectedTextRange = textView.textRange(
                from: textView.beginningOfDocument,
                to: textView.beginningOfDocument)
        } else if textView.textColor == .coldBrown && !text.isEmpty {
            recipeView.showTextViewPlaceholder(false)
            textView.text = text
        } else {
            return true
        }
        
        return false
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if self.view.window != nil {
            if textView.textColor == UIColor.coldBrown {
                textView.selectedTextRange = textView.textRange(
                    from: textView.beginningOfDocument,
                    to: textView.beginningOfDocument)
            }
        }
    }
}

extension RecipeViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        switch textField {
        case recipeView.titleField:
            recipe.title = textField.text ?? ""
        default:
            return
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField != recipeView.titleField {
            switch recipeView.convertPortionsView.state {
            case .extended:
                convertPortions(with: recipeView.convertPortionsView.coefficient)
            case .normal:
                recipe.numberOfPortions = recipeView.convertPortionsView.coefficient
            }
        }
    }
}
