//
//  DoubleButton.swift
//  RecipeBookUIKit
//
//  Created by Георгий on 28.09.2020.
//  Copyright © 2020 George Khaydenko. All rights reserved.
//

import UIKit
import SnapKit

public enum CustomControlState {
    case normal, extended
}

public enum CustomControlAlignment {
    case leading, center, trailing
}

final class DoubleButton: UIView {
    private var mainButton: Button
    private var secondaryButton: Button
    
    private var isAnimated: Bool
    private var alignment: CustomControlAlignment
    
    var state: CustomControlState = .normal {
        didSet {
            if isAnimated {
                UIView.animate(withDuration: 0.3, animations: {
                    self.layoutContentIfNeeded()
                })
            } else {
                self.layoutContentIfNeeded()
            }
        }
    }
    
    var didTapMain: (() -> Void)?
    var didTapSecondary: (() -> Void)?
    
    override var isUserInteractionEnabled: Bool {
        get {
            super.isUserInteractionEnabled
        }
        set {
            switch newValue {
            case true:
                alpha = 1
            case false:
                alpha = 0.5
            }
            super.isUserInteractionEnabled = newValue
        }
    }
    
    var isHalfEnabled: Bool {
        get {
            mainButton.isEnabled
        }
        set {
            mainButton.isEnabled = newValue
        }
    }
    
    init(
        animated: Bool = false,
        alignment: CustomControlAlignment = .leading,
        mainButton: Button = .add,
        secondaryButton: Button = .cancel
    ) {
        isAnimated = animated
        self.alignment = alignment
        self.mainButton = mainButton
        self.secondaryButton = secondaryButton
        super.init(frame: .zero)
        
        layoutContent(in: self)
        applyStyle()
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - layoutContent
    private func layoutContent(in view: UIView) {
        switch alignment {
        case .leading:
            view.addSubview(mainButton)
            mainButton.snp.makeConstraints { make in
                make.top.bottom.leading.equalTo(view)
            }
            
            view.addSubview(secondaryButton)
            secondaryButton.snp.makeConstraints { make in
                make.top.bottom.equalTo(view)
                make.leading.equalTo(mainButton.trailing).offset(5)
            }
        case .center:
            view.addSubview(mainButton)
            mainButton.snp.makeConstraints { make in
                make.top.bottom.centerX.equalTo(view)
            }
            
            view.addSubview(secondaryButton)
            secondaryButton.snp.makeConstraints { make in
                make.top.bottom.equalTo(view)
                make.leading.equalTo(view.snp.centerX).offset(2.5)
            }
        case .trailing:
            view.addSubview(secondaryButton)
            secondaryButton.snp.makeConstraints { make in
                make.top.bottom.trailing.equalTo(view)
            }
            
            view.addSubview(mainButton)
            mainButton.snp.makeConstraints { make in
                make.top.bottom.equalTo(view)
                make.trailing.equalTo(secondaryButton.leading).offset(-5)
            }
        }
    }
    
    private func layoutContentIfNeeded() {
        switch alignment {
        case .leading:
            secondaryButton.snp.remakeConstraints { make in
                make.top.bottom.equalTo(self)
                switch state {
                case .normal:
                    make.leading.equalTo(self)
                case .extended:
                    make.leading.equalTo(mainButton.trailing).offset(5)
                }
            }
            
        case .center:
            mainButton.snp.remakeConstraints { make in
                make.top.bottom.equalTo(self)
                switch state {
                case .normal:
                    make.top.bottom.centerX.equalTo(self)
                case .extended:
                    make.top.bottom.equalTo(self)
                    make.trailing.equalTo(self.snp.centerX).offset(-2.5)
                }
            }
            
        case .trailing:
            mainButton.snp.remakeConstraints { make in
                make.top.bottom.equalTo(self)
                switch state {
                case .normal:
                    make.trailing.equalTo(self)
                case .extended:
                    make.trailing.equalTo(secondaryButton.leading).offset(-5)
                }
            }
        }
        
        switch state {
        case .normal:
            secondaryButton.alpha = 0
        case .extended:
            secondaryButton.alpha = 1
        }
        layoutIfNeeded()
    }
    
    // MARK: - applyStyle
    private func applyStyle() {
        backgroundColor = .clear
    }
    
    // MARK: - setup
    private func setup() {
        mainButton.addTarget(
            self,
            action: #selector(tapMain),
            for: .touchUpInside)
        secondaryButton.addTarget(
            self,
            action: #selector(tapSecondary),
            for: .touchUpInside)
        layoutContentIfNeeded()
    }
    
    @objc private func tapMain() {
        stateToggle()
        didTapMain?()
    }
    
    @objc private func tapSecondary() {
        stateToggle()
        didTapSecondary?()
    }
    
    func stateToggle() {
        mainButton.isPrimary.toggle()
        state = mainButton.isPrimary ? .normal : .extended
    }
}
