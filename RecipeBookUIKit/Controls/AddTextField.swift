//
//  AddTextField.swift
//  RecipeBookUIKit
//
//  Created by Георгий Хайденко on 21.07.2020.
//  Copyright © 2020 George Khaydenko. All rights reserved.
//

import UIKit

protocol ObjectFromStringAdding: class {
    func addObject(from string: String)
}

class AddTextField: UITextField {

    private var addButton: UIButton!
    weak var addingDelegate: ObjectFromStringAdding?

    private weak var _delegate: UITextFieldDelegate?
    open override var delegate: UITextFieldDelegate? {
        get {
            return self._delegate
        }
        set {
            self._delegate = newValue
        }
    }

    init() {
        super.init(frame: .zero)
        layoutContent(in: self)
        applyStyle()
        setDelegates()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - layoutContent
    private func layoutContent(in view: UIView) {
        addButton = layout(UIButton(type: .contactAdd)) { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-10)
        }
    }

    // MARK: - applyStyle
    private func applyStyle() {
        backgroundColor = .systemOrange
        layer.cornerRadius = 20
        font = .systemFont(ofSize: 15)
        textColor = .black
        autocorrectionType = .no
        textInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 40)

        addButton.tintColor = .black
    }

    //MARK: - set delegates
    private func setDelegates() {
        super.delegate = self

        addButton.addTarget(
            addingDelegate,
            action: #selector(addObject),
            for: .touchUpInside)
    }

    // MARK: - TextField Insets
    private var textInsets = UIEdgeInsets.zero {
        didSet {
            setNeedsDisplay()
        }
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInsets)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInsets)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInsets)
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
    }

    @objc private func addObject() {
        guard let text = text, text.count > 0 else {
            return
        }
        addingDelegate?.addObject(from: text)
        self.text = ""
    }
}

extension AddTextField: UITextFieldDelegate {
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        self._delegate?.textField?(
            textField,
            shouldChangeCharactersIn: range,
            replacementString: string) ?? true
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        if #available(iOS 13.0, *) {
            self._delegate?.textFieldDidChangeSelection?(textField)
        }
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return self._delegate?.textFieldShouldBeginEditing?(textField) ?? true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        self._delegate?.textFieldDidBeginEditing?(textField)
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return self._delegate?.textFieldShouldEndEditing?(textField) ?? true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        self._delegate?.textFieldDidEndEditing?(textField)
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return self._delegate?.textFieldShouldClear?(textField) ?? true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return self._delegate?.textFieldShouldReturn?(textField) ?? true
    }
}
