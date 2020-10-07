import UIKit

extension UITextField {
    func addStandartToolbar() {
        let doneToolbar = ToolbarInputView(height: 40)
        doneToolbar.setDoneAction(target: self, action: #selector(doneButtonAction))
        self.inputAccessoryView = doneToolbar
    }
    
    @objc private func doneButtonAction() {
        self.resignFirstResponder()
    }
    
    func addCameraToolbar(target: Any?, action: Selector) {
        let cameraToolbar = ToolbarInputView(height: 40)
        cameraToolbar.setDoneAction(target: self, action: #selector(doneButtonAction))
        cameraToolbar.setCameraAction(target: target, action: action)
        self.inputAccessoryView = cameraToolbar
    }
    
    func addPickerToolbar() {
        let pickerToolbar = ToolbarInputView(height: 30)
        pickerToolbar.backgroundColor = .milkWhite
        pickerToolbar.setDoneAction(target: self, action: #selector(doneButtonAction))
        self.inputAccessoryView = pickerToolbar
    }
}

extension UITextView {
    func addStandartToolbar() {
        let doneToolbar = ToolbarInputView(height: 40)
        doneToolbar.setDoneAction(target: self, action: #selector(doneButtonAction))
        self.inputAccessoryView = doneToolbar
    }
    
    @objc private func doneButtonAction() {
        self.resignFirstResponder()
    }
    
    func addCameraToolbar(target: Any?, action: Selector) {
        let cameraToolbar = ToolbarInputView(height: 40)
        cameraToolbar.setDoneAction(target: self, action: #selector(doneButtonAction))
        cameraToolbar.setCameraAction(target: target, action: action)
        self.inputAccessoryView = cameraToolbar
    }
}

