//
//  TextViewCell.swift
//  RecipeBookUIKit
//
//  Created by Георгий on 13.03.2021.
//  Copyright © 2021 George Khaydenko. All rights reserved.
//

import UIKit

final class TextViewCell: CustomTableViewCell {
    static var reuseID = "TextViewCell"
    
    private var textView: TextView!
    
//    public var labelText = "" {
//        didSet {
//            floatTextView.placeholderText = labelText
//        }
//    }
    public var initialTextViewText = "" {
        didSet {
            textView.text = initialTextViewText
        }
    }
    public var attachments: [AttachmentInfo] = [] {
        didSet {
            setAttachments()
        }
    }
    public var textViewCallback: (() -> Void)?
    public var textViewDidChange: ((UITextView) -> ())?
    public var removeAttachments: ((NSRange, UITextView) -> Void)?
    public var cameraAction: (() -> Void)? {
        didSet {
            addCameraToolbar()
        }
    }
    public var galleryAction: (() -> Void)? {
        didSet {
            addCameraToolbar()
        }
    }
    
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layoutContent(in: self.contentView)
        applyStyle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - layoutContent
    private func layoutContent(in view: UIView) {
        textView = layout(TextView()) { make in
            make.edges.equalToSuperview().inset(5)
            make.height.greaterThanOrEqualTo(100)
        }
        textView.delegate = self
    }
    
    // MARK: - applyStyle
    private func applyStyle() {
        backgroundColor = .white
        selectionStyle = .none
    }
    
    func showTextViewPlaceholder(_ bool: Bool) {
        if bool {
            textView.textColor = .coldBrown
            textView.text = "Placeholder.Recipe.Text".localized()
        } else {
            textView.textColor = .darkBrown
        }
    }
    
    private func addCameraToolbar() {
        if cameraAction != nil && galleryAction != nil {
            textView.addCameraToolbar(
                cameraAction: cameraAction,
                galleryAction: galleryAction)
        }
    }
    
    private func setAttachments() {
//        self.removeAttachments?(NSRange(location: 0, length: textView.text.count), textView)
        
        if attachments.count > 0 {
//            attachments.sort {
//                $0.range.location < $1.range.location
//            }
            for attach in attachments {
                DispatchQueue.main.async {
                    self.textView.selectedRange = attach.range
                    if let savedImage = Helper.loadImageFromDiskWith(fileName: attach.url) {
                        self.textView.insertImage(
                            savedImage,
                            widthScale: 0.75,
                            heightScale: 0.7)
                    }
                }
            }
        }
    }
}

extension TextViewCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let fixedWidth = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let newHeight = newSize.height
        self.textView.willChangeHeight = newHeight != textView.frame.size.height
        
        if self.textView.willChangeHeight {
            textViewCallback?()
        }
        textViewDidChange?(textView)
    }
    
    func textView(
        _ textView: UITextView,
        shouldChangeTextIn range: NSRange,
        replacementText text: String
    ) -> Bool {
        //removing attachments if needed
        removeAttachments?(range, textView)
        
        let currentText: String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(
            in: range,
            with: text)
        
        if updatedText.isEmpty {
            showTextViewPlaceholder(true)
            textView.selectedTextRange = textView.textRange(
                from: textView.beginningOfDocument,
                to: textView.beginningOfDocument)
        } else if textView.textColor == .coldBrown && !text.isEmpty {
            showTextViewPlaceholder(false)
            textView.attributedText = NSAttributedString(
                string: text,
                attributes: Theme.textAttributes)
        } else {
            textView.setStandartThemeTextAttributes()
            return true
        }
        
        return false
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
//        if self.view.window != nil {
            if textView.textColor == UIColor.coldBrown {
                textView.selectedTextRange = textView.textRange(
                    from: textView.beginningOfDocument,
                    to: textView.beginningOfDocument)
            }
//        }
    }
}
