//
//  MeasureView.swift
//  RecipeBookUIKit
//
//  Created by Georgy Khaydenko on 28.07.2020.
//  Copyright © 2020 George Khaydenko. All rights reserved.
//

import UIKit

final class MeasureView: UIView {
    private var backBiew: UIView!
    private var titleLabel: UILabel!
    private var buttonView: ButtonView!
    
    
    init() {
        super.init(frame: .zero)
        layoutContent(in: self)
        applyStyle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - layoutContent
    private func layoutContent(in view: UIView) {
        layoutBlur(in: view, intensity: 0.15)
        
        backBiew = layout(UIView()) { make in
            make.top.leading.equalTo(safeArea).offset(40)
            make.bottom.trailing.equalTo(safeArea).offset(-40)
        }
        
        titleLabel = layout(UILabel(text: "Choose measurement")) { make in
            make.top.equalTo(backBiew).offset(10)
            make.centerX.equalToSuperview()
        }
        
        let buttons: [UIButton.ButtonType] = [.contactAdd]
        let secondaryButtons: [UIButton.ButtonType] = [.detailDisclosure, .close]
        
        
        buttonView = layout(ButtonView(buttons, secondaryButtons: secondaryButtons)) { make in
            make.top.equalTo(titleLabel.bottom).offset(20)
            make.leading.equalTo(backBiew)
        }
        
    }
    
    // MARK: - applyStyle
    private func applyStyle() {
        backgroundColor = .clear
        
        let color = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        backBiew.backgroundColor = color
        backBiew.layer.cornerRadius = 25
    }
}


