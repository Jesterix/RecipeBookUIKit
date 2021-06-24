//
//  RecipeTextViewCell.swift
//  RecipeBookUIKit
//
//  Created by Георгий on 13.03.2021.
//  Copyright © 2021 George Khaydenko. All rights reserved.
//

import UIKit

final class RecipeTextViewCell: CustomTableViewCell {
    static var reuseID = "TextViewCell"
    
    private var textView: TextView!
    
    public var recipe: Recipe? {
        didSet {
            if oldValue == nil {
                setupTextView()
            }
        }
    }

    public var textViewCallback: (() -> Void)?
    public var didChangeRange: ((NSRange) -> Void)?
    
    public var didChangeRecipe: ((Recipe) -> ())?
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
    
    private func setupTextView() {
        guard var recipe = self.recipe else { return }
        //set text
        textView.attributedText = NSAttributedString(string: recipe.text, attributes: Theme.textAttributes)
        
        //set attachments
        if recipe.attachmentsInfo.count > 0 {
            recipe.attachmentsInfo.sort {
                $0.range.location < $1.range.location
            }
            for attach in recipe.attachmentsInfo.reversed() {
                DispatchQueue.main.async {
                    self.textView.selectedRange = attach.range
                    if let savedImage = Helper.loadImageFromDiskWith(fileName: attach.url) {
                        self.textView.insertImage(
                            savedImage,
                            widthScale: 1,
                            heightScale: 1)
                        self.textViewCallback?()
                    }
                }
            }
        }
    }
    
    private func checkAttachments(for textView: UITextView) {
        var newRanges: [Int] = []
        textView.attributedText.enumerateAttribute(
            .attachment,
            in: NSRange(location: 0, length: textView.attributedText.length),
            options: []
        ) { (value, range, stop) in
            if (value is NSTextAttachment) {
                newRanges.append(range.location)
            }
        }
        guard var recipe = self.recipe, newRanges.count == recipe.attachmentsInfo.count else { return }
        for index in recipe.attachmentsInfo.indices {
            recipe.attachmentsInfo[index].range.location = newRanges[index]
        }
        self.recipe = recipe
    }
    
    private func removeAttachments(in range: NSRange, of textView: UITextView) {
        guard var recipe = self.recipe else { return }
        var indicesToRemove: Set<Int> = Set()
        textView.attributedText.enumerateAttribute(
            .attachment,
            in: range,
            options: []
        ) { (value, attachRange, stop) in
            if (value is NSTextAttachment) {
                if let index = (recipe.attachmentsInfo.firstIndex {
                    $0.range.location == attachRange.location
                }) {
                    indicesToRemove.insert(index)
                }
            }
        }
        if indicesToRemove.count > 0 {
            let removingIndices = Array(indicesToRemove).sorted().reversed()
            removingIndices.forEach { index in
                recipe.attachmentsInfo.remove(at: index)
            }
            self.recipe = recipe
        }
    }
    

}

//MARK:- UITextViewDelegate
extension RecipeTextViewCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let fixedWidth = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let newHeight = newSize.height
        self.textView.willChangeHeight = newHeight != textView.frame.size.height
        
        if self.textView.willChangeHeight {
            textViewCallback?()
        }
//        textViewDidChange?(textView)
        recipe?.text = textView.text
        checkAttachments(for: textView)
        guard let recipe = self.recipe else { return }
        didChangeRecipe?(recipe)
    }
    
    func textView(
        _ textView: UITextView,
        shouldChangeTextIn range: NSRange,
        replacementText text: String
    ) -> Bool {
        let currentText: String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(
            in: range,
            with: text)
        if currentText.count > updatedText.count {
            //removing attachments if needed
            removeAttachments(in: range, of: textView)
        }
        
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
        didChangeRange?(textView.selectedRange)
//        if self.view.window != nil {
            if textView.textColor == UIColor.coldBrown {
                textView.selectedTextRange = textView.textRange(
                    from: textView.beginningOfDocument,
                    to: textView.beginningOfDocument)
            }
//        }
    }
}
