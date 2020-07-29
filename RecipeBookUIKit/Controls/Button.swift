//
//  Button.swift
//  RecipeBookUIKit
//
//  Created by Georgy Khaydenko on 28.07.2020.
//  Copyright © 2020 George Khaydenko. All rights reserved.
//

import UIKit

final class Button: UIView {
    var button: UIButton!
    private var label: UILabel!
    
    init(_ type: Button.ButtonType) {
        super.init(frame: .zero)
        layoutContent(in: self, buttonType: type)
        applyStyle()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - layoutContent
    private func layoutContent(in view: UIView, buttonType: ButtonType) {
        button = layout(UIButton()) { make in
            make.top.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        let config = UIImage.SymbolConfiguration.init(pointSize: 30)
        let image = UIImage(systemName: buttonType.rawValue, withConfiguration: config)
        button.setImage(image, for: .normal)
        
        label = layout(UILabel(text: buttonType.name)) { make in
            make.top.equalTo(button.bottom).offset(5)
            make.leading.equalToSuperview().offset(5)
            make.trailing.equalToSuperview()
            make.centerX.equalTo(button)
        }
    }

    // MARK: - applyStyle
    private func applyStyle() {
        button.tintColor = .black
    }
}

extension Button {
    enum ButtonType: String {
        case add = "plus.circle"
        case cancel = "xmark.circle"
        case convert = "arrow.2.circlepath.circle"
        case save = "arrow.uturn.down.circle"
        
        var name: String {
            switch self {
            case .add: return "Add"
            case .cancel: return "Cancel"
            case .convert: return "Convert"
            case .save: return "Save"
            }
        }
    }
    
    static var add: Button {
        .init(.add)
    }
    
    static var cancel: Button {
        .init(.cancel)
    }
    
    static var convert: Button {
        .init(.convert)
    }
    
    static var save: Button {
        .init(.save)
    }
}
