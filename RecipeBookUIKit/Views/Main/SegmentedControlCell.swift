//
//  SegmentedControlCell.swift
//  RecipeBookUIKit
//
//  Created by Георгий on 08.11.2021.
//  Copyright © 2021 George Khaydenko. All rights reserved.
//

import UIKit

final class SegmentedControlCell: CustomTableViewCell {
    static var reuseID = "SegmentedControlCell"

    private var segmentedControl: UISegmentedControl!
    public var isAscSelected = true {
        didSet {
            if isAscSelected {
                segmentedControl.selectedSegmentIndex = 0
            } else {
                segmentedControl.selectedSegmentIndex = 1
            }
        }
    }
    public var didChangeSorting: ((Bool) -> Void)?

    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layoutContent(in: self)
        applyStyle()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - layoutContent
    private func layoutContent(in view: UIView) {
        segmentedControl = layout(UISegmentedControl()) { make in
            make.edges.equalToSuperview()
            make.height.equalTo(30)
        }
        
        segmentedControl.addControlEvent(.valueChanged) { [weak self] in
            guard let self = self else { return }
            self.didChangeSorting?(self.segmentedControl.selectedSegmentIndex == 0)
        }
    }

    // MARK: - applyStyle
    private func applyStyle() {
        backgroundColor = .clear
        selectionStyle = .none
        
        segmentedControl.insertSegment(
            withTitle: "Filter.Sorting.Ascending".localized(),
            at: 0,
            animated: true)
        segmentedControl.insertSegment(
            withTitle: "Filter.Sorting.Descending".localized(),
            at: 1,
            animated: true)
        
        segmentedControl.setTitleTextAttributes(Theme.textAttributes, for: .normal)
    }
}
