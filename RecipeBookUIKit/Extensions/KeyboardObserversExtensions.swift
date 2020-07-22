//
//  KeyboardObserversExtensions.swift
//  RecipeBookUIKit
//
//  Created by Георгий Хайденко on 22.07.2020.
//  Copyright © 2020 George Khaydenko. All rights reserved.
//

import UIKit

//MARK: keyboard observers
extension UIViewController {
    func addKeyboardObservers(_ selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillHide() {
        self.view.frame.origin.y = 0
    }

    func adjustView(with notification: KeyboardNotification) {
        self.view.frame.origin.y = notification.dy
    }
}

struct KeyboardNotification {
    private let frameEnd: CGRect

    var dy: CGFloat {
        return -frameEnd.height
    }

    init?(_ notification: Notification) {
        guard let userInfo = notification.userInfo else {
            return nil
        }
        self.frameEnd = (userInfo[
            UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
    }
}

