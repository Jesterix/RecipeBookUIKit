//
//  PlaceholderCell.swift
//  RecipeBookUIKit
//
//  Created by Георгий on 13.03.2021.
//  Copyright © 2021 George Khaydenko. All rights reserved.
//

import UIKit

class PlaceholderCell: TableCellWithBackground {
    static var reuseID = "PlaceholderCell"
    private var emptyView = EmptyView()
    
    convenience init(height: CGFloat) {
        self.init()
//        self.height = height
        layoutContent()
    }
    
//    public var height: CGFloat = 16
    
    public func configureEmptyView(image: UIImage, title: String, description: String, actionTitle: String? = nil, action: (() -> Void)? = nil) {
            emptyView.image = image
            emptyView.title = title
            emptyView.descriptionText = description
    //        emptyView.actionTitle = actionTitle
    //        emptyView.action = action
        }
    
    override func setupSubviews() {
        selectionStyle = .none
        
        mainContentView.addSubview(emptyView)
        layoutContent()
        separatorVisible = false
    }
    
    private func layoutContent() {
        emptyView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
//            make.height.equalTo(height)
        }
    }
}
