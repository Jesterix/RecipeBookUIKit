import UIKit

final class ToolbarInputView: UIInputView {
    private var doneButton: UIButton!
    private var cameraButton: UIButton!
    
    override init(frame: CGRect, inputViewStyle: UIInputView.Style) {
        super.init(frame: frame, inputViewStyle: inputViewStyle)
        layoutContent(in: self)
        applyStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
     // MARK: - layoutContent
    private func layoutContent(in view: UIView) {
        doneButton = layout(UIButton(type: .system)) { make in
            make.centerY.equalToSuperview().offset(5)
            make.trailing.equalToSuperview().offset(-15)
        }
        
        cameraButton = layout(UIButton(type: .system)) { make in
            make.centerY.equalToSuperview().offset(5)
            make.leading.equalToSuperview().offset(15)
        }
    }
    
    // MARK: - applyStyle
    private func applyStyle() {
        let textAttributes: [NSAttributedString.Key : Any] = [
            .font: UIFont.systemFont(ofSize: 17)
        ]
        doneButton.setAttributedTitle(
            NSAttributedString(
                string: "Button.Done.Text".localized(),
                attributes: textAttributes),
            for: .normal)
        doneButton.tintColor = .darkBrown
        
        let config = UIImage.SymbolConfiguration.init(pointSize: 18)
        cameraButton.setImage(
            UIImage(
                systemName: "camera",
                withConfiguration: config),
            for: .normal)
        cameraButton.tintColor = .darkBrown
        cameraButton.isHidden = true
    }
    
    func setDoneAction(target: Any?, action: Selector) {
        doneButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
    func setCameraAction(target: Any?, action: Selector) {
        cameraButton.addTarget(target, action: action, for: .touchUpInside)
        cameraButton.isHidden = false
    }
}

extension ToolbarInputView {
    convenience init(height: CGFloat) {
        self.init(frame: .init(
            x: 0,
            y: 0,
            width: 0,
            height: height),
        inputViewStyle: .keyboard)
    }
}
