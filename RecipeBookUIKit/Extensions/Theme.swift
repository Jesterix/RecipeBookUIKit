//
//  Theme.swift
//  RecipeBookUIKit
//
//  Created by Георгий on 22.10.2020.
//  Copyright © 2020 George Khaydenko. All rights reserved.
//

import UIKit

class Theme {
    static var textAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 15),
        .foregroundColor: UIColor.darkBrown
    ]
    static var titleTextAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 22),
        .foregroundColor: UIColor.darkBrown
    ]
    static var placeholderTitleTextAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 14),
        .foregroundColor: UIColor.coldBrown.withAlphaComponent(0.7)
    ]
    static var tagTextAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 14),
        .foregroundColor: UIColor.darkBrown
    ]
}

extension UITextView {
    func setStandartThemeTextAttributes() {
        self.font = .systemFont(ofSize: 15)
        self.textColor = .darkBrown
    }
}
