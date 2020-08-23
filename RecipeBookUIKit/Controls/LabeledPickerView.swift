//
//  LabeledPickerView.swift
//  RecipeBookUIKit
//
//  Created by Георгий Хайденко on 09.08.2020.
//  Copyright © 2020 George Khaydenko. All rights reserved.
//

import UIKit

final class LabeledPickerView: UIView {
    private var label: UILabel!
    private var pickerView: UIPickerView!
    var data: [String]?

    private weak var _delegate: UIPickerViewDelegate?
    public var delegate: UIPickerViewDelegate? {
        get {
            return self._delegate
        }
        set {
            self._delegate = newValue
        }
    }

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
        }

        pickerView = layout(UIPickerView()) { make in
            make.top.bottom.equalToSuperview()
            make.trailing.lessThanOrEqualToSuperview()
            make.width.equalToSuperview().dividedBy(3)
            make.leading.equalTo(label.trailing)
        }
    }

    // MARK: - applyStyle
    private func applyStyle() {
        label.font = .systemFont(ofSize: 13)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .darkBrown

        pickerView.delegate = self
        pickerView.dataSource = self
    }
}

extension LabeledPickerView: UIPickerViewDelegate {
    func selectRow(row: Int, inComponent: Int) {
        pickerView.selectRow(row, inComponent: inComponent, animated: true)
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel(text: data?[row] ?? "no value")
        label.font = .systemFont(ofSize: 13)
        label.textColor = .darkBrown
        label.textAlignment = .center
        return label
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("select \(data?[row] ?? "no value")")
        _delegate?.pickerView?(pickerView, didSelectRow: row, inComponent: component)
    }

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        20
    }
}

extension LabeledPickerView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //remove deviders
        pickerView.subviews.forEach({
            $0.isHidden = $0.frame.height < 1.0
        })

        return data?.count ?? 0
    }
}
