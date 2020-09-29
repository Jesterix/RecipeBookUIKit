//
//  MeasureViewController.swift
//  RecipeBookUIKit
//
//  Created by Georgy Khaydenko on 28.07.2020.
//  Copyright © 2020 George Khaydenko. All rights reserved.
//

import UIKit
import Foundation
import MeasureLibrary

final class MeasureViewController: UIViewController {
    private var measureView: MeasureView!
    var measure: Measure = Measure(value: 0, symbol: "")

    var onClose: ((Measure) -> Void)?

    override func loadView() {
        self.measureView = MeasureView()
        self.view = measureView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardOnTap()
        setupButtonActions()
        setupConvertView()
        setupSegmentedPicker()
        setupPickerView(from: measure)
    }
    
    private func setupButtonActions() {
        measureView.addButton.didTapMain = { [weak self] in
            guard let self = self else { return }
            self.updateButtonsVisibility()
            if self.measureView.convertView.state == .editing {
                self.measureView.convertView.saveCustomMeasure()
            }
            self.measureView.convertView.state = self.measureView.addButton.state == .normal ? .normal : .editing
        }
        
        measureView.addButton.didTapSecondary = { [weak self] in
            guard let self = self else { return }
            self.updateButtonsVisibility()
            self.measureView.convertView.measure = self.measure
            self.measureView.convertView.state = .normal
        }
        
        measureView.convertButton.addTarget(
            self,
            action: #selector(tapConvert),
            for: .touchUpInside)

        measureView.closeButton.addTarget(
            self,
            action: #selector(close),
            for: .touchUpInside)
    }
    
    private func setupConvertView() {
        measureView.convertView.measure = measure
        measureView.convertView.onMeasureChange = { [unowned self] measure in
            self.measure = measure
            self.setupPickerView(from: measure)
        }
        measureView.convertView.onStateChange = { [unowned self] state in
            self.measureView.segmentedPickerView.isUserInteractionEnabled = state != .converting
            switch state {
            case .converting:
                self.measureView.segmentedPickerView.alpha = 0.5
            default:
                self.measureView.segmentedPickerView.alpha = 1
            }
        }
        measureView.convertView.onBaseUnitChange = { [unowned self] measure in
            self.setupPickerView(from: measure)
        }
    }

    @objc private func tapConvert() {
        measureView.convertButton.isPrimary.toggle()
        measureView.addButton.isUserInteractionEnabled = measureView.convertButton.isPrimary

        measureView.convertView.state = measureView.convertButton.isPrimary ? .normal : .converting
        if measureView.convertView.state == .converting {
            setupPickerView(from: measure)
        }
    }

    private func updateButtonsVisibility() {
        switch measureView.addButton.state {
        case .normal:
            measureView.convertButton.isEnabled = true
            measureView.closeButton.enable(true)
        case .extended:
            measureView.convertButton.isEnabled = false
            measureView.closeButton.enable(false)
        }
    }
    
    @objc private func close(){
        measureView.convertView.onClose()
        onClose?(measure)
        self.dismiss(animated: true, completion: nil)
    }

    private func passPickerData(row: Int) {
        let dimension = Settings.defaultDimensions[row]
        measureView.convertView.setPickerData(with: dimension)
    }

    private func setupPickerView(from measure: Measure) {
        var row = Settings.defaultDimensions.firstIndex(of: .custom)
        if measure.symbol.isUnitMass {
            row = Settings.defaultDimensions.firstIndex(of: .mass(.grams))
        } else if measure.symbol.isUnitVolume {
            row = Settings.defaultDimensions.firstIndex(of: .volume(.liters))
        }
        if measure != self.measure {
        } else {
            passPickerData(row: row!)
        }
        select(segment: row ?? 0)
    }
    
    private func setupSegmentedPicker() {
        measureView.segmentedPickerView.delegate = self
        if let hideKeyboardGesture = view.gestureRecognizers?.first(where: {
            $0.name == "HideKeyboard"
        }) {
            measureView.segmentedPickerView.setGestureToPrevent(hideKeyboardGesture)
        }
    }
}

extension MeasureViewController: SegmentedControlDelegate {
    func select(segment: Int) {
        measureView.segmentedPickerView.select(segment: segment)
    }
    
    func didSelect(segment: Int) {
        passPickerData(row: segment)
    }
}
