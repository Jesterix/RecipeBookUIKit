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
    var addButton: DoubleButton!

    var convertButton: Button!

    var segmentedPickerView: LabeledSegmentedPicker!

    var convertView: ConvertView!

    var closeButton: UIButton!
    
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
        
        titleLabel = layout(UILabel(text: "Measure.Choose.Title".localized())) { make in
            make.top.equalTo(backBiew).offset(10)
            make.centerX.equalToSuperview()
        }

        addButton = layout(DoubleButton(animated: true, alignment: .leading)) { make in
            make.top.equalTo(titleLabel.bottom).offset(20)
            make.leading.equalTo(backBiew).offset(10)
            make.width.equalTo(150)
        }

        convertButton = layout(Button.convert) { make in
            make.top.equalTo(titleLabel.bottom).offset(20)
            make.centerX.equalTo(backBiew.trailing).offset(-40)
        }

        segmentedPickerView = layout(LabeledSegmentedPicker("Measure.Choose.Dimension".localized())) { make in
            make.top.equalTo(addButton.bottom)
            make.leading.equalTo(backBiew).offset(10)
            make.trailing.equalTo(backBiew).offset(-10)
            make.height.equalTo(70)
        }

        convertView = layout(ConvertView()) { make in
            make.top.equalTo(segmentedPickerView.bottom)
            make.leading.equalTo(backBiew).offset(10)
            make.trailing.equalTo(backBiew).offset(-10)
        }

        closeButton = layout(UIButton()) { make in
            make.top.greaterThanOrEqualTo(convertView.bottom)
            make.leading.trailing.equalTo(convertView)
            make.bottom.equalTo(backBiew.bottom).offset(-10)
        }
    }
    
    // MARK: - applyStyle
    private func applyStyle() {
        backgroundColor = .clear

//        let color = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
//        backBiew.backgroundColor = .honeyYellow
        backBiew.layer.cornerRadius = 25
        
        titleLabel.textColor = .darkBrown

        segmentedPickerView.data = Settings.defaultDimensions.map { $0.typeDescription.localized() }

        closeButton.layer.cornerRadius = 15
        closeButton.backgroundColor = .warmGray
        closeButton.setTitleColor(.darkBrown, for: .normal)
        closeButton.setTitle("Measure.Close.Button".localized(), for: .normal)
    }
    
    override func layoutSubviews() {
        backBiew.addGradient(startColor: .milkWhite, endColor: .honeyYellow, direction: .upRight)
        backBiew.layer.masksToBounds = true
        super.layoutSubviews()
    }
}

