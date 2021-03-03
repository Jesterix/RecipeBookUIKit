//
//  CustomTableViewCell.swift
//  RecipeBookUIKit
//
//  Created by Георгий on 03.03.2021.
//  Copyright © 2021 George Khaydenko. All rights reserved.
//

/**
 * Slightly simplifies creating custom table view cells
 */

import UIKit

open class CustomTableViewCell: UITableViewCell {
    public var roundedCorners: CACornerMask? = nil
    /// Override
    open func setup() {
//        fatalError("Must override setup")
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        removeSubviews()
        setup()
    }
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        removeSubviews()
        setup()
    }
    
    /// Override
    open var preferredHeight: CGFloat = 0//{
//        get {
//            fatalError("Must override preferredHeight")
//        }
//    }
    
    /// Kills all default content subviews
    private func removeSubviews() {
        contentView.subviews.forEach { $0.removeFromSuperview() }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        if let roundedCorners = roundedCorners {
            layer.cornerRadius = 12
            layer.maskedCorners = roundedCorners
        } else {
            layer.cornerRadius = 0
            layer.maskedCorners = []
        }
    }
}

open class TableViewHeaderFooterView: UITableViewHeaderFooterView {
    /// Override
    open func setup() {
        fatalError("Must override setup")
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        removeSubviews()
        setup()
    }
    
    public override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        removeSubviews()
        setup()
    }
    
    /// Kills all default content subviews
    private func removeSubviews() {
        contentView.subviews.forEach { $0.removeFromSuperview() }
    }
}
