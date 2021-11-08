//
//  CellHeaderFooterTableViewProxy.swift
//  RecipeBookUIKit
//
//  Created by Георгий on 02.11.2021.
//  Copyright © 2021 George Khaydenko. All rights reserved.
//

import UIKit

/// Used for CellHeaderFooterTableViewSection
class CellHeaderFooterTableViewProxy: BaseTableViewProxy {
    override var numberOfRows: Int {
        get {
            return section.numberOfRows + 2
        }
    }
    
    override func cell(forIndex index: Int) -> UITableViewCell {
        if index >= 1 && index <= section.numberOfRows {
            return section.cell(forIndex: index - 1)
        }
        else if index == 0 {
            return (section as! CellHeaderFooterTableViewSection).headerCell()
        }
        else {
            return (section as! CellHeaderFooterTableViewSection).footerCell()
        }
    }
    
    override func cellHeight(forIndex index: Int) -> CGFloat {
        if index >= 1 && index <= section.numberOfRows {
            return section.cellHeight(forIndex: index - 1)
        }
        else if index == 0 {
            return (section as! CellHeaderFooterTableViewSection).headerCellHeight()
        }
        else {
            return (section as! CellHeaderFooterTableViewSection).footerCellHeight()
        }
    }
    
    override func didSelectRow(atIndex index: Int) {
        if index > 0 && index <= section.numberOfRows {
            return section.didSelectRow(atIndex: index - 1)
        }
        else if index == 0 {
            (section as! CellHeaderFooterTableViewSection).didSelectHeader()
        }
        else {
            (section as! CellHeaderFooterTableViewSection).didSelectFooter()
        }
    }
}
