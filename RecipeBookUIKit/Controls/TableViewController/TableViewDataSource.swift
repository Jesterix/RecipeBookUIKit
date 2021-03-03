//
//  TableViewDataSource.swift
//  RecipeBookUIKit
//
//  Created by Георгий on 03.03.2021.
//  Copyright © 2021 George Khaydenko. All rights reserved.
//

/**
 * TableView delegate & datasource
 */

import UIKit

@objc public protocol RowEditActionsDelegate {
    @objc func editActionsConfigForRowAt(_ indexPath: IndexPath) -> UISwipeActionsConfiguration?
}

final class TableViewDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    var sections = [BaseTableViewSection]()
    var didScrollToOffset = Event<Double>()
    var scrollWillStopAt = Event<Double>()
    weak public var delegate: RowEditActionsDelegate?
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].proxy.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return sections[indexPath.section].proxy.cell(forIndex: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.estimatedRowHeight > 0 {
            return UITableView.automaticDimension
        } else {
            return sections[indexPath.section].proxy.cellHeight(forIndex: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableView(tableView, heightForRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return sections[section].proxy.headerView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let height = sections[section].proxy.headerHeight() {
            return height
        }
        else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        sections[indexPath.section].proxy.willDisplayCell(atIndex: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        sections[section].proxy.setupHeaderView(headerView: view)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return sections[section].proxy.footerView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if let height = sections[section].proxy.footerHeight() {
            return height
        }
        else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        if let view = view as? UITableViewHeaderFooterView {
            sections[section].proxy.setupFooterView(footerView: view)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sections[indexPath.section].proxy.didSelectRow(atIndex: indexPath.row)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        didScrollToOffset.raise(data: Double(scrollView.contentOffset.y))
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        // Where the scroll will end (vertically)
        let offSetY = targetContentOffset.pointee.y

        scrollWillStopAt.raise(data: Double(offSetY))
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return delegate?.editActionsConfigForRowAt(indexPath)
    }
    
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        let cell = sections[indexPath.section].proxy.cell(forIndex: indexPath.row)
        cell.contentView.clipsToBounds = true
        return
    }
}
