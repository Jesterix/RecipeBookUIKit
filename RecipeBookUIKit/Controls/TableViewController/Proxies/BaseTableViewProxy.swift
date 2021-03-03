//
//  BaseTableViewProxy.swift
//  RecipeBookUIKit
//
//  Created by Георгий on 03.03.2021.
//  Copyright © 2021 George Khaydenko. All rights reserved.
//

import UIKit

/// Used for BaseTableViewSection
class BaseTableViewProxy {
    weak var section: BaseTableViewSection!
    
    var numberOfRows: Int {
        get {
            return section.numberOfRows
        }
    }
    
    func cell(forIndex index: Int) -> UITableViewCell {
        return section.cell(forIndex: index)
    }
    
    func cellHeight(forIndex index: Int) -> CGFloat {
        return section.cellHeight(forIndex: index)
    }
    
    func didSelectRow(atIndex index: Int) {
        section.didSelectRow(atIndex: index)
    }
    
    func willDisplayCell(atIndex index: Int) {
        section.willDisplayCell(atIndex: index)
    }
    
    func headerView() -> UIView? {
        return nil
    }
    
    func headerHeight() -> CGFloat? {
        return 0
    }
    
    func footerView() -> UIView? {
        return nil
    }
    
    func footerHeight() -> CGFloat? {
        return 0
    }
    
    func setupHeaderView<T>(headerView: T) where T: UIView {
    }
    
    func setupFooterView<T>(footerView: T) where T: UIView {
    }
}
