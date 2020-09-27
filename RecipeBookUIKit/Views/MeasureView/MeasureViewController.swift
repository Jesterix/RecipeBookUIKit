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
        measureView.addButton.addTarget(
            self,
            action: #selector(tapAdd),
            for: .touchUpInside)

        measureView.convertButton.addTarget(
            self,
            action: #selector(tapConvert),
            for: .touchUpInside)

        measureView.cancelButton.addTarget(
            self,
            action: #selector(tapCancel),
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

    @objc private func tapAdd() {
        toggleButtonsVisibility()
        if measureView.convertView.state == .editing {
            measureView.convertView.saveCustomMeasure()
        }
        measureView.convertView.state = measureView.addButton.isPrimary ? .normal : .editing
    }

    @objc private func tapCancel() {
        toggleButtonsVisibility()
        measureView.convertView.state = .normal
    }

    @objc private func tapConvert() {
        measureView.convertButton.isPrimary.toggle()
        measureView.addButton.isEnabled = measureView.convertButton.isPrimary

        measureView.convertView.state = measureView.convertButton.isPrimary ? .normal : .converting
        if measureView.convertView.state == .converting {
            setupPickerView(from: measure)
        }
    }

    private func toggleButtonsVisibility() {
        measureView.addButton.isPrimary.toggle()
        measureView.cancelButton.isHidden = measureView.addButton.isPrimary
        measureView.convertButton.isEnabled = measureView.addButton.isPrimary
        measureView.closeButton.enable(measureView.addButton.isPrimary)
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
