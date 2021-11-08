//
//  HeaderLabelCell.swift
//  RecipeBookUIKit
//
//  Created by Георгий on 02.11.2021.
//  Copyright © 2021 George Khaydenko. All rights reserved.
//


import UIKit
import SnapKit

class HeaderLabelCell: TableCellWithBackground {
    static var reuseID = "HeaderLabelCell"
    
    class var preferredHeight: CGFloat {
        return 48
    }
    
    private var headerLabel = UILabel()
    private var upperSeparator = UIView()
    private var topConstraint: Constraint?
    
    public var labelText = "" {
        didSet {
            headerLabel.attributedText = NSAttributedString(
                string: labelText,
                attributes: Theme.textAttributes)
        }
    }
    public var upperSeparatorVisible: Bool = false {
        didSet {
            upperSeparator.isHidden = !upperSeparatorVisible
        }
    }
    
    override func setupSubviews() {
        selectionStyle = .none
        
        mainContentView.addSubview(headerLabel)
        headerLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(8)
            topConstraint = make.top.equalToSuperview().offset(16).constraint
        }
        
        addSubview(upperSeparator)
        upperSeparator.backgroundColor = UIColor.darkBrown.withAlphaComponent(0.1)
        upperSeparator.isHidden = true
        upperSeparator.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    public func setTopConstraintEqualTo(_ value: CGFloat) {
        topConstraint?.update(offset: value)
    }
}
