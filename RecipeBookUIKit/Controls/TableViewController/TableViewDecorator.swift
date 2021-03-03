//
//  TableViewDecorator.swift
//  RecipeBookUIKit
//
//  Created by Георгий on 03.03.2021.
//  Copyright © 2021 George Khaydenko. All rights reserved.
//

/**
 * Decorator for table view with static heights
 */

import UIKit

open class CustomTableView: UITableView {
    public var tableRoundedShadow: Bool = false
}

public final class TableViewDecorator {
    /// Decorated table view
    let tableView: CustomTableView
    
    /// DataSource used for TableView
    private let dataSource = TableViewDataSource()
    
    private var registeredCellIdentifiers = Set<String>()
    private var registeredHeaderFooterIdentifiers = Set<String>()
    weak public var rowActionsDelegate: RowEditActionsDelegate? {
        didSet {
            dataSource.delegate = rowActionsDelegate
            tableView.clipsToBounds = true
        }
    }
    
    public var didScrollToOffset: Event<Double> {
        get {
            return dataSource.didScrollToOffset
        }
    }
    
    public var scrollWillStopAt: Event<Double> {
        get {
            return dataSource.scrollWillStopAt
        }
    }
    
    public var sections: [BaseTableViewSection] {
        get {
            return dataSource.sections
        }
        set (sections) {
            dataSource.sections = sections
            sections.enumerated().forEach { (index, section) in
                section.decorator = self
                section.sectionIndex = index
            }
        }
    }
    
    public init(forTableView tableView: CustomTableView, selfSizing: Bool = false) {
        self.tableView = tableView
        
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
        if selfSizing {
            tableView.estimatedRowHeight = 60
            tableView.rowHeight = UITableView.automaticDimension
        }
    }
    
    public func reloadAllSections() {
        tableView.reloadData()
    }
    
    public func reloadAllSectionsAnimated() {
        UIView.transition(
            with: tableView,
            duration: 0.2,
            options: .transitionCrossDissolve,
            animations: {
                self.tableView.reloadData()
        }, completion: nil)
    }
    
    /// Clears all selections in the tableView
    /// Call it on viewWillAppear()
    public func clearSelection() {
        if let selections = tableView.indexPathsForSelectedRows {
            for selection in selections {
                tableView.deselectRow(at: selection, animated: true)
            }
        }
    }
    
    // MARK: - Internal
    
    func addCellReuseIdentifiers(_ reuseIdentifiers: [String: AnyClass]) {
        for (reuseIdentifier, cellClass) in reuseIdentifiers {
            if !registeredCellIdentifiers.contains(reuseIdentifier) {
                registeredCellIdentifiers.insert(reuseIdentifier)
                tableView.register(cellClass, forCellReuseIdentifier: reuseIdentifier)
            }
        }
    }
    
    func addHeaderFooterReuseIdentifiers(_ reuseIdentifiers: [String: AnyClass]) {
        for (reuseIdentifier, headerFooterClass) in reuseIdentifiers {
            if !registeredHeaderFooterIdentifiers.contains(reuseIdentifier) {
                registeredHeaderFooterIdentifiers.insert(reuseIdentifier)
                tableView.register(headerFooterClass, forHeaderFooterViewReuseIdentifier: reuseIdentifier)
            }
        }
    }
}
