//
//  CellFooteredTableViewSection.swift
//  RecipeBookUIKit
//
//  Created by Георгий on 03.03.2021.
//  Copyright © 2021 George Khaydenko. All rights reserved.
//

import UIKit

open class CellFooteredTableViewSection: BaseTableViewSection {
    
    private let cellFooteredProxy = CellFooteredTableViewProxy()
    
    public override init() {}
    
    override var proxy: BaseTableViewProxy {
        get {
            cellFooteredProxy.section = self
            return cellFooteredProxy
        }
    }
    
    open func footerCell() -> UITableViewCell {
        fatalError("Derived class must override 'footerCell'")
    }
    
    open func footerCellHeight() -> CGFloat {
        fatalError("Derived class must override 'footerCellHeight'")
    }
}
