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

    var isPrimary = true {
        didSet {
            switch isPrimary {
            case true:
                changeType(to: types[0])
            case false:
                changeType(to: types[1])
            }
        }
    }
    private var types: [ButtonType] = [.add, .cancel] {
        didSet {
            setup(from: types[0])
        }
    }

    // MARK: - init
    init() {
        super.init(frame: .zero)
        layoutContent(in: self)
        applyStyle()
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

    override func setTitleColor(_ color: UIColor?, for state: UIControl.State) {
        super.setTitleColor(color, for: state)
        label.textColor = color
    }

    private func setup(from type: ButtonType) {
        let config = UIImage.SymbolConfiguration.init(pointSize: 30)
        customImageView.image = UIImage(systemName: type.rawValue, withConfiguration: config)
        label.text = type.name
    }

    private func changeType(to type: ButtonType) {
        setup(from: type)
    }
}

extension Button {
    static var add: Button {
        let button = Button()
        button.types = [.add, .save]
        return button
    }

    static var convert: Button {
        let button = Button()
        button.types = [.convert, .cancel]
        return button
    }

    static var cancel: Button {
        let button = Button()
        button.types = [.cancel, .cancel]
        return button
    }
}

extension Button {
    private enum ButtonType: String {
        case add = "plus.circle"
        case cancel = "xmark.circle"
        case convert = "arrow.2.circlepath.circle"
        case save = "arrow.uturn.down.circle"

        var name: String {
            switch self {
            case .add: return "Add"
            case .cancel: return "Cancel"
            case .convert: return "Convert"
            case .save: return "Save"
            }
        }
    }
}
