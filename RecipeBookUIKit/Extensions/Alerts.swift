//
//  Alerts.swift
//  RecipeBookUIKit
//
//  Created by Георгий on 06.12.2020.
//  Copyright © 2020 George Khaydenko. All rights reserved.
//

import UIKit

extension UIViewController {
    /// Show popup with title and message
    /// - Parameters:
    ///   - title: the title
    ///   - message: the message
    func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { action in
            completion?()
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: completion)
    }
}
