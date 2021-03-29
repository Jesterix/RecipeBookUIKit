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
    
    private var selectedRange: NSRange = NSRange(location: 0, length: 0)

    public var didChangeRecipe: ((Recipe) -> Void)?
    public var cameraAction: (() -> Void)?
    public var galleryAction: (() -> Void)?
    public var imageToInsert: UIImage? {
        didSet {
            guard let image = imageToInsert else { return }
            saveImage(image)
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
            textViewCellIdentifier: RecipeTextViewCell.self
        ]
    }

    override var numberOfRows: Int {
        return 1
    }

    override func cellView(forIndex index: Int) -> CustomTableViewCell {
        let cell: RecipeTextViewCell = dequeueCell(forReuseIdentifier: textViewCellIdentifier)
        cell.recipe = recipe
        
        cell.didChangeRecipe = { [weak self] recipe in
            guard let self = self else { return }
            self.recipe = recipe
            self.didChangeRecipe?(recipe)
        }

        cell.textViewCallback = { [weak self] in
            guard let self = self else { return }
            self.updateTableView()
        }
        
        cell.didChangeRange = { [weak self] range in
            guard let self = self else { return }
            self.selectedRange = range
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
    
    private func saveImage(_ image: UIImage) {
        print("TODO saveImage")
        let imageName = Helper.imageName()
        
        recipe.attachmentsInfo.append(
            AttachmentInfo(
                url: imageName,
                range: selectedRange))
        reloadRow(index: 0)
        didChangeRecipe?(recipe)

        guard let rotated = image.rotateUpwards(), let data = rotated.pngData() else { return }
        Helper.saveToDiskImage(name: imageName, with: data)
    }
}

