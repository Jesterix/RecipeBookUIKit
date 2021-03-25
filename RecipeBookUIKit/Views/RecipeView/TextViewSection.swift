//
//  TextViewSection.swift
//  RecipeBookUIKit
//
//  Created by Георгий on 25.03.2021.
//  Copyright © 2021 George Khaydenko. All rights reserved.
//

import UIKit

final class TextViewSection: DefaultSectionWithBackground {
    private let textViewCellIdentifier = TextViewCell.reuseID
    
    private var recipe: Recipe
    
    private var currentSelectedRange: NSRange?
//    public var didSelect: ((Int) -> Void)?

    public var didChangeRecipe: ((Recipe) -> Void)?
    public var cameraAction: (() -> Void)?
    public var galleryAction: (() -> Void)?
    public var imageToInsert: UIImage? {
        didSet {
            guard let image = imageToInsert else { return }
            print("recipe.attachmentsInfo.count",recipe.attachmentsInfo.count)
            print("section imageToInsert", image)
            saveImage(image)
            //TODO
//            recipeView.textView.insertImage(
//                pic,
//                widthScale: 0.75,
//                heightScale: 0.7)
        }
    }
    
    init(recipe: Recipe) {
        self.recipe = recipe
        super.init()
    }
    
    public func update(viewModel: Recipe) {
        recipe = viewModel
        reloadSectionAnimated()
    }

    // MARK: - Cells

    override var cellReuseIdentifiers: [String: UITableViewCell.Type] {
        return [
            textViewCellIdentifier: TextViewCell.self
        ]
    }

    override var numberOfRows: Int {
        return 1
    }

    override func cellView(forIndex index: Int) -> CustomTableViewCell {
        let cell: TextViewCell = dequeueCell(forReuseIdentifier: textViewCellIdentifier)
        cell.initialTextViewText = recipe.text
        cell.attachments = recipe.attachmentsInfo
        cell.textViewDidChange = { [unowned self] textView in
            self.recipe.text = textView.text
            self.checkAttachments(for: textView)
            self.didChangeRecipe?(recipe)
            self.currentSelectedRange = textView.selectedRange
        }
        cell.textViewCallback = { [weak self] in
            guard let self = self else { return }
            self.updateTableView()
        }
        cell.removeAttachments = { [weak self] range, textField in
            guard let self = self else { return }
            self.removeAttachments(in: range, of: textField)
        }
        cell.cameraAction = { [weak self] in
            guard let self = self else { return }
            self.cameraAction?()
        }
        cell.galleryAction = { [weak self] in
            guard let self = self else { return }
            self.galleryAction?()
        }
        return cell
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
    }
    
    private func removeAttachments(in range: NSRange, of textView: UITextView) {
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
        }
    }
    
    private func saveImage(_ image: UIImage) {
        print("TODO saveImage")
        let imageName = Helper.imageName()
        
        print("currentSelectedRange",currentSelectedRange)
        if let range = currentSelectedRange {
            recipe.attachmentsInfo.append(AttachmentInfo(
                                            url: imageName,
                                            range: range))
        }
        
        guard let rotated = image.rotateUpwards(), let data = rotated.pngData() else { return }
        Helper.saveToDiskImage(name: imageName, with: data)
    }
}

