//
//  TableViewKeyboardHandler.swift
//  RecipeBookUIKit
//
//  Created by Георгий on 05.03.2021.
//  Copyright © 2021 George Khaydenko. All rights reserved.
//

import UIKit

/// Adjusts bottom insets when keyboard is shown and makes sure the keyboard doesn't obscure the cell.
///
/// Resets insets when the keyboard is hidden.
class TableViewKeyboardHandler {
    private let viewToHandleTaps: UIView
    private let tableView: UITableView
    private var innerKeyboardVisible: Bool = false
    private var tapHandler: (UIView, UITapGestureRecognizer)?

    init(from tableViewController: TableViewController) {
        self.tableView = tableViewController.tableView
        self.viewToHandleTaps = tableViewController.view
        addObservers()
    }
    
    deinit {
        removeObservers()
    }

    var keyboardVisible: Bool {
        innerKeyboardVisible
    }
    
    public func hideKeyboardByTapOnView() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(didTapOnView))
        recognizer.cancelsTouchesInView = false
        tapHandler = (viewToHandleTaps, recognizer)
        if let handler = tapHandler {
            handler.0.addGestureRecognizer(handler.1)
        }
    }

    /// Start listening for changes to keyboard visibility so that we can adjust the scroll view accordingly.
    private func addObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(TableViewKeyboardHandler.keyboardWillShow(_:)), name: UIWindow.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(TableViewKeyboardHandler.keyboardWillHide(_:)), name: UIWindow.keyboardWillHideNotification, object: nil)
    }

    /// Stop listening to keyboard visibility changes
    private func removeObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self, name: UIWindow.keyboardWillShowNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIWindow.keyboardWillHideNotification, object: nil)
        if let handler = tapHandler {
            handler.0.removeGestureRecognizer(handler.1)
        }
    }

    /// The keyboard will appear, scroll content so it's not covered by the keyboard.
    @objc func keyboardWillShow(_ notification: Notification) {
        innerKeyboardVisible = true
        guard let cell = tableView.firstResponder()?.tableViewCell() else {
            return
        }
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }

        let rectForRow = tableView.rectForRow(at: indexPath)

        guard let userInfo: [AnyHashable: Any] = notification.userInfo else {
            return
        }
        guard let window: UIWindow = tableView.window else {
            return
        }

        let keyboardFrameEnd = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue

        let keyboardFrame = window.convert(keyboardFrameEnd, to: tableView.superview)

        let convertedRectForRow = window.convert(rectForRow, from: tableView)

        var scrollToVisible = false
        var scrollToRect = CGRect.zero

        let spaceBetweenCellAndKeyboard: CGFloat = 36
        let y0 = convertedRectForRow.maxY + spaceBetweenCellAndKeyboard
        let y1 = keyboardFrameEnd.minY
        let obscured = y0 > y1

        if obscured {
            scrollToVisible = true
            scrollToRect = rectForRow
            scrollToRect.size.height += spaceBetweenCellAndKeyboard
        }
        
        let inset: CGFloat = tableView.frame.maxY - keyboardFrame.origin.y
        var contentInset: UIEdgeInsets = tableView.contentInset
        var scrollIndicatorInsets: UIEdgeInsets = tableView.scrollIndicatorInsets

        contentInset.bottom = inset
        scrollIndicatorInsets.bottom = inset

        // Adjust insets and scroll to the selected row
        tableView.contentInset = contentInset
        tableView.scrollIndicatorInsets = scrollIndicatorInsets
        if scrollToVisible {
            tableView.scrollRectToVisible(scrollToRect, animated: true)
        }
    }

    /// The keyboard will disappear, restore content insets.
    @objc func keyboardWillHide(_ notification: Notification) {
        innerKeyboardVisible = false

        var contentInset: UIEdgeInsets = tableView.contentInset
        var scrollIndicatorInsets: UIEdgeInsets = tableView.scrollIndicatorInsets

        contentInset.bottom = 0
        scrollIndicatorInsets.bottom = 0

        // Restore insets
        tableView.contentInset = contentInset
        tableView.scrollIndicatorInsets = scrollIndicatorInsets
    }

    @objc private func didTapOnView(gestureRecognizer: UITapGestureRecognizer) {
        gestureRecognizer.view?.endEditing(true)
    }
}

fileprivate extension UIView {
    /// Find the first responder.
    ///
    /// This function is recursive.
    ///
    /// - returns: the first responder otherwise nil.
    func firstResponder() -> UIView? {
        if self.isFirstResponder {
            return self
        }
        for subview in subviews {
            let responder = subview.firstResponder()
            if responder != nil {
                return responder
            }
        }
        return nil
    }
}

fileprivate extension UIView {
    /// Find the first UITableViewCell among all the superviews.
    ///
    /// - returns: the found cell otherwise nil.
    func tableViewCell() -> UITableViewCell? {
        var viewOrNil: UIView? = self
        while let view = viewOrNil {
            if let cell = view as? UITableViewCell {
                return cell
            }
            viewOrNil = view.superview
        }
        return nil
    }
}
