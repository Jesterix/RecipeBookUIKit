//
//  CellFooteredTableViewProxy.swift
//  RecipeBookUIKit
//
//  Created by Георгий on 03.03.2021.
//  Copyright © 2021 George Khaydenko. All rights reserved.
//

import UIKit

class CellFooteredTableViewProxy: BaseTableViewProxy {
    
    override var numberOfRows: Int {
        get {
            return section.numberOfRows + 1
        }
    }
    
    override func cell(forIndex index: Int) -> UITableViewCell {
        if index < section.numberOfRows {
            return section.cell(forIndex: index)
        }
        else {
            return (section as! CellFooteredTableViewSection).footerCell()
        }
    }
    
    override func cellHeight(forIndex index: Int) -> CGFloat {
        if index < section.numberOfRows {
            return section.cellHeight(forIndex: index)
        }
        else {
            return (section as! CellFooteredTableViewSection).footerCellHeight()
        }
    }
    
    override func didSelectRow(atIndex index: Int) {
        if index < section.numberOfRows {
            return section.didSelectRow(atIndex: index)
        }
    }
}
