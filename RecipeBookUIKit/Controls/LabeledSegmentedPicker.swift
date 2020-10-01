//
//  LabeledSegmentedPicker.swift
//  RecipeBookUIKit
//
//  Created by Георгий on 26.09.2020.
//  Copyright © 2020 George Khaydenko. All rights reserved.
//

import UIKit

protocol SegmentedControlDelegate {
    func select(segment: Int)
    func didSelect(segment: Int)
}

final class LabeledSegmentedPicker: UIView {
    private var label: UILabel!
    private var segmentedPicker: UISegmentedControl!
    var data: [String]? {
        didSet {
            setupSegments()
        }
    }

    public var delegate: SegmentedControlDelegate?
    
    private var hideKeyboardGesture: UIGestureRecognizer?

    init(_ text: String) {
        super.init(frame: .zero)
        layoutContent(in: self, with: text)
        applyStyle()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - layoutContent
    private func layoutContent(in view: UIView, with text: String) {
        label = layout(UILabel(text: text)) { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(100)
        }

        segmentedPicker = layout(UISegmentedControl()) { make in
            make.leading.equalTo(label.trailing).offset(5)
            make.trailing.equalToSuperview()
            make.height.equalTo(30)
            make.centerY.equalToSuperview()
        }
    }

    // MARK: - applyStyle
    private func applyStyle() {
        label.font = .systemFont(ofSize: 11)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .darkBrown

        let attributes: [NSAttributedString.Key: Any]? = [
            .font: UIFont.systemFont(ofSize: 11),
            .foregroundColor: UIColor.darkBrown]
        segmentedPicker.setTitleTextAttributes(attributes, for: .normal)
        segmentedPicker.selectedSegmentTintColor = .honeyYellow
        segmentedPicker.backgroundColor = .lightlyGray
        fixBackgroundSegmentControl()
        segmentedPicker.addTarget(
            self,
            action: #selector(segmentedPickerDidChange),
            for: .valueChanged)
        
        let tapGesture = UITapGestureRecognizer()
        if let gestureToPrevent = hideKeyboardGesture {
            tapGesture.canPrevent(gestureToPrevent)
        }
        tapGesture.cancelsTouchesInView = false
        segmentedPicker.addGestureRecognizer(tapGesture)
    }
    
    private func setupSegments() {
        guard let strings = data else {
            return
        }
        for i in 0..<strings.count {
            segmentedPicker.insertSegment(
                withTitle: strings[i],
                at: i,
                animated: false)
        }
    }
    
    @objc private func segmentedPickerDidChange(sender: UISegmentedControl) {
        delegate?.didSelect(segment: sender.selectedSegmentIndex)
    }
    
    public func select(segment: Int) {
        segmentedPicker.selectedSegmentIndex = segment
    }
    
    public func setGestureToPrevent(_ gesture: UIGestureRecognizer) {
        hideKeyboardGesture = gesture
    }
    
    private func fixBackgroundSegmentControl(){
        //just to be sure it is full loaded
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            for i in 0..<self.segmentedPicker.numberOfSegments {
                let backgroundSegmentView = self.segmentedPicker.subviews[i]
                //it is not enogh changing the background color. It has some kind of shadow layer
                backgroundSegmentView.isHidden = true
            }
        }
    }
}
