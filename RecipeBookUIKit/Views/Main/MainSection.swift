//
//  MainSection.swift
//  RecipeBookUIKit
//
//  Created by Георгий Хайденко on 20.07.2020.
//  Copyright © 2020 George Khaydenko. All rights reserved.
//

import UIKit

final class MainSection: DefaultSectionWithBackground {
    private let cellIdentifier = RecipeCell.reuseID
    
    private var dataManager: DataManager
    
    public var didSelect: ((Int) -> Void)?
    
    init(dataManager: DataManager) {
        self.dataManager = dataManager
        super.init()
    }

    // MARK: - Cells

    override var cellReuseIdentifiers: [String: UITableViewCell.Type] {
        return [
            cellIdentifier: RecipeCell.self
        ]
    }

    override var numberOfRows: Int {
        return dataManager.getRecipes().count
    }

    override func cellView(forIndex index: Int) -> CustomTableViewCell {
        let cell: RecipeCell = dequeueCell(forReuseIdentifier: cellIdentifier)
        
        cell.configureCell(with: dataManager.getRecipes()[index])
        
        return cell
    }
    
    override func didSelectRow(atIndex: Int) {
        didSelect?(atIndex)
    }
}

