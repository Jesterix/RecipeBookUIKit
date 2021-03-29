//
//  RecipeViewController.swift
//  RecipeBookUIKit
//
//  Created by Георгий Хайденко on 21.07.2020.
//  Copyright © 2020 George Khaydenko. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices

final class RecipeViewController: TableViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    
    private var recipeHeader = RecipeHeaderView()

    private var recipe: Recipe {
        didSet {
            dataManager.update(recipe: recipe)
        }
    }
    private var image: UIImage? {
        didSet {
            guard let textViewSection = tableViewDecorator.sections[1] as? TextViewSection else { return }
            textViewSection.imageToInsert = image
        }
    }
    
    private let dataManager: DataManager = DataBaseManager()
    
    private var measureViewTransitioningDelegate: MeasureViewTransitioningDelegate?

    init(_ recipe: Recipe) {
        self.recipe = recipe
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        setupHeader()
        
        tableViewDecorator = TableViewDecorator(forTableView: tableView, selfSizing: true)
        tableViewDecorator.sections = [ recipeSection(),
                                        textViewSection()]
        tableViewDecorator.rowActionsDelegate = self

        hideKeyboardOnTap()
        
        let share = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(shareRecipe))
        navigationItem.rightBarButtonItem = share
    }
    
    private func setupHeader() {
        layoutInHeader(
            view: recipeHeader,
            insets: UIEdgeInsets()
        )
        recipeHeader.addIngredientTextField.setPlaceholder(text: "Recipe.Add.Placeholder".localized())
        recipeHeader.addIngredientTextField.addingDelegate = self
        recipeHeader.titleField.text = recipe.title
        recipeHeader.titleField.delegate = self
        recipeHeader.convertPortionsView.coefficient = recipe.numberOfPortions ?? 1
        recipeHeader.convertPortionsView.delegate = self
    }
    
    func recipeSection() -> BaseTableViewSection {
        let section = RecipeSection(recipe: recipe)
        section.didTapMeasurement = { [weak self] index, sourceRect in
            guard let self = self else { return }
            let vc = MeasureViewController()
            if let measure = self.recipe.ingredients[index].measurement {
                vc.measure = measure
            }
            vc.onClose = { [unowned self] measure in
                self.recipe.ingredients[index].measurement = measure
                self.tableViewDecorator.reloadAllSectionsAnimated()
            }
            //custom transition setup
            self.measureViewTransitioningDelegate = MeasureViewTransitioningDelegate(sourceRect: sourceRect)
            vc.transitioningDelegate = self.measureViewTransitioningDelegate
    
            vc.modalPresentationStyle = .custom
            self.navigationController?.present(vc, animated: true, completion: nil)
        }
        section.didChangeRecipe = { [weak self] recipe in
            guard let self = self else { return }
            self.recipe = recipe
        }

        return section
    }
    
    func textViewSection() -> BaseTableViewSection {
        let section = TextViewSection(recipe: recipe)
        
        section.didChangeRecipe = { [weak self] recipe in
            guard let self = self else { return }
            self.recipe = recipe
        }
        section.cameraAction = { [weak self] in
            guard let self = self else { return }
            self.insertImageFromCamera()
        }
        section.galleryAction = { [weak self] in
            guard let self = self else { return }
            self.insertImageFromGallery()
        }
        
        return section
    }

    @objc private func tapConvert() {
        recipeHeader.convertPortionsView.stateToggle()
    }
    
    private func convertPortions(with coefficient: Double) {
        RecipeDataHandler.convertPortions(in: &recipe, with: coefficient)
    }
    
    @objc func shareRecipe() {
        let vc = UIActivityViewController(
            activityItems: [recipe.description],
            applicationActivities: [])
        present(vc, animated: true)
    }
    
    @objc private func insertImageFromCamera() {
        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
            self.showPickerWithSourceType(.camera)
        } else {
            AVCaptureDevice.requestAccess(
                for: .video,
                completionHandler: { (granted: Bool) in
                    DispatchQueue.main.async {
                        if granted {
                            self.showPickerWithSourceType(.camera)
                        } else {
                            self.showAlert(
                                title: "No access to camera",
                                message: "You need to grant permissions to camera to take a picture.") {
                                    self.showPickerWithSourceType(.photoLibrary)
                            }
                        }
                    }
            })
        }
    }
    
    @objc private func insertImageFromGallery() {
        self.showPickerWithSourceType(.photoLibrary)
    }
    
    // Open photo capture
    /// Show image picker
    /// - Parameter sourceType: the type of the source
    private func showPickerWithSourceType(_ sourceType: UIImagePickerController.SourceType) {
        var vc: UIViewController!
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.mediaTypes = [kUTTypeImage as String]// if you also need a video, then use [kUTTypeImage as String, kUTTypeMovie as String]
            imagePicker.sourceType = sourceType
            imagePicker.videoQuality = UIImagePickerController.QualityType.typeMedium
            vc = imagePicker
        } else {
            let alert = UIAlertController(
                title: "Error",
                message: "This feature is supported on real devices only",
                preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            vc = alert
        }
        DispatchQueue.main.async {
            self.present(vc, animated: true, completion: nil)
        }
    }
}

//MARK:- ObjectFromStringAdding
extension RecipeViewController: ObjectFromStringAdding {
    func addObject(from string: String) {
        recipe.ingredients.append(Ingredient(title: string))
        guard let section = tableViewDecorator.sections[0] as? RecipeSection else { return }
        section.update(viewModel: self.recipe)
    }
}

//MARK:- TextFieldDelegate
extension RecipeViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        switch textField {
        case recipeHeader.titleField:
            recipe.title = textField.text ?? ""
        default:
            return
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField != recipeHeader.titleField {
            switch recipeHeader.convertPortionsView.state {
            case .extended:
                convertPortions(with: recipeHeader.convertPortionsView.coefficient)
            case .normal:
                recipe.numberOfPortions = recipeHeader.convertPortionsView.coefficient
            }
        }
    }
}

//MARK:- ImagePickerDelegate
extension RecipeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // Temporary save image in `self.image`
    /// Image selected/captured
    /// - Parameters:
    ///   - picker: the picker
    ///   - info: the info
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let mediaType = info[UIImagePickerController.InfoKey.mediaType] {
            if (mediaType as AnyObject).description == kUTTypeImage as String {
                if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                    self.image = image
                }
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

//MARK:- RowEditActionsDelegate
extension RecipeViewController: RowEditActionsDelegate {
    func editActionsConfigForRowAt(_ indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.row == 0 {
            return UISwipeActionsConfiguration(actions: [])
        } else if tableView.cellForRow(at: indexPath) is RecipeTextViewCell {
            return UISwipeActionsConfiguration(actions: [])
        } else {
            let deleteAction = UIContextualAction(
                style: .destructive,
                title: "Main.Delete.Action".localized()
            ) { [unowned self] _, _, _ in
                self.recipe.ingredients.remove(at: indexPath.row - 1)
                guard let section = tableViewDecorator.sections[0] as? RecipeSection else { return }
                section.update(viewModel: self.recipe)
            }
            deleteAction.backgroundColor = .brightRed
            
            return UISwipeActionsConfiguration(actions: [deleteAction])
        }
    }
}
