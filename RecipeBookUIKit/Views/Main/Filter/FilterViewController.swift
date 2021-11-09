//
//  FilterViewController.swift
//  RecipeBookUIKit
//
//  Created by Георгий on 02.11.2021.
//  Copyright © 2021 George Khaydenko. All rights reserved.
//

import UIKit

final class FilterViewController: TableViewController {

    private let dataManager: DataManager = DataBaseManager()
    
    private var filter = FilterViewModel()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    
    public var onDismiss: ((FilterViewModel) -> Void)?
    
    init(filter: FilterViewModel) {
        self.filter = filter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Filter.Settings".localized()
        
        self.view.backgroundColor = .white
        
        tableViewDecorator = TableViewDecorator(forTableView: tableView, selfSizing: true)
        tableViewDecorator.sections = [ sortSection() ]
        
        hideKeyboardOnTap()
        
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableViewDecorator.reloadAllSections()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if self.isMovingFromParent {
            onDismiss?(filter)
        }
    }
    
    func sortSection() -> BaseTableViewSection {
        let section = SortSection(sortType: filter.sortedBy)
        section.didChangeModel = { [weak self] sortBy in
            self?.filter.sortedBy = sortBy
        }
        
        return section
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

public struct FilterViewModel {
    public enum SortType {
        case nameAsc
        case nameDesc
    }
    public enum MealType {
        case noFilter
        case breakfast
        case lunch
        case dinner
    }
    var isEnabled: Bool {
        guard sortedBy == .nameAsc,
              filteredByMeal == .noFilter,
              !isFilteredByIngredients else { return true}
        return false
    }
    
    var sortedBy: SortType = .nameAsc
    var filteredByMeal: MealType = .noFilter
    
    var isFilteredByIngredients = false
    var ingredients: [String] = []
}
