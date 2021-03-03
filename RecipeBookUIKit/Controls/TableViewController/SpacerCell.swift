//
//  SpacerCell.swift
//  RecipeBookUIKit
//
//  Created by Георгий on 03.03.2021.
//  Copyright © 2021 George Khaydenko. All rights reserved.
//

import UIKit

class SpacerCell: TableCellWithBackground {
    private var spaceView = UIView()
    
    convenience init(height: CGFloat) {
        self.init()
        self.height = height
        layoutContent()
    }
    
    public var height: CGFloat = 16
    
    override func setupSubviews() {
        selectionStyle = .none
        
        mainContentView.addSubview(spaceView)
        layoutContent()
        separatorVisible = false
    }
    
    private func layoutContent() {
        spaceView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(height)
        }
    }
}
