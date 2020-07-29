//
//  ButtonView.swift
//  RecipeBookUIKit
//
//  Created by Georgy Khaydenko on 28.07.2020.
//  Copyright © 2020 George Khaydenko. All rights reserved.
//

import UIKit

final class ButtonView: UIView {
    private var buttons: [UIButton.ButtonType] = []
    private var actions: [Button]!
    
    init(_ buttons: [UIButton.ButtonType]) {
        super.init(frame: .zero)
        self.buttons = buttons
        layoutContent(in: self)
        applyStyle()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - layoutContent
    private func layoutContent(in view: UIView) {
        actions = []
        
        for (i, _) in buttons.enumerated() {
            let newAction = layout(Button(buttons[i])) { make in
                make.top.bottom.equalToSuperview()
                switch actions.last {
                case .none: make.leading.equalToSuperview()
                case .some(let last): make.leading.equalTo(last.trailing).offset(5)
                }
            }
            newAction.tag = i
            actions.append(newAction)
        }
        
        actions.last?.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
        }

    }

    // MARK: - applyStyle
    private func applyStyle() {
        
    }
}

//var currencyButtons: [NewWalletItemView]!
//let items: [CryptoCurrency] = [
//     .bitcoin,
//     .litecoin,
//     .ethereum
// ]
//
// override init() {
//     super.init()
//     layoutContent(in: self)
//     applyStyle()
// }
//
// required init?(coder aDecoder: NSCoder) {
//     fatalError("init(coder:) has not been implemented")
// }
//
// func layoutContent(in view: UIView) {
//     currencyButtons = []
//
//     actionControl = view.layout(ASegmentedControl())
//     { make in
//         make.height.equalTo(32)
//         make.top.equalTo(safeArea).offset(11)
//         make.leading.equalToSuperview().offset(16)
//         make.trailing.equalToSuperview().offset(-16)
//     }
//
//     currencyButtonsView = view.layout(UIView()) { make in
//         make.top.equalTo(actionControl.bottom).offset(34)
//         make.leading.equalToSuperview().offset(15)
//         make.trailing.equalToSuperview().offset(-15)
//     }
//
//     for (i, item) in items.enumerated() {
//         let newButton = currencyButtonsView.layout(NewWalletItemView())
//         { make in
//             make.height.equalTo(61)
//             switch currencyButtons.last {
//             case .none: make.top.equalToSuperview()
//             case .some(let last): make.top.equalTo(last.bottom).offset(16)
//             }
//             make.leading.trailing.equalToSuperview()
//         }
//         newButton.tag = i
//         newButton.imageView.image = item.image
//         newButton.titleLabel.text = item.fullName
//         newButton.rightImageView.image = .disclosure
//         currencyButtons.append(newButton)
//     }
//
//     currencyButtons.last?.snp.makeConstraints { make in
//         make.bottom.equalToSuperview()
//     }
// }
