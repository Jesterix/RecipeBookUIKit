//
//  PlaceholderView.swift
//  RecipeBookUIKit
//
//  Created by Георгий on 25.09.2020.
//  Copyright © 2020 George Khaydenko. All rights reserved.
//

import UIKit

final class PlaceholderView: UIView {
    private var placeholder: UILabel!
    
    init(text: String = "") {
        super.init(frame: .zero)
        layoutContent(in: self)
        applyStyle()
        setPaceholderText(text)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - layoutContent
    private func layoutContent(in view: UIView) {
        placeholder = layout(UILabel()) { make in
            make.leading.trailing.equalToSuperview()
            make.center.equalToSuperview()
        }
    }
    
    private func setPaceholderText(_ text: String) {
        placeholder.text = text
    }
    
    // MARK: - applyStyle
    private func applyStyle() {
        backgroundColor = .milkWhite
        
        placeholder.textColor = .coldBrown
        placeholder.textAlignment = .center
        placeholder.numberOfLines = 0
    }
}
