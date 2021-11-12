//
//  TagCell.swift
//  RecipeBookUIKit
//
//  Created by Георгий on 12.11.2021.
//  Copyright © 2021 George Khaydenko. All rights reserved.
//

import UIKit

public class TagCell: UICollectionViewCell {
    private var backView: UIView!
    private var label: UILabel!
    private var holeView: UIView!
    
    public var text = "" {
        didSet {
            label.attributedText = NSAttributedString(string: text, attributes: Theme.tagTextAttributes)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutContent(in: self)
        applyStyle()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        layoutContent(in: self)
        applyStyle()
    }
    
    private func layoutContent(in: UIView) {
        backView = layout(UIView()) { make in
            make.top.equalToSuperview().offset(10)
            make.leading.trailing.bottom.equalToSuperview().priority(1000)
        }
        holeView = backView.layout(UIView()) { make in
            make.centerY.equalTo(backView)
            make.leading.equalToSuperview().offset(3)
            make.height.width.equalTo(5)
        }
        label = backView.layout(UILabel()) { make in
            make.bottom.equalToSuperview().inset(3)
            make.top.equalToSuperview().inset(3)
            make.trailing.equalToSuperview().inset(5)
            make.leading.equalTo(holeView.trailing).offset(3)
        }
    }
    
    private func applyStyle() {
        backView.backgroundColor = .honeyYellow.withAlphaComponent(0.7)
        holeView.backgroundColor = .milkWhite
    }
    
    public override func layoutSubviews() {
        UIView.performWithoutAnimation {
            label.layoutSubviews()
            super.layoutSubviews()
            backView.layer.cornerRadius = 8
            holeView.layer.cornerRadius = 2
        }
    }
}
