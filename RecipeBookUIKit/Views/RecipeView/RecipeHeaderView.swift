//
//  RecipeHeaderView.swift
//  RecipeBookUIKit
//
//  Created by Георгий Хайденко on 21.07.2020.
//  Copyright © 2020 George Khaydenko. All rights reserved.
//

import UIKit
import SnapKit

final class RecipeHeaderView: StretchyHeaderView {
    var titleField: UITextField!
    var convertPortionsView: ConvertPortionsView!
    var addIngredientTextField: AddTextField!
    
    var tagCollectionView: UITextField!
    private let initialTagViewHeight: CGFloat = 44
    private var tagViewHeightConstraint: Constraint?
    
    init() {
        super.init(frame: .zero)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal override func setup() {
        layoutContent(in: self)
        applyStyle()
    }
    
    // MARK: - layoutContent
    private func layoutContent(in view: UIView) {
        convertPortionsView = layout(ConvertPortionsView()) { make in
            make.top.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.width.equalTo(175)
        }
        
        titleField = layout(UITextField()) { make in
            make.centerY.equalTo(convertPortionsView)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalTo(convertPortionsView.leading)
        }
        
        //TestField, change for collectionView
        tagCollectionView = layout(UITextField()) { make in
            make.top.equalTo(convertPortionsView.bottom)
            make.leading.trailing.equalToSuperview().inset(10)
            tagViewHeightConstraint = make.bottom.equalTo(convertPortionsView.bottom).offset(initialTagViewHeight).constraint
        }
        tagCollectionView.backgroundColor = .red.withAlphaComponent(0.5)
        tagCollectionView.text = "TESTTT!"
        //TestField, change for collectionView
        
        addIngredientTextField = layout(AddTextField()) { make in
            make.top.equalTo(tagCollectionView.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(40)
            make.bottom.equalToSuperview().inset(10)
        }
    }

    // MARK: - applyStyle
    private func applyStyle() {
//        colorScheme = .wideHeader
        backgroundColor = .clear
        
        titleField.font = .systemFont(ofSize: 21)
        titleField.textColor = .darkBrown
        titleField.autocorrectionType = .no
        titleField.addStandartToolbar()
        titleField.placeholder = "Recipe.Add.Title".localized()

        addIngredientTextField.setPlaceholder(text: "Recipe.Add.Placeholder".localized())
//        addIngredientTextField.setupGradientBackground()
    }
    
    override func layoutContent(stretchFactor: CGFloat, offset: CGFloat = 0) {
//        print("layoutContent with stretchFactor", stretchFactor)
//        guard contractedHeight > 0 else {
//            if let segment = dataTypeSegmentControl, segment.titles.count > 2, !isBarStatic {
//                //change segment background to fit segment clear back
////                segment.updateBackgroundItemColor(UIColor(displayP3Red: 0.961 + 0.039 * stretchFactor, green: 0.961 + 0.039 * stretchFactor, blue: 0.98 + 0.02 * stretchFactor, alpha: 1.0))
//            } else if let searchField = searchField, searchButton == nil, !isBarStatic || isBlurredOnScroll {
//                searchField.backgroundColor = UIColor(displayP3Red: 0.961 + 0.039 * stretchFactor, green: 0.961 + 0.039 * stretchFactor, blue: 0.98 + 0.02 * stretchFactor, alpha: 1.0)
//            }
//            return
//        }
//
//        if !isBarStatic {
        if stretchFactor == 0 && offset > initialTagViewHeight {
            tagCollectionView.alpha = 0
        } else if stretchFactor == 0 && offset >= 0 {
            tagCollectionView.alpha = 1 - (offset / initialTagViewHeight)
            tagViewHeightConstraint?.update(offset: (initialTagViewHeight) * (1 - (offset / initialTagViewHeight)))
        } else {
            tagCollectionView.alpha = 1
            tagViewHeightConstraint?.update(offset: initialTagViewHeight)
        }
        
//            if stretchFactor > 0.5 {
//                testField.alpha = 1 - (1 - stretchFactor) * 2
//            } else {
//                testField.alpha = 0
//            }
////
//            if stretchFactor < 0.5 {
//                titleField.alpha = 1 - stretchFactor * 2
//            } else {
//                titleField.alpha = 0
//            }
//        }
//
//        if dataTypeSegmentControl != nil {
//            lowerSectionHeightConstraint?.update(offset: (-initialSegmentedControlHeight) * stretchFactor)
//        } else if searchField != nil {
//            lowerSectionHeightConstraint?.update(offset: (-initialSearchFieldHeight) * stretchFactor)
//        }
    }
}
