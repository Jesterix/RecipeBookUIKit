//
//  RecipeTextViewCell.swift
//  RecipeBookUIKit
//
//  Created by Георгий on 13.03.2021.
//  Copyright © 2021 George Khaydenko. All rights reserved.
//

import UIKit

final class RecipeTextViewCell: CustomTableViewCell {
    static var reuseID = "TextViewCell"
    
    public var textView: TextView! {
        didSet {
            contentView.addSubview(textView)
            layoutContent(in: self.contentView)
        }
    }
    
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        applyStyle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - layoutContent
    private func layoutContent(in view: UIView) {
        textView.snp.remakeConstraints { make in
            make.edges.equalToSuperview().inset(5)
            make.height.greaterThanOrEqualTo(100)
        }
    }
    
    // MARK: - applyStyle
    private func applyStyle() {
        backgroundColor = .white
        selectionStyle = .none
    }
}

