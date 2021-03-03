//
//  DefaultSectionWithBackground.swift
//  RecipeBookUIKit
//
//  Created by Георгий on 03.03.2021.
//  Copyright © 2021 George Khaydenko. All rights reserved.
//

import UIKit

open class DefaultSectionWithBackground: CellFooteredTableViewSection
{
    override open func cell(forIndex index: Int) -> CustomTableViewCell {
        let cell = cellView(forIndex: index)
        guard let cellWithBG = cell as? TableCellWithBackground else { return cell }
        if numberOfRows == 1 {
            cellWithBG.bgStyle = .single
        } else if index == 0 {
            cellWithBG.bgStyle = .top
        } else if index == (numberOfRows - 1) {
            cellWithBG.bgStyle = .bottom
        } else {
            cellWithBG.bgStyle = .middle
        }
        if isTableRoundedShadowEnabled() {
            cell.roundedCorners = getSectionIndex() == 0 ? [.layerMinXMinYCorner, .layerMaxXMinYCorner] : nil
            cell.backgroundColor = .white
        } else {
            cell.backgroundColor = .clear
        }
        return cellWithBG
    }
    open func cellView(forIndex index: Int) -> CustomTableViewCell {
        fatalError("Must override cellViewforIndex:")
    }
    
    override open func footerCell() -> CustomTableViewCell {
        let cell = SpacerCell()
        if isTableRoundedShadowEnabled() {
            cell.roundedCorners = isLastVisibleSection() ? [.layerMinXMaxYCorner, .layerMaxXMaxYCorner] : nil
            cell.backgroundColor = .white
        } else {
            cell.backgroundColor = .clear
        }
        return cell
    }
    
    override open func footerCellHeight() -> CGFloat {
        return isSectionVisible ? 16 : 0
    }
}
