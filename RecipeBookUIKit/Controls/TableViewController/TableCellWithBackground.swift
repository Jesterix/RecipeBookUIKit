//
//  TableCellWithBackground.swift
//  RecipeBookUIKit
//
//  Created by Георгий on 03.03.2021.
//  Copyright © 2021 George Khaydenko. All rights reserved.
//

import UIKit
import SnapKit

public enum BackgroundStyle {
    case noBG
    case top
    case middle
    case bottom
    case single
}

public enum InnerCellStyle {
    case top
    case middle
    case bottom
    case automatic
}

open class TableCellWithBackground: CustomTableViewCell {
    
    private let separatorView = UIView()
    public let mainContentView = MainContentView()
    public var bgColor = UIColor.white {
        didSet {
            mainContentView.backgroundColor = bgColor
        }
    }
    public var bgStyle: BackgroundStyle = .noBG {
        didSet {
            mainContentView.bgStyle = bgStyle
        }
    }
    public var separatorVisible = true
    public var innerCellStyle: InnerCellStyle? {
        didSet {
            guard innerCellStyle != nil else { return }
            mainContentView.innerCellStyle = innerCellStyle
            setupInnerCell()
        }
    }
    
    /// Override
    override open func setup() {
        self.backgroundColor = .clear
        
        contentView.addSubview(mainContentView)
        mainContentView.backgroundColor = bgColor
        mainContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        mainContentView.addSubview(separatorView)
        separatorView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        separatorView.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
        setupSubviews()
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        separatorView.isHidden = (bgStyle == .bottom || bgStyle == .single) || !separatorVisible
        
        if innerCellStyle == nil {
            // For header view without background hide the rounded background with shadow
            mainContentView.backgroundColor = bgStyle == .noBG ? .clear : bgColor
        }
        
        mainContentView.layoutSubviews()
    }
    
    open func setupSubviews() {
        
        fatalError("Must override setup")
    }
    
    private func setupInnerCell() {
        mainContentView.snp.remakeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
        }
        contentView.backgroundColor = .white
        mainContentView.backgroundColor = .lightGray
    }
}

public class MainContentView: UIView {
    public var bgStyle: BackgroundStyle = .noBG
    public var innerCellStyle: InnerCellStyle?
    public let cornerRadius: CGFloat = 12
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = cornerRadius
        guard let innerCellStyle = innerCellStyle else {
            automaticallySetCornerRadius()
            return
        }
        if innerCellStyle == .automatic {
            automaticallySetCornerRadius()
        } else {
            if innerCellStyle == .top {
                self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            } else if innerCellStyle == .bottom {
                self.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            } else if innerCellStyle == .middle {
                self.layer.maskedCorners = []
                self.layer.cornerRadius = 0
            }
        }
    }
        
    private func automaticallySetCornerRadius() {
        if bgStyle == .top {
            self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else if bgStyle == .bottom {
            self.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        } else if bgStyle == .single {
            self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner,
                                        .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        } else {
            self.layer.maskedCorners = []
            self.layer.cornerRadius = 0
        }
    }
}
