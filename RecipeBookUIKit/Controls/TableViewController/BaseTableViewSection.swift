//
//  BaseTableViewSection.swift
//  RecipeBookUIKit
//
//  Created by Георгий on 03.03.2021.
//  Copyright © 2021 George Khaydenko. All rights reserved.
//

import UIKit

open class BaseTableViewSection: NSObject
{
    public override init() {}
    
    /// Used proxy
    private let baseProxy = BaseTableViewProxy()
    
    var proxy: BaseTableViewProxy {
        get {
            baseProxy.section = self
            return baseProxy
        }
    }
    
    /// Parent decorator
    weak var decorator: TableViewDecorator! {
        didSet {
            decorator.addCellReuseIdentifiers(cellReuseIdentifiers)
        }
    }
    
    /// Index of section
    var sectionIndex: Int!
    
    public func getSectionIndex() -> Int {
        return sectionIndex
    }
    public func isLastVisibleSection() -> Bool {
        guard self.decorator.tableView.numberOfSections > (sectionIndex + 1) else { return true }
        for index in (sectionIndex + 1)..<self.decorator.tableView.numberOfSections {
            if self.decorator.sections[index].isSectionVisible {
                return false
            }
        }
        return true
    }
    public func isTableRoundedShadowEnabled() -> Bool {
        return self.decorator.tableView.tableRoundedShadow
    }
    public func getTableView() -> UITableView {
        return decorator.tableView
    }
    
    /// Override this to provide cell reuse identifiers
    open var cellReuseIdentifiers: [String: UITableViewCell.Type] {
        get {
            return [:]
        }
    }
    
    /// Override this to get visibility
    open var isSectionVisible: Bool {
        get {
            return true
        }
    }
    
    /// Override this to provide number of rows
    open var numberOfRows: Int {
        get {
            fatalError("Must override numberOfRows")
        }
    }
    
    /// Override this to configure cell
    open func cell(forIndex index: Int) -> CustomTableViewCell {
        fatalError("Must override cellforIndex:")
    }
    
    /// Override this to provide height for row
    open func cellHeight(forIndex index: Int) -> CGFloat {
        fatalError("Must override cellHeightforIndex:")
    }
    
    /// Override this to handle row selection
    open func didSelectRow(atIndex: Int) {
    }

    /// Override this to handle displaying cell
    open func willDisplayCell(atIndex: Int) {
    }
    
    public func reloadSectionAnimated() {
        UIView.transition(
            with: decorator.tableView,
            duration: 0.3,
            options: .transitionCrossDissolve,
            animations: {
                self.reloadSection()
            }, completion: nil)
    }
    
    open func reloadSection() {
        UIView.performWithoutAnimation {
            self.decorator.tableView.reloadSections(IndexSet([self.sectionIndex]), with: .none)
        }
    }
    
    public func addRow(at: [Int], animated: Bool = true) {
        UIView.setAnimationsEnabled(animated)
        self.decorator.tableView.beginUpdates()
        let paths = at.map { IndexPath(row:$0, section: self.sectionIndex) }
        self.decorator.tableView.insertRows(at: paths, with: UITableView.RowAnimation.fade)
        self.decorator.tableView.endUpdates()
        UIView.setAnimationsEnabled(true)
    }
    
    public func deleteRows(at: [Int], animated: Bool = true) {
        UIView.setAnimationsEnabled(animated)
        self.decorator.tableView.beginUpdates()
        let paths = at.map { IndexPath(row:$0, section: self.sectionIndex) }
        self.decorator.tableView.deleteRows(at: paths, with: .fade)
        self.decorator.tableView.endUpdates()
        UIView.setAnimationsEnabled(true)
    }
    
    public func updateTableView(animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
        UIView.setAnimationsEnabled(animated)
        self.decorator.tableView.performBatchUpdates(nil, completion: completion)
        UIView.setAnimationsEnabled(true)
    }
    
    public func scrollToRow(index: Int) {
        self.decorator.tableView.scrollToRow(at: IndexPath(row: index, section: self.sectionIndex), at: .top, animated: true)
    }
    
    public func reloadRow(index: Int) {
        self.decorator.tableView.reloadRows(at: [IndexPath(row: index, section: self.sectionIndex)], with: UITableView.RowAnimation.none)
    }
    
    public func reloadParentData(animated: Bool) {
        if animated {
            UIView.transition(
                with: decorator.tableView,
                duration: 0.3,
                options: .transitionCrossDissolve,
                animations: {
                    self.decorator.tableView.reloadData()
            }, completion: nil)
        }
        else {
            UIView.performWithoutAnimation {
                self.decorator.tableView.reloadData()
            }
        }
    }
    public func beginUpdates() {
        UIView.setAnimationsEnabled(false)
        self.decorator.tableView.beginUpdates()
    }
    public func endUpdates() {
        self.decorator.tableView.endUpdates()
        UIView.setAnimationsEnabled(true)
    }
    
    public func openTableSection() {
        var indexPaths: [IndexPath] = []
        for i in stride(from: 1, to: numberOfRows + 1, by: 1) {
            indexPaths.append(IndexPath(row: i, section: self.sectionIndex))
        }
        beginUpdates()
        self.decorator.tableView.insertRows(at: indexPaths, with: .none)
        endUpdates()
    }
    
    public func closeTableSection() {
        var indexPaths: [IndexPath] = []
        for i in stride(from: 1, to: numberOfRows + 1, by: 1) {
            indexPaths.append(IndexPath(row: i, section: self.sectionIndex))
        }
        beginUpdates()
        self.decorator.tableView.deleteRows(at: indexPaths, with: .top)
        endUpdates()
    }
    
    public var addToTableView: (() -> Void)?
    public var removeFromTableView: (() -> Void)?
    
    public func dequeueCell<T>(forReuseIdentifier reuseIdentifier: String) -> T {
        let cell = decorator.tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as! T
        return cell
    }
}
