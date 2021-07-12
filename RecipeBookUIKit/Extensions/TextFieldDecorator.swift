//
//  TextFieldDecorator.swift
//  RecipeBookUIKit
//
//  Created by Георгий on 10.07.2021.
//  Copyright © 2021 George Khaydenko. All rights reserved.
//

import UIKit

public protocol TextFieldDecoratorDelegate: AnyObject {
    func didChangeTextField(_ textField: UITextField)
    func didEndEditingTextField(_ textField: UITextField)
}

final public class TextFieldDecorator: NSObject, UITextFieldDelegate {
    private let textField: UITextField
    
    /// Enables classic behavior when keyboard gets hidden when user taps Return
    public var hideKeyboardOnReturnKey = false
    
    /// Allows to specify input masks (e.g. Max Length, Phone Number, Digits Only, etc..)
    public var mask: TextFieldMask?
    
    public weak var delegate: TextFieldDecoratorDelegate?
    
    public init(forTextField textField: UITextField) {
        self.textField = textField
        super.init()
        
        textField.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChangeNotification), name: UITextField.textDidChangeNotification , object: nil)
    }
    
    // MARK: - Delegate
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if hideKeyboardOnReturnKey {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.didEndEditingTextField(textField)
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let change = TextFieldStringChange(
            oldValue: textField.text!,
            range: range,
            replacementString: string)
        
        guard let mask = mask else {
            return true
        }
        
        let isValidChange = mask.validate(change: change)
        
        if let correctedValue = change.correctedValue {
            textField.text = correctedValue
            delegate?.didChangeTextField(self.textField)
            return false
        }
        
        return isValidChange
    }
    
    @objc func textDidChangeNotification(_ notif: Notification) {
        delegate?.didChangeTextField(self.textField)
    }
}
