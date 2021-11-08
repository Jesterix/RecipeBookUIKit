//
//  CellHeaderFooterTableViewSection.swift
//  RecipeBookUIKit
//
//  Created by Георгий on 02.11.2021.
//  Copyright © 2021 George Khaydenko. All rights reserved.
//

import UIKit

open class CellHeaderFooterTableViewSection: BaseTableViewSection
{
    public override init() {}
    
    /// Used proxy
    private let cellHeaderFooterProxy = CellHeaderFooterTableViewProxy()
    
    override var proxy: BaseTableViewProxy {
        get {
            cellHeaderFooterProxy.section = self
            return cellHeaderFooterProxy
        }
    }
    
    open func headerCell() -> CustomTableViewCell {
        fatalError("Must override headerCell")
    }
    
    open func headerCellHeight() -> CGFloat {
        fatalError("Must override headerHeight")
    }
    
    open func footerCell() -> CustomTableViewCell {
        fatalError("Must override footerCell")
    }
    
    open func footerCellHeight() -> CGFloat {
        fatalError("Must override footerHeight")
    }
    
    open func didSelectHeader() {
    }
    
    open func didSelectFooter() {
    }
}
