//
//  ButtonView.swift
//  RecipeBookUIKit
//
//  Created by Georgy Khaydenko on 28.07.2020.
//  Copyright © 2020 George Khaydenko. All rights reserved.
//

import UIKit

final class ButtonView: UIView {
    private var primaryButtonTypes: [Button.ButtonType] = []
    private var secondaryButtonTypes: [Button.ButtonType] = []
    private var buttons: [Button]!
    private var secondaryButtons: [Button]!
    
    init(
        _ primaryButtons: [Button.ButtonType],
        secondaryButtons: [Button.ButtonType] = []
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
        secondaryButtons.forEach { $0.isHidden = true }
    }
    
    private func layout(
        buttons: [Button.ButtonType],
        for buttonArray: inout [Button]
    ) {
        for (i, _) in buttons.enumerated() {
            let newButton = layout(Button(buttons[i])) { make in
                make.top.bottom.equalToSuperview()
                switch buttonArray.last {
                case .none: make.leading.equalToSuperview()
                case .some(let last): make.leading.equalTo(last.trailing).offset(5)
                }
            }
            newButton.tag = i
            buttonArray.append(newButton)
        }
        
        if buttons.count > 1 {
            buttonArray.last?.snp.makeConstraints { make in
                make.trailing.equalToSuperview()
            }
        }
    }
    
    private func setupActions() {
        guard buttons.count > 0, secondaryButtons.count > 0 else {
            return
        }
        
        buttons.forEach {
            $0.button.addTarget(
                self,
                action: #selector(toggleVisibility),
                for: .touchUpInside)
        }
        
        secondaryButtons.forEach {
            $0.button.addTarget(
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
