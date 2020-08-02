//
//  Button.swift
//  RecipeBookUIKit
//
//  Created by Георгий Хайденко on 02.08.2020.
//  Copyright © 2020 George Khaydenko. All rights reserved.
//

import UIKit

final class Button: UIButton {
    private var customImageView: UIImageView!
    private var label: UILabel!

    override func setTitleColor(_ color: UIColor?, for state: UIControl.State) {
        super.setTitleColor(color, for: state)
        label.textColor = color
    }

    init(_ type: RecipeBookUIKit.ButtonType) {
        super.init(frame: .zero)
        layoutContent(in: self)
        applyStyle()
        setup(from: type)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - layoutContent
    private func layoutContent(in view: UIView) {
        customImageView = layout(UIImageView()) { make in
            make.leading.top.trailing.equalToSuperview()
        }
        label = layout(UILabel()) { make in
            make.top.equalTo(customImageView.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }


    // MARK: - applyStyle
    private func applyStyle() {
        customImageView.contentMode = .scaleAspectFit
        label.textAlignment = .center
    }

    private func setup(from type: RecipeBookUIKit.ButtonType) {
        let config = UIImage.SymbolConfiguration.init(pointSize: 30)
        customImageView.image = UIImage(systemName: type.rawValue, withConfiguration: config)
        label.text = type.name
    }
}
