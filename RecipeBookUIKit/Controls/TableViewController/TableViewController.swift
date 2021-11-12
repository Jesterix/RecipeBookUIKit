//
//  TableViewController.swift
//  RecipeBookUIKit
//
//  Created by Георгий on 03.03.2021.
//  Copyright © 2021 George Khaydenko. All rights reserved.
//

import UIKit
import SnapKit

protocol Draggable {}

class TableViewController: UIViewController {
    private var keyboardHandler: TableViewKeyboardHandler?
    var tableViewDecorator: TableViewDecorator!
//    var emptyView = EmptyView()
    var tableView = CustomTableView()
    private let topContainerView: UIView = UIView()
    private let containerView: UIView = UIView()
    private var containerViewBottomConstraint: Constraint?
//    private let contentLockSpinner = T2SpinnerWithNoBackground()
    
    private var scrollOffset: CGFloat = 0
    public var stretchFactor: CGFloat = 1 {
        didSet {
            didChangeStretchFactor?(stretchFactor, scrollOffset)
        }
    }
    public var didChangeStretchFactor: ((CGFloat, CGFloat) -> Void)?
    
    var draggableCellsEnabled = false {
        didSet {
//            if draggableCellsEnabled {
//                let longpress = UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureRecognized(gestureRecognizer:)))
//                self.tableView.addGestureRecognizer(longpress)
//            }
        }
    }
    open var dragViewModels: [Any]? = nil {
        didSet {
            didChangeDragViewModels?(dragViewModels)
        }
    }
    open var didChangeDragViewModels: (([Any]?) -> Void)?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
//        automaticallyAdjustsScrollViewInsets = false
        tableView.contentInsetAdjustmentBehavior = .never
        setupTableView()
        configureKeyboardHandler()
//        configureOfflineMode()
    }
    
    func configureKeyboardHandler() {
        keyboardHandler = TableViewKeyboardHandler(from: self)
    }
    
//    func configureEmptyView(image: UIImage, title: String, description: String, actionTitle: String? = nil, action: (() -> Void)? = nil) {
//        emptyView.image = image
//        emptyView.title = title
//        emptyView.descr = description
//        emptyView.actionTitle = actionTitle
//        emptyView.action = action
//    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        navigationController?.setNavigationBarHidden(true, animated: true)
//        self.resetOfflineMode()
////        if let navC = self.navigationController {
////            swipeBackDelegate = NavigationControllerSwipeBackDelegate(forNavigationController: navC)
////        }
//    }
    
    // MARK: - Configuration
    private func setupTableView() {
        view.addSubview(topContainerView)
        topContainerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
        }
        
        view.addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            containerViewBottomConstraint = make.bottom.equalToSuperview()/*.inset(tabBarHeight())*/.constraint
        }
        
        containerView.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
//        tableView.clipsToBounds = false
        tableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(-10)
            make.leading.trailing.equalTo(containerView)
            make.bottom.equalTo(containerView)
        }
        
//        containerView.addSubview(emptyView)
//        emptyView.alpha = 0
//        emptyView.snp.remakeConstraints { (make) in
////            make.edges.equalTo(tableView)
//            make.center.equalTo(tableView)
//        }
//        contentLockSpinner.isHidden = true
//        view.addSubview(contentLockSpinner)
//        contentLockSpinner.snp.makeConstraints { make in
//            make.center.equalToSuperview()
//        }
//        setRoundedBackground()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setupFadingView()
    }
    
    func setupFadingView() {
        let gradient = CAGradientLayer()
        gradient.frame = containerView.bounds
        gradient.colors = [
            UIColor.clear,
            UIColor.white
        ].map { $0.cgColor }
        
        let whiteLocation = NSNumber(value: Float(20 / containerView.frame.height))
        gradient.locations = [0.0, whiteLocation]
        containerView.layer.mask = gradient
    }
    
//    func setRoundedBackground() {
//        containerView.backgroundColor = UIColor.clear
////        containerView.layer.shadowColor = UIColor.black.cgColor
////        containerView.layer.shadowOffset = CGSize(width: 0, height: 6)
////        containerView.layer.shadowOpacity = 0.1
////        containerView.layer.shadowRadius = 10
//
//        containerView.snp.remakeConstraints { (make) in
//            make.leading.trailing.equalToSuperview().inset(16)
//            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
//            containerViewBottomConstraint = make.bottom.equalToSuperview()/*.inset(tabBarHeight())*/.constraint
//        }
//        tableView.contentInset = UIEdgeInsets(
//            top: tableView.contentInset.top,// + 10,
//            left: tableView.contentInset.left,
//            bottom: tableView.contentInset.bottom + 8,
//            right: tableView.contentInset.right)
//        tableView.scrollIndicatorInsets = UIEdgeInsets(
//            top: 0,
//            left: 0,
//            bottom: 8,
//            right: -16)
//    }
    
    func layoutInHeader(
        view: UIView,
        insets: UIEdgeInsets = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: 0,
            right: 0)
    ) {
        topContainerView.addSubview(view)
        view.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(insets.top)
            make.leading.equalToSuperview().inset(insets.left)
            make.trailing.equalToSuperview().inset(insets.right)
            make.bottom.equalToSuperview().inset(insets.bottom)
        }

        containerView.snp.remakeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(topContainerView.snp.bottom)
            containerViewBottomConstraint = make.bottom.equalToSuperview()/*.inset(tabBarHeight())*/.constraint
        }
    }
    
//    public func addPlayerCotrollerStateObserver() {
//        Router.PL.willShow = { [weak self] in
//            guard let `self` = self else { return }
//            self.containerViewBottomConstraint?.update(inset: self.tabBarHeight() + Router.PL.view.frame.height)
//            self.view.layoutSubviews()
//        }
//        Router.PL.willHide = { [weak self] in
//            guard let `self` = self else { return }
//            self.containerViewBottomConstraint?.update(inset: self.tabBarHeight())
//            self.view.layoutSubviews()
//        }
//    }
    
    // MARK: - Snack Bar
//    func showSnackBar(text: String) {
//        let snackBar = SnackBar()
//        snackBar.setText(text: text)
//        view.addSubview(snackBar)
//        snackBar.show(bottomOffset: tabBarHeight())
//    }
    
//    func disableContentAnimated() {
//        tableView.isUserInteractionEnabled = false
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
//            guard !self.tableView.isUserInteractionEnabled else { return } // Cancel animation
//            self.contentLockSpinner.appearWithAnimation()
//            self.contentLockSpinner.startAnimation()
//            UIView.transition(with: self.tableView, duration: 0.2, options: [], animations: {
//                self.tableView.alpha = 0.5
//            }, completion: nil)
//        })
//    }
//
//    func enableContentAnimated() {
//        tableView.isUserInteractionEnabled = true
//        contentLockSpinner.disappearWithAnimation()
//        UIView.transition(with: tableView, duration: 0.2, options: [], animations: {
//            self.tableView.alpha = 1.0
//        }, completion: nil)
//    }
    
//    func showEmptyView() {
//        UIView.transition(
//            with: tableView,
//            duration: 0.2,
//            options: .transitionCrossDissolve,
//            animations: {
//                self.tableView.alpha = 0.0
//                self.emptyView.alpha = 1.0
//        }, completion: nil)
//    }
//
//    func hideEmptyView() {
//        UIView.transition(
//            with: tableView,
//            duration: 0.2,
//            options: .transitionCrossDissolve,
//            animations: {
//                self.tableView.alpha = 1.0
//                self.emptyView.alpha = 0.0
//        }, completion: nil)
//
//    }
    
    
//    // MARK: Offline
//
//    func resetOfflineMode() {
//        fatalError("Derived class must override 'resetOfflineView'")
//    }
//
//    func configureOfflineMode() {
//        fatalError("Derived class must override 'configureOffline'")
//    }
}

//MARK:- Extension for draggable cells
extension TableViewController {
    @objc func longPressGestureRecognized(gestureRecognizer: UIGestureRecognizer) {
        guard dragViewModels != nil else { return }
        let longpress = gestureRecognizer as! UILongPressGestureRecognizer
        let state = longpress.state
        let locationInView = longpress.location(in: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: locationInView)
        switch state {
        case .began:
            guard let indexPath = indexPath else {
                return
            }
            // let User grab only draggable cells && exclude first row as header
            guard self.tableView.cellForRow(at: indexPath) is Draggable && indexPath.row != 0 else { return }
            
            // print("indexpath \(indexPath)")
            Path.initialIndexPath = indexPath
            guard indexPath.section == Path.initialIndexPath?.section else { return }
            
            if let cell = self.tableView.cellForRow(at: indexPath) as? CustomTableViewCell, cell is Draggable {
                CellSnapshot.cellSnapShot = snapshotOfCell(inputView: cell)
                var center = cell.center
                CellSnapshot.cellSnapShot?.center = cell.center
                CellSnapshot.cellSnapShot?.alpha = 0.0
                self.tableView.addSubview(CellSnapshot.cellSnapShot!)
                
                UIView.animate(withDuration: 0.25, animations: {
                    center.y = locationInView.y
                    center.x = cell.center.x - 8
                    CellSnapshot.cellSnapShot?.center = center
                    CellSnapshot.cellSnapShot?.alpha = 0.98
                })
            }

        case .changed:
            guard let indexPath = indexPath, indexPath.section == Path.initialIndexPath?.section else {
                return
            }
            // let User drag cells only over draggable cells
            guard self.tableView.cellForRow(at: indexPath) is Draggable,
                  self.tableView.cellForRow(at: Path.initialIndexPath!) is Draggable
            else {
                return
            }
            
            var center = CellSnapshot.cellSnapShot?.center
            center?.y = locationInView.y
            CellSnapshot.cellSnapShot?.center = center!
            
            if indexPath != Path.initialIndexPath {
                // print("indexpath \(indexPath)")
                var modelIndexToSwap1 = indexPath.row
                var modelIndexToSwap2 = Path.initialIndexPath!.row
                
                // presume that first row is always a header
                if  modelIndexToSwap1 == 0 || modelIndexToSwap2 == 0 { } else {
                    modelIndexToSwap1 = modelIndexToSwap1 - 1
                    modelIndexToSwap2 = modelIndexToSwap2 - 1
                }
                
                dragViewModels!.swapAt(modelIndexToSwap1, modelIndexToSwap2)
                UIView.setAnimationsEnabled(false)
                self.tableView.moveRow(at: Path.initialIndexPath!, to: indexPath)
                self.tableView.beginUpdates()
                self.tableView.reloadRows(at: [Path.initialIndexPath!, indexPath], with: .none)
                self.tableView.endUpdates()
                UIView.setAnimationsEnabled(true)
                Path.initialIndexPath = indexPath
            }

        default:
            guard Path.initialIndexPath != nil else { return }
            if let cell = self.tableView.cellForRow(at: Path.initialIndexPath!) as? CustomTableViewCell {
                UIView.animate(withDuration: 0.25, animations: {
                    CellSnapshot.cellSnapShot?.center = cell.center
                    CellSnapshot.cellSnapShot?.transform = .identity
                    CellSnapshot.cellSnapShot?.alpha = 0.0
                }, completion: { (finished) -> Void in
                    if finished {
                        Path.initialIndexPath = nil
                        CellSnapshot.cellSnapShot?.removeFromSuperview()
                        CellSnapshot.cellSnapShot = nil
                    }
                })
            }
        }
    }

    func snapshotOfCell(inputView: UIView) -> UIView {
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0.0)
        inputView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        let cellSnapshot : UIView = UIImageView(image: image)
        cellSnapshot.layer.masksToBounds = false
        cellSnapshot.layer.cornerRadius = 0.0
        cellSnapshot.layer.shadowOffset = CGSize(width: 0.0, height: 8.0)
        cellSnapshot.layer.shadowRadius = 10
        cellSnapshot.layer.shadowOpacity = 0.1
        return cellSnapshot
    }

    struct CellSnapshot {
        static var cellSnapShot: UIView? = nil
    }

    struct Path {
        static var initialIndexPath: IndexPath? = nil
    }
}

extension TableViewController {
    public func tableViewDidScrollToOffset(offset: Double) {
//        print("didScroll to ", offset)
//        guard let navigationBar = navigationBar else { return }
//
//        guard navigationBar.contractedHeight != 0 else {
//            // Exception for static height NavBars; adjustment for changing NavBar background opacity
//            let tableOffset = CGFloat(offset) + navigationBar.expandedHeight
//            navigationBar.stretchFactor = fmax(fmin(1 - tableOffset / 12, 1), 0)
//            return
//        }
//
        let heightAffectedForScroll: CGFloat = 40
        let tableOffset = CGFloat(offset) + heightAffectedForScroll//topContainerView.frame.height
//        if let initialOffset = navigationBar.manualStretchFactorFromOffset, -CGFloat(offset) < navigationBar.expandedHeight {
//
//            tableOffset -= initialOffset + (navigationBar.expanding ? navigationBar.contractedHeight : navigationBar.expandedHeight)
//            print("new to \(tableOffset)")
//        }
//        navigationBar.stretchFactor = fmax(fmin(1 - tableOffset / (navigationBar.expandedHeight - navigationBar.contractedHeight), 1), 0)
        scrollOffset = offset
        stretchFactor = fmax(fmin(1 - tableOffset / (heightAffectedForScroll/*topContainerView.frame.height*/), 1), 0)
        
//        print("stretchFactor",stretchFactor)
    }
    
    public func tableViewScrollWillStopAt(offset: Double) {
        scrollOffset = offset
//        guard let navigationBar = navigationBar, CGFloat(-offset) > navigationBar.contractedHeight, navigationBar.contractedHeight > 0  else { return }
//        if CGFloat(-offset) > navigationBar.contractedHeight + (navigationBar.expandedHeight - navigationBar.contractedHeight) / 2 {
//            tableView.setContentOffset(CGPoint(x: 0, y: -navigationBar.expandedHeight), animated: true)
//        } else {
//            tableView.setContentOffset(CGPoint(x: 0, y: -navigationBar.contractedHeight), animated: true)
//        }
    }
    
    public func addScrollOffsetHandlers() {
        tableViewDecorator.didScrollToOffset.addHandler(handler: tableViewDidScrollToOffset)
        tableViewDecorator.scrollWillStopAt.addHandler(handler: tableViewScrollWillStopAt)
    }
}
