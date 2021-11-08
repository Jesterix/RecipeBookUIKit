//
//  HeaderedSectionWithBackground.swift
//  RecipeBookUIKit
//
//  Created by Георгий on 02.11.2021.
//  Copyright © 2021 George Khaydenko. All rights reserved.
//

import UIKit

public enum HeaderStyle {
    case withBackground
    case withoutBackground
}

open class HeaderedSectionWithBackground: CellHeaderFooterTableViewSection
{
    public var headerStyle: HeaderStyle!
    convenience init(headerStyle: HeaderStyle = .withBackground) {
        self.init()
        self.headerStyle = headerStyle
    }
    
    override open func cell(forIndex index: Int) -> CustomTableViewCell {
        let cell = cellView(forIndex: index)
        cell.backgroundColor = .clear
        guard let cellWithBG = cell as? TableCellWithBackground else { return cell }
        if isTableRoundedShadowEnabled() {
            cell.backgroundColor = .white
        } else {
            cell.backgroundColor = .clear
        }
        
        if numberOfRows == 1 {
            if headerStyle == .withoutBackground {
                cellWithBG.bgStyle = .single
            } else {
                cellWithBG.bgStyle = .bottom
            }
        } else if index == 0 && headerStyle == .withoutBackground {
            cellWithBG.bgStyle = .top
        } else if index == (numberOfRows - 1) {
            cellWithBG.bgStyle = .bottom
        } else {
            cellWithBG.bgStyle = .middle
        }
        return cellWithBG
    }
    
    open func cellView(forIndex index: Int) -> CustomTableViewCell {
        fatalError("Must override cellViewforIndex:")
    }
    
    override open func headerCell() -> CustomTableViewCell {
        let header = headerCellView()
        if headerStyle == .withoutBackground {
            header.bgStyle = .noBG
            header.separatorVisible = false
        } else if numberOfRows == 0 {
            header.bgStyle = .top
            header.separatorVisible = true
        } else {
            header.bgStyle = .top
            header.separatorVisible = false
        }
        if isTableRoundedShadowEnabled() {
            header.roundedCorners = getSectionIndex() == 0 ? [.layerMinXMinYCorner, .layerMaxXMinYCorner] : nil
            header.backgroundColor = .white
        } else {
            header.backgroundColor = .clear
        }
        return header
    }
    
    open func headerCellView() -> TableCellWithBackground {
        fatalError("Must override headerCellView:")
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
