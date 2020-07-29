//
//  Button.swift
//  RecipeBookUIKit
//
//  Created by Georgy Khaydenko on 28.07.2020.
//  Copyright © 2020 George Khaydenko. All rights reserved.
//

import UIKit

final class Button: UIView {
    private var button: UIButton!
    private var label: UILabel!
    
    var buttonType: UIButton.ButtonType? = nil
    
    init(_ buttonType: UIButton.ButtonType? = nil) {
        super.init(frame: .zero)
        self.buttonType = buttonType
        layoutContent(in: self)
        applyStyle()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - layoutContent
    private func layoutContent(in view: UIView) {
        if buttonType == nil {
            buttonType = UIButton.ButtonType.contactAdd
        }
        
        guard let buttonType = buttonType else { return }
        
        button = layout(UIButton(type: buttonType)) { make in
            make.top.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        label = layout(UILabel(text: "Button name")) { make in
            make.top.equalTo(button.bottom).offset(5)
            make.leading.equalToSuperview().offset(5)
            make.trailing.equalToSuperview()
            make.centerX.equalTo(button)
        }
    }

    // MARK: - applyStyle
    private func applyStyle() {
        
    }
}

extension Button {
    static var add: Button {
        .init(.contactAdd)
    }
    
    static var cancel: Button {
        .init(.close)
    }
    
    static var convert: Button {
        .init(.infoLight)
    }
    
    static var save: Button {
        .init(.detailDisclosure)
    }
}
