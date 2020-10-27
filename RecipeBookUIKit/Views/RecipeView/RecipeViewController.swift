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

final class RecipeViewController: UIViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    
    private var recipeView: RecipeView!

    private var recipe: Recipe {
        didSet {
            dataManager.update(recipe: recipe)
            recipeView.ingredientTableView.reloadData()
        }
    }
    private var image: UIImage? {
        didSet {
            guard let pic = image else { return }
            saveImage(pic)
            recipeView.textView.insertImage(
                pic,
                widthScale: 0.75,
                heightScale: 0.7)
        }
    }
    
    private let dataManager: DataManager = DataBaseManager()

    init(_ recipe: Recipe) {
        self.recipe = recipe
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.recipeView = RecipeView()
        self.view = recipeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        recipeView.titleField.text = recipe.title
        recipeView.titleField.delegate = self
        recipeView.ingredientTableView.dataSource = self
        recipeView.ingredientTableView.delegate = self
        recipeView.ingredientTableView.register(
            IngredientCell.self,
            forCellReuseIdentifier: IngredientCell.reuseID)
        recipeView.addIngredientTextField.addingDelegate = self
        recipeView.textView.delegate = self
        
        recipeView.textView.addCameraToolbar(
            target: self,
            cameraAction: #selector(insertImageFromCamera),
            galleryAction: #selector(insertImageFromGallery))
        
        recipeView.textView.text = recipe.text
        //TODO: refactor
        if recipe.attachmentsInfo.count > 0 {
            recipe.attachmentsInfo.sort {
                $0.range.location < $1.range.location
            }
            for attach in recipe.attachmentsInfo {
                DispatchQueue.main.async {
                    self.recipeView.textView.selectedRange = attach.range
                    if let savedImage = self.loadImageFromDiskWith(fileName: attach.url) {
                        self.recipeView.textView.insertImage(
                            savedImage,
                            widthScale: 0.75,
                            heightScale: 0.7)
                    }
                }
            }
        }
        
        recipeView.showTextViewPlaceholder(recipe.text.isEmpty)
        
        recipeView.convertPortionsView.coefficient = recipe.numberOfPortions ?? 1
        recipeView.convertPortionsView.delegate = self
        
        recipeView.showTablePlaceholder(recipe.ingredients.isEmpty)

        hideKeyboardOnTap()
        
        let share = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(shareRecipe))
        navigationItem.rightBarButtonItem = share
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addKeyboardObservers(#selector(keyboardWillChange(notification:)))
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardObservers()
    }

    @objc func keyboardWillChange(notification: Notification) {
        guard let notification = KeyboardNotification(notification) else {
            return
        }

        if recipeView.textView.isFirstResponder {
            adjustView(with: notification)
        }
    }

    @objc private func tapConvert() {
        recipeView.convertPortionsView.stateToggle()
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
    
    // 2. Open photo capture
    /// Show image picker
    /// - Parameter sourceType: the type of the source
    private func showPickerWithSourceType(_ sourceType: UIImagePickerController.SourceType) {
        var vc: UIViewController!
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.mediaTypes = [kUTTypeImage as String]       // if you also need a video, then use [kUTTypeImage as String, kUTTypeMovie as String]
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
    
    /// Show popup with title and message
    /// - Parameters:
    ///   - title: the title
    ///   - message: the message
    private func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { action in
            completion?()
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: completion)
    }
    
    private func saveImage(_ image: UIImage){
        let imageName = Helper.imageName()
        //create an instance of the FileManager
        guard let documentsDirectory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask).first else { return }

        //get the image path
        let fileURL = documentsDirectory.appendingPathComponent(imageName)
        
        recipe.attachmentsInfo.append(AttachmentInfo(
            url: imageName,
            range: recipeView.textView.selectedRange))

        guard let rotated = image.rotateUpwards(), let data = rotated.pngData() else { return }
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
                print("Removed old image")
            } catch let removeError {
                print("couldn't remove file at path", removeError)
            }
        }
        
        do {
            try data.write(to: fileURL)
            print("saved to disk")
        } catch let error {
            print("error saving file with error", error)
        }
    }
    
    private func loadImageFromDiskWith(fileName: String) -> UIImage? {
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
        
        if let dirPath = paths.first {
            let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(fileName)
            let image = UIImage(contentsOfFile: imageUrl.path)
            return image
        }
        return nil
    }
    
    private func checkAttachments() {
        var newRanges: [Int] = []
        recipeView.textView.attributedText.enumerateAttribute(
            .attachment,
            in: NSRange(location: 0, length: recipeView.textView.attributedText.length),
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
}

extension RecipeViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        recipe.ingredients.count + 1
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: IngredientCell.reuseID) as? IngredientCell else {
            return UITableViewCell()
        }
        
        if indexPath.row == 0 {
            cell.configureHeader()
        } else {
            cell.configureCell(with: recipe.ingredients[indexPath.row - 1])

            cell.ingredientChanged { [unowned self] (ingredient: Ingredient) in
                self.recipe.ingredients[indexPath.row - 1] = ingredient
            }
            cell.tableView = tableView
        }

        return cell
    }
}

extension RecipeViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)

        let vc = MeasureViewController()

        if let measure = recipe.ingredients[indexPath.row - 1].measurement {
            vc.measure = measure
        }

        vc.onClose = { [unowned self] measure in
            self.recipe.ingredients[indexPath.row - 1].measurement = measure
        }
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        navigationController?.present(vc, animated: true, completion: nil)
    }

    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        if indexPath.row == 0 {
            return UISwipeActionsConfiguration(actions: [])
        } else {
            let deleteAction = UIContextualAction(
                style: .destructive,
                title: "Main.Delete.Action".localized()
            ) { [unowned self] _, _, _ in
                self.recipe.ingredients.remove(at: indexPath.row - 1)
                self.recipeView.showTablePlaceholder(self.recipe.ingredients.isEmpty)
            }
            deleteAction.backgroundColor = .brightRed
            
            return UISwipeActionsConfiguration(actions: [deleteAction])
        }
    }
}

extension RecipeViewController: ObjectFromStringAdding {
    func addObject(from string: String) {
        recipe.ingredients.append(Ingredient(title: string))
        recipeView.showTablePlaceholder(recipe.ingredients.isEmpty)
        recipeView.ingredientTableView.reloadData()
    }
}

extension RecipeViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        recipe.text = textView.text
        checkAttachments()
    }
    
    func textView(
        _ textView: UITextView,
        shouldChangeTextIn range: NSRange,
        replacementText text: String
    ) -> Bool {
        //removing attachments if needed
        removeAttachments(in: range, of: textView)
        
        let currentText: String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(
            in: range,
            with: text)
        
        if updatedText.isEmpty {
            recipeView.showTextViewPlaceholder(true)
            textView.selectedTextRange = textView.textRange(
                from: textView.beginningOfDocument,
                to: textView.beginningOfDocument)
        } else if textView.textColor == .coldBrown && !text.isEmpty {
            recipeView.showTextViewPlaceholder(false)
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
        if self.view.window != nil {
            if textView.textColor == UIColor.coldBrown {
                textView.selectedTextRange = textView.textRange(
                    from: textView.beginningOfDocument,
                    to: textView.beginningOfDocument)
            }
        }
    }
}

extension RecipeViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        switch textField {
        case recipeView.titleField:
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
        if textField != recipeView.titleField {
            switch recipeView.convertPortionsView.state {
            case .extended:
                convertPortions(with: recipeView.convertPortionsView.coefficient)
            case .normal:
                recipe.numberOfPortions = recipeView.convertPortionsView.coefficient
            }
        }
    }
}

extension RecipeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // 3. Temporary save image in `self.image`
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
