//
//  EmptyView.swift
//  RecipeBookUIKit
//
//  Created by Георгий on 12.03.2021.
//  Copyright © 2021 George Khaydenko. All rights reserved.
//

import UIKit

final class EmptyView: UIView {
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
//    private let actionButton = T2Button()
    
    public var image: UIImage! {
        didSet {
            imageView.image = image
        }
    }
    public var title: String! {
        didSet {
            titleLabel.attributedText = NSAttributedString(string: title, attributes: Theme.placeholderTitleTextAttributes)
        }
    }
    public var descriptionText: String! {
        didSet {
            subtitleLabel.attributedText = NSAttributedString(string: descriptionText, attributes: Theme.textAttributes)
        }
    }
//    public var actionTitle: String! {
//        didSet {
//            actionButton.setTitle(actionTitle, for: .normal)
//        }
//    }
//    public var action: (() -> Void)? {
//        didSet {
//            if action != nil {
//                actionButton.isHidden = false
//                actionButton.addControlEvent(.touchUpInside) { [ weak self] in
//                    self?.action?()
//                }
//            }
//        }
//    }
    
    public convenience init() {
        self.init(frame: CGRect.zero)
        setup()
    }
    
    func setup() {
//        addSubview(actionButton)
//        actionButton.isHidden = true
//        actionButton.snp.makeConstraints { make in
//            make.bottom.equalToSuperview().offset(-112)
//            make.centerX.equalToSuperview()
//            make.left.right.equalToSuperview().inset(40)
//            make.height.equalTo(48)
//        }
        
        addSubview(titleLabel)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.snp.makeConstraints { make in
//            make.bottom.equalTo(subtitleLabel.snp.top).offset(-16)
//            make.left.right.equalToSuperview().inset(32)
//            make.height.equalTo(65)
            make.top.equalToSuperview().inset(8)
            make.centerX.equalToSuperview()
            make.height.equalTo(48)
        }
        
        addSubview(subtitleLabel)
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 0
        subtitleLabel.snp.makeConstraints { make in
//            make.bottom.equalTo(actionButton.snp.top)
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.bottom.equalToSuperview().inset(4)
            make.leading.trailing.equalToSuperview().inset(32)
//            make.height.equalTo(24)
//            make.height.equalTo(130)
        }
        
        addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(4)
//            make.top.equalToSuperview().offset(4)
//            make.left.right.equalToSuperview().inset(64)
//            make.bottom.equalTo(titleLabel.snp.top).offset(-16)
        }
        
    }
}
