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
    
    var tagCollectionView: HorizontalCollectionView!
    private let initialTagViewHeight: CGFloat = DefaultConstants.tagViewHeight.rawValue
    
    private var tagViewHeightConstraint: Constraint?
    private var isExpanded = true
    private var isAnimating = false
    
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
        
        //TODO: make it configurable
        tagCollectionView = layout(HorizontalCollectionView()) { make in
            make.top.equalTo(convertPortionsView.bottom)
            make.leading.trailing.equalToSuperview().inset(10)
            tagViewHeightConstraint = make.height.equalTo(initialTagViewHeight).constraint
        }
        tagCollectionView.add("dinner")
        tagCollectionView.add("milk delight breakfast pleasure")
        tagCollectionView.add("")
        tagCollectionView.add("so1")
        tagCollectionView.reloadData()
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
        backgroundColor = .clear
        
        titleField.font = .systemFont(ofSize: 21)
        titleField.textColor = .darkBrown
        titleField.autocorrectionType = .no
        titleField.addStandartToolbar()
        titleField.placeholder = "Recipe.Add.Title".localized()

        addIngredientTextField.setPlaceholder(text: "Recipe.Add.Placeholder".localized())
    }
    
    override func layoutContent(stretchFactor: CGFloat, offset: CGFloat = 0) {
//        //FOR ANIMATION
        if stretchFactor > 0.9 {
            animateShowingTagCollectionView()
        } else if offset > initialTagViewHeight * 2.5 {
            animateHidingTagCollectionView()
        }
        
//        //FOR MOVING
//        if stretchFactor == 0 && offset > initialTagViewHeight {
//            tagCollectionView.alpha = 0
//        } else if stretchFactor == 0 && offset >= 0 {
//            tagCollectionView.alpha = 1 - (offset / initialTagViewHeight)
//            tagViewHeightConstraint?.update(offset: (initialTagViewHeight) * (1 - (offset / initialTagViewHeight)))
//        } else {
//            tagCollectionView.alpha = 1
//            tagViewHeightConstraint?.update(offset: initialTagViewHeight)
//        }
        
        //FOR MOVING with DELAY
//        let modifiedOffset = offset - (2 * initialTagViewHeight)
//        if stretchFactor == 0 && modifiedOffset >= 0 {
//            tagCollectionView.alpha = 1 - (modifiedOffset / initialTagViewHeight)
//            tagViewHeightConstraint?.update(offset: (initialTagViewHeight) * (1 - (modifiedOffset / initialTagViewHeight)))
//        } else {
//            tagCollectionView.alpha = 1
//            tagViewHeightConstraint?.update(offset: initialTagViewHeight)
//        }
    }
    
    private func animateShowingTagCollectionView() {
        if !isExpanded && !isAnimating {
            isAnimating.toggle()
            self.tagViewHeightConstraint?.update(offset: self.initialTagViewHeight)
            UIView.animate(
                withDuration: 0.3,
                delay: 0,
                options: .curveEaseInOut,
                animations: {
                    self.superview?.superview?.layoutIfNeeded()
                    UIView.animate(withDuration: 0.1, delay: 0.2) {
                        self.tagCollectionView.alpha = 1
                    }
                },
                completion: { _ in
                    self.isExpanded.toggle()
                    self.isAnimating.toggle()
                })
        }
    }
    
    private func animateHidingTagCollectionView() {
        if isExpanded && !isAnimating {
            isAnimating.toggle()
            self.tagViewHeightConstraint?.update(offset: 0)
            UIView.animate(
                withDuration: 0.4,
                delay: 0,
                options: .curveEaseInOut,
                animations: {
                    self.tagCollectionView.alpha = 0
                    self.superview?.superview?.layoutIfNeeded()
                },
                completion: { _ in
                    self.isExpanded.toggle()
                    self.isAnimating.toggle()
                })
        }
    }
}
