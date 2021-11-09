//
//  SortSection.swift
//  RecipeBookUIKit
//
//  Created by Георгий on 02.11.2021.
//  Copyright © 2021 George Khaydenko. All rights reserved.
//

import UIKit

final class SortSection: HeaderedSectionWithBackground {
    private let headerCellIdentifier = HeaderLabelCell.reuseID
    private let cellIdentifier = SegmentedControlCell.reuseID
    
    private var viewModel = FilterViewModel.SortType.nameAsc {
        didSet {
            didChangeModel?(viewModel)
        }
    }
    
    public var didChangeModel: ((FilterViewModel.SortType) -> Void)?
    
    init(sortType: FilterViewModel.SortType) {
        viewModel = sortType
        super.init()
    }

    // MARK: - Cells

    override var cellReuseIdentifiers: [String: UITableViewCell.Type] {
        return [
            headerCellIdentifier: HeaderLabelCell.self,
            cellIdentifier: SegmentedControlCell.self
        ]
    }

    override var numberOfRows: Int {
        return 1
    }
    
    override func headerCellView() -> TableCellWithBackground {
        let cell: HeaderLabelCell = dequeueCell(forReuseIdentifier: headerCellIdentifier)
        
        cell.labelText = "Filter.Sorting".localized()
        return cell
    }

    override func cellView(forIndex index: Int) -> CustomTableViewCell {
        let cell: SegmentedControlCell = dequeueCell(forReuseIdentifier: cellIdentifier)

        cell.isAscSelected = viewModel == .nameAsc
        cell.didChangeSorting = { [weak self] bool in
            guard let self = self else { return }
            self.viewModel = bool ? .nameAsc : .nameDesc
        }
        return cell
    }
    
    override func didSelectRow(atIndex: Int) {
//        didSelect?(atIndex)
    }
}

