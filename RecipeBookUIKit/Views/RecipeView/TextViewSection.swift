//
//  TextViewSection.swift
//  RecipeBookUIKit
//
//  Created by Георгий on 25.03.2021.
//  Copyright © 2021 George Khaydenko. All rights reserved.
//

import UIKit

final class TextViewSection: DefaultSectionWithBackground {
    private let textViewCellIdentifier = RecipeTextViewCell.reuseID
    
    private var recipe: Recipe
    private var textView: TextView = TextView() {
        didSet {
//            print("textView.TEXT",textView.text)
        }
    }

    public var didChangeRecipe: ((Recipe) -> Void)?

    public var cameraAction: (() -> Void)? {
        didSet { addCameraToolbar() }
    }
    public var galleryAction: (() -> Void)? {
        didSet { addCameraToolbar() }
    }
        
    public var imageToInsert: UIImage? {
        didSet {
            guard let image = imageToInsert else { return }
            saveImage(image)
        }
    }
    
    init(recipe: Recipe) {
        self.recipe = recipe
        super.init()
        setupTextView()
    }
    
    public func update(viewModel: Recipe) {
        recipe = viewModel
        reloadSectionAnimated()
    }
        
    //MARK: - TextView methods
    private func setupTextView() {
        textView.delegate = self
        
        //TODO: uncomment recipe.attachmentsInfo.coun
        guard !recipe.text.isEmpty || recipe.attachmentsInfo.count > 0 else {
            showTextViewPlaceholder(true)
            return
        }
        //        //set text
        textView.attributedText = NSAttributedString(string: recipe.text, attributes: Theme.textAttributes)
        //        //set attachments
                if recipe.attachmentsInfo.count > 0 {
                    recipe.attachmentsInfo.sort {
                        $0.range.location < $1.range.location
                    }

                    for attach in recipe.attachmentsInfo.reversed() {
                        DispatchQueue.main.async { [weak self] in
                            guard let self = self else { return }
                            self.textView.selectedRange = attach.range
                            if let savedImage = Helper.loadImageFromDiskWith(fileName: attach.url) {
                                self.textView.insertImage(
                                    savedImage,
                                    widthScale: 1,
                                    heightScale: 1)
                                self.updateTableView()
                                print("attach.range",attach.range)
                            }
                        }
                    }
                }
    }
        
    private func addCameraToolbar() {
        if cameraAction != nil && galleryAction != nil {
            textView.addCameraToolbar(
                cameraAction: cameraAction,
                galleryAction: galleryAction)
        }
    }
    
    func showTextViewPlaceholder(_ bool: Bool) {
        if bool {
            textView.textColor = .coldBrown
            textView.text = "Placeholder.Recipe.Text".localized()
        } else {
            textView.textColor = .darkBrown
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
        guard newRanges.count == recipe.attachmentsInfo.count else { return }
        for index in recipe.attachmentsInfo.indices {
            recipe.attachmentsInfo[index].range.location = newRanges[index]
        }
        didChangeRecipe?(recipe)
    }
    
    private func removeAttachments(in range: NSRange, of textView: UITextView) {
//        print("removeAttachments in range", range)
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
            didChangeRecipe?(recipe)
        }
    }

    // MARK: - Cells

    override var cellReuseIdentifiers: [String: UITableViewCell.Type] {
        return [
            textViewCellIdentifier: RecipeTextViewCell.self
        ]
    }

    override var numberOfRows: Int {
        return 1
    }

    override func cellView(forIndex index: Int) -> CustomTableViewCell {
        let cell: RecipeTextViewCell = dequeueCell(forReuseIdentifier: textViewCellIdentifier)
        cell.textView = textView

        return cell
    }
    
    private func saveImage(_ image: UIImage) {
//        print("saveImage at range", textView.selectedRange)
        let imageName = Helper.imageName()
        recipe.attachmentsInfo.append(
            AttachmentInfo(
                url: imageName,
                range: textView.selectedRange))
        
        if recipe.text.isEmpty {
            textView.text = recipe.text
        }
        textView.insertImage(image)
        updateTableView()

        checkAttachments(for: textView)

        guard let rotated = image.rotateUpwards(), let data = rotated.pngData() else { return }
        Helper.saveToDiskImage(name: imageName, with: data)
    }
}

//MARK:- UITextViewDelegate
extension TextViewSection: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        let fixedWidth = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let newHeight = newSize.height
        self.textView.willChangeHeight = newHeight != textView.frame.size.height

        if self.textView.willChangeHeight {
            self.updateTableView()
        }
        
        recipe.text = textView.text
        checkAttachments(for: textView)
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

        if updatedText.isEmpty || updatedText == "Placeholder.Recipe.Text".localized() && textView.textColor == .coldBrown {
            showTextViewPlaceholder(true)
            textView.selectedTextRange = textView.textRange(
                from: textView.beginningOfDocument,
                to: textView.beginningOfDocument)
        } else if textView.textColor == .coldBrown && !text.isEmpty {
            showTextViewPlaceholder(false)
            textView.attributedText = NSAttributedString(
                string: text,
                attributes: Theme.textAttributes)
            recipe.text = text
            didChangeRecipe?(recipe)
        } else {
            textView.setStandartThemeTextAttributes()
            return true
        }

        if updatedText.isEmpty {
            recipe.text = updatedText
            didChangeRecipe?(recipe)
        }

        return false
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
//        print("textViewDidChangeSelection",textView.selectedRange)
        if textView.textColor == UIColor.coldBrown {
            textView.selectedTextRange = textView.textRange(
                from: textView.beginningOfDocument,
                to: textView.beginningOfDocument)
        }
    }
}
