//
//  HorizontalCollectionView.swift
//  RecipeBookUIKit
//
//  Created by Георгий on 11.11.2021.
//  Copyright © 2021 George Khaydenko. All rights reserved.
//

import UIKit

public enum DefaultConstants: CGFloat {
    case tagViewHeight = 35
}

public class HorizontalCollectionView: UICollectionView {    
    private let cellIdentifier = "Cell"
    
    fileprivate var items = [String]()
    
    init() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 10
        flowLayout.scrollDirection = .horizontal
        super.init(frame: .zero, collectionViewLayout: flowLayout)
        dataSource = self
        delegate = self
        backgroundColor = .clear
        delaysContentTouches = false
        isScrollEnabled = false
        alwaysBounceHorizontal = false
        showsHorizontalScrollIndicator = false
        scrollsToTop = false
        isScrollEnabled = false
        clipsToBounds = false
        
        register(TagCell.self, forCellWithReuseIdentifier: cellIdentifier)
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
    func add(_ item: String) {
        items.append(item)
    }
}

// MARK: - UICollectionViewDataSource
extension HorizontalCollectionView: UICollectionViewDataSource {
    
    public func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return items.count
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell: TagCell = dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! TagCell
        cell.text = items[indexPath.item]
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension HorizontalCollectionView: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let standartHeight: CGFloat = DefaultConstants.tagViewHeight.rawValue
        var width: CGFloat = 30
        if let font: UIFont = Theme.tagTextAttributes[.font] as? UIFont {
            let cellWidth = items[indexPath.item].width(withConstrainedHeight: standartHeight, font: font) + 17
            if cellWidth > width {
                width = cellWidth
            }
        }
        return CGSize(width: width, height: standartHeight)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        switch actions[(indexPath as NSIndexPath).item].alertStyle {
//        case .button, .rateApp:
//            return
//        case .cell(_):
//            for i in actions {
//                switch i.alertStyle {
//                case .cell(_):
//                    i.alertStyle = .cell(isChosen: false)
//                default:
//                    break
//                }
//            }
//            reloadData()
//            actions[(indexPath as NSIndexPath).item].alertStyle = .cell(isChosen: true)
//        default:
//            break
//        }
//        actions[(indexPath as NSIndexPath).item].handler?()
    }
}
