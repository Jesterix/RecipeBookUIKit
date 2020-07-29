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
    private var addButtonView: ButtonView!
    private var convertButtonView: ButtonView!
    
    var testBut: UIButton!
    
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
        

        addButtonView = layout(ButtonView.add) { make in
            make.top.equalTo(titleLabel.bottom).offset(20)
            make.leading.equalTo(backBiew).offset(10)
        }

        convertButtonView = layout(ButtonView.convert) { make in
            make.top.equalTo(titleLabel.bottom).offset(20)
            make.trailing.equalTo(backBiew).offset(-10)
        }
        
        let type: ButtonType = .add
        let config = UIImage.SymbolConfiguration.init(pointSize: 30)
        let image = UIImage(systemName: type.rawValue, withConfiguration: config)
        
        testBut = layout(UIButton()) { make in
            make.center.equalToSuperview()
        }
        
        testBut.setImage(image, for: .normal)
        testBut.setTitle(type.name, for: .normal)
        testBut.layoutVertically()
        testBut.tintColor = .red
        testBut.setTitleColor(.red, for: .normal)
    }
    
    // MARK: - applyStyle
    private func applyStyle() {
        backgroundColor = .clear
        
        let color = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        backBiew.backgroundColor = color
        backBiew.layer.cornerRadius = 25
    }
}


