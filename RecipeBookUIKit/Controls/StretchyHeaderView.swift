//
//  StretchyHeaderView.swift
//  RecipeBookUIKit
//
//  Created by Георгий on 09.11.2021.
//  Copyright © 2021 George Khaydenko. All rights reserved.
//

import UIKit
import SnapKit

public enum StretchyHeaderViewStyle {
    case fullScreen
    case fullScreenNavigation
    case modal
}

open class StretchyHeaderView: UIView {
    
    // MARK: - Properties
    open var stretchFactor: CGFloat = 1 {
        didSet {
            didChangeStretchFactor(stretchFactor)
        }
    }
    
    open var barStyle: StretchyHeaderViewStyle = .fullScreen
    open var manualStretchFactorFromOffset: CGFloat? = nil
    open var expanding: Bool = false
    
    open var contractedHeight: CGFloat = 0
    open var expandedHeight: CGFloat = 0
    
    private let blurView = UIVisualEffectView()
    private var topPadding: CGFloat = 40
    private var _contractedHeightWithTopPadding: CGFloat = 0
    public var isBarStatic: Bool {
        return self.barStyle == .fullScreenNavigation ||
                self.barStyle == .modal
    }
    public var isBlurredOnScroll = false {
        didSet {
            if isBlurredOnScroll {
                blurView.alpha = 0
            }
        }
    }
    public weak var tableView: UITableView? = nil
    public var contractedHeightWithTopPadding: CGFloat {
        get {
            guard barStyle != .modal else { return topPadding + contractedHeight }
            
            let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            let statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
            topPadding = max(window?.safeAreaInsets.top ?? 0, statusBarHeight)
            
            if _contractedHeightWithTopPadding > 0 {
                return _contractedHeightWithTopPadding
            } else if contractedHeight == 0 {
                return topPadding + expandedHeight
            } else {
                return topPadding + contractedHeight
            }
        }
        set {
            _contractedHeightWithTopPadding = newValue
        }
    }
    
    public var expandedHeightWithTopPadding: CGFloat {
        guard barStyle != .modal else { return topPadding + expandedHeight }
        
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        let statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        topPadding = max(window?.safeAreaInsets.top ?? 0, statusBarHeight)
        
        return topPadding + expandedHeight
    }
    
    public var contentHeightConstraint: Constraint?
    
    open var color: UIColor = .white {
        didSet {
            blurView.backgroundColor = color.withAlphaComponent(0.7)
        }
    }
    
    public convenience init() {
        self.init(frame: CGRect.zero)
        
        self.setup()
        self.didChangeStretchFactor(1.0)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.zPosition = 1000
        
        addSubview(blurView)
        blurView.backgroundColor = color.withAlphaComponent(0.7)
        blurView.effect = UIBlurEffect(style: .light)
        blurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.setup()
        self.didChangeStretchFactor(1.0)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        layer.zPosition = 1000
        
        addSubview(blurView)
        blurView.backgroundColor = color.withAlphaComponent(0.7)
        blurView.effect = UIBlurEffect(style: .light)
        blurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.setup()
        self.didChangeStretchFactor(1.0)
    }
    
    // MARK: - Setup
    
    /// Override
    open func setup() {
        fatalError("Must override setup")
    }

    public func didChangeStretchFactor(_ stretchFactor: CGFloat) {
        if isBarStatic && !isBlurredOnScroll {
            blurView.alpha = 1.0
        } else if manualStretchFactorFromOffset == nil {
            blurView.alpha = 1 - stretchFactor
        }
        
        if contractedHeight > 0 {
            self.contentHeightConstraint?.update(offset: self.expandedHeightWithTopPadding * stretchFactor + self.contractedHeightWithTopPadding * (1 - stretchFactor))
        }
        
        self.layoutContent(stretchFactor: stretchFactor)
    }
    
    open func layoutContent(stretchFactor: CGFloat, offset: CGFloat = 0) {
        fatalError("Must override layoutContent")
    }
    
    open func add(toViewController viewController: UIViewController) {
        viewController.view.addSubview(self)
        
        if #available(iOS 13.0, *) {
            topPadding = 0
        }
        
        self.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            contentHeightConstraint = make.bottom.equalTo(viewController.view.snp.top).offset(expandedHeightWithTopPadding).constraint
        }
    }
    
    open func setTableViewAndUpdateConstraints(_ tableView: UITableView) {
        self.tableView = tableView
        
        tableView.contentInset = UIEdgeInsets(top: expandedHeight, left: 0, bottom: 0, right: 0)
        tableView.scrollIndicatorInsets = UIEdgeInsets(top: expandedHeight, left: 0, bottom: 0, right: 0)
        tableView.setContentOffset(CGPoint(x: 0, y: -expandedHeight), animated: false)
        
        contentHeightConstraint?.update(offset: expandedHeightWithTopPadding)
        layoutSubviews()
    }
}
