//
//  MainViewController.swift
//  RecipeBookUIKit
//
//  Created by Георгий Хайденко on 20.07.2020.
//  Copyright © 2020 George Khaydenko. All rights reserved.
//

import UIKit
import MeasureLibrary

final class MainViewController: TableViewController {
    let sharedDefaults = UserDefaults.init(
        suiteName: "group.com.jesterix.RecipeBook")
    var isSharing = false
    private var observer: Any?

    private var addRecipeTextField = AddTextField()
    private let dataManager: DataManager = DataBaseManager()
    private var customProvider: CustomMeasureProvider = DataStorage.shared
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Main.Recipes.Title".localized()
        
        self.view.backgroundColor = .white
        setupHeader()
        
        tableViewDecorator = TableViewDecorator(forTableView: tableView, selfSizing: true)
        tableViewDecorator.sections = [ mainSection() ]
        tableViewDecorator.rowActionsDelegate = self
        
        hideKeyboardOnTap()
//        configureEmptyView(image: UIImage(), title: "No recipes yet", description: "")
        getDataFromDatabase()
        doFirstFetch()
        
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        addRecipeTextField.setupGradient(
            startColor: .brightRed,
            throughColor: UIColor.honeyYellow.withAlphaComponent(0.8),
            throughAnother: UIColor.honeyYellow.withAlphaComponent(0.4),
            endColor: UIColor.honeyYellow.withAlphaComponent(0.2),
            direction: .addField)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableViewDecorator.reloadAllSections()
        showSharedTask { _ in }
        observer = NotificationCenter.default.addObserver(
            forName: UIApplication.willEnterForegroundNotification,
            object: nil,
            queue: .main) { [weak self] _ in
                self?.isSharing = true
                self?.showSharedTask { _ in }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        unsubscribe()
    }
    
    private func unsubscribe() {
        if let observer = observer {
            NotificationCenter.default.removeObserver(observer)
            self.observer = nil
        }
    }
    
    private func setupHeader() {
        layoutInHeader(
            view: addRecipeTextField,
            insets: UIEdgeInsets(
                top: 10,
                left: 16,
                bottom: 0,
                right: 16)
        )
        addRecipeTextField.setPlaceholder(text: "Main.Add.+Placeholder".localized())
        addRecipeTextField.setActivePlaceholder(text: "Main.Add.Placeholder".localized())
        addRecipeTextField.addingDelegate = self
    }
    
    private func getDataFromDatabase() {
        dataManager.createDefaultData()
        tableViewDecorator.reloadAllSections()
    }

    private func doFirstFetch() {
        customProvider.customMeasures = dataManager.getCustomMeasures()
    }
    
    private func handleSharedTask(completion: @escaping(Bool)->()) {
        guard let shareTask = sharedDefaults?.string(forKey: "shareTask") else {
            return
        }
        isSharing = true
        addObject(from: shareTask)
        sharedDefaults?.removeObject(forKey: "shareTask")
        isSharing = false
        completion(isSharing)
    }
    
    func showSharedTask(completion: @escaping(Bool)->()) {
        handleSharedTask(completion: completion)
    }
    
    func mainSection() -> BaseTableViewSection {
        let section = MainSection(dataManager: dataManager)
        section.didSelect = { [weak self] row in
            guard let self = self else { return }
            self.navigationController?.pushViewController(
                RecipeViewController(self.dataManager.getRecipes()[row]),
                animated: true)
        }
        return section
    }
}

extension MainViewController: RowEditActionsDelegate {
    func editActionsConfigForRowAt(_ indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(
            style: .destructive,
            title: "Main.Delete.Action".localized()
        ) { _, _, _ in
            self.dataManager.remove(
                recipe: self.dataManager.getRecipes()[indexPath.row])
            self.tableViewDecorator.reloadAllSections()
        }
        deleteAction.backgroundColor = .brightRed
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

extension MainViewController: ObjectFromStringAdding {
    func addObject(from string: String) {
        if isSharing {
            dataManager.update(recipe: Recipe(title: string.firstWord(), text: string.dropFirstWord()))
        } else {
            dataManager.update(recipe: Recipe(title: string))
        }
        tableViewDecorator.reloadAllSections()
    }
}
