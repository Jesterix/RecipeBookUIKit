//
//  Extensions.swift
//  RecipeBookUIKit
//
//  Created by Георгий Хайденко on 20.07.2020.
//  Copyright © 2020 George Khaydenko. All rights reserved.
//

import UIKit

extension UILabel {
    convenience init(text: String = "") {
        self.init(frame: .zero)
        self.attributedText = .init(string: text)
    }
}

extension UIViewController {
    internal func hideKeyboardOnTap() {
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(hideKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)

        if let navC = self.navigationController {
            let tapToNavController = UITapGestureRecognizer(
            target: self,
            action: #selector(hideKeyboard))

            tapToNavController.cancelsTouchesInView = false
            navC.navigationBar.addGestureRecognizer(tapToNavController)
        }
    }

    @objc private func hideKeyboard(){
        view.endEditing(true)
    }
}

extension UIViewController {
    internal func setEditableTitle(delegate: UITextFieldDelegate) {
        let textField = UITextField(frame: .zero)
        textField.text = self.title
        textField.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        textField.textAlignment = .center
        textField.autocorrectionType = .no
        textField.delegate = delegate

        self.navigationItem.titleView = textField
    }
}
