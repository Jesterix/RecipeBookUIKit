//
//  ButtonView.swift
//  RecipeBookUIKit
//
//  Created by Georgy Khaydenko on 28.07.2020.
//  Copyright © 2020 George Khaydenko. All rights reserved.
//

import UIKit

final class ButtonView: UIView {
    private var primaryButtonTypes: [ButtonType] = []
    private var secondaryButtonTypes: [ButtonType] = []
    private var buttons: [UIButton]!
    private var secondaryButtons: [UIButton]!
    
    init(
        _ primaryButtons: [ButtonType],
        secondaryButtons: [ButtonType] = []
    ) {
        super.init(frame: .zero)
        self.primaryButtonTypes = primaryButtons
        self.secondaryButtonTypes = secondaryButtons
        layoutContent(in: self)
        applyStyle()
        setupActions()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - layoutContent
    private func layoutContent(in view: UIView) {
        buttons = []
        secondaryButtons = []
        
        layout(buttons: primaryButtonTypes, for: &buttons)
        layout(buttons: secondaryButtonTypes, for: &secondaryButtons)
    }
    
    // MARK: - applyStyle
    private func applyStyle() {
        buttons.forEach {
            $0.tintColor = .red
            $0.setTitleColor(.red, for: .normal)
        }
        
        secondaryButtons.forEach {
            $0.isHidden = true
            $0.tintColor = .red
            $0.setTitleColor(.red, for: .normal)
        }
    }
    
    private func layout(
        buttons: [ButtonType],
        for buttonArray: inout [UIButton]
    ) {
        for (i, _) in buttons.enumerated() {
            let newButton = layout(UIButton()) { make in
                make.top.bottom.equalToSuperview()
                switch buttonArray.last {
                case .none: make.leading.equalToSuperview()
                case .some(let last): make.leading.equalTo(last.trailing).offset(5)
                }
            }
            let config = UIImage.SymbolConfiguration.init(pointSize: 30)
            let image = UIImage(systemName: buttons[i].rawValue, withConfiguration: config)
            
            newButton.setImage(image, for: .normal)
            newButton.setTitle(buttons[i].name, for: .normal)
            newButton.layoutVertically()
            
            newButton.tag = i
            buttonArray.append(newButton)
        }
        
//        if buttons.count > 1 {
            buttonArray.last?.snp.makeConstraints { make in
                make.trailing.equalToSuperview()
            }
//        }
    }
    
    private func setupActions() {
        guard buttons.count > 0, secondaryButtons.count > 0 else {
            return
        }
        
        buttons.forEach {
            $0.addTarget(
                self,
                action: #selector(toggleVisibility),
                for: .touchUpInside)
        }
        
        secondaryButtons.forEach {
            $0.addTarget(
                self,
                action: #selector(toggleVisibility),
                for: .touchUpInside)
        }
    }
    
    @objc private func toggleVisibility() {
        buttons.forEach { $0.isHidden.toggle() }
        secondaryButtons.forEach { $0.isHidden.toggle() }
    }
}

extension ButtonView {
    static var add: ButtonView {
        .init([.add], secondaryButtons: [.save, .cancel])
    }
    
    static var convert: ButtonView {
        .init([.convert], secondaryButtons: [.cancel])
    }
}

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
