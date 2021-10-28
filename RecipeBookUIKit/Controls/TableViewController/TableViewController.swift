//
//  TableViewController.swift
//  RecipeBookUIKit
//
//  Created by Георгий on 03.03.2021.
//  Copyright © 2021 George Khaydenko. All rights reserved.
//

import UIKit
import SnapKit

//protocol Draggable {}

class TableViewController: UIViewController {
    private var keyboardHandler: TableViewKeyboardHandler?
    var tableViewDecorator: TableViewDecorator!
//    var emptyView = EmptyView()
    var tableView = CustomTableView()
    private let topContainerView: UIView = UIView()
    private let containerView: UIView = UIView()
    private var containerViewBottomConstraint: Constraint?
//    private let contentLockSpinner = T2SpinnerWithNoBackground()
    
//    var draggableCellsEnabled = false {
//        didSet {
//            if draggableCellsEnabled {
//                let longpress = UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureRecognized(gestureRecognizer:)))
//                self.tableView.addGestureRecognizer(longpress)
//            }
//        }
//    }
    
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
        setRoundedBackground()
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
    
    func setRoundedBackground() {
        containerView.backgroundColor = UIColor.clear
//        containerView.layer.shadowColor = UIColor.black.cgColor
//        containerView.layer.shadowOffset = CGSize(width: 0, height: 6)
//        containerView.layer.shadowOpacity = 0.1
//        containerView.layer.shadowRadius = 10
        
        containerView.snp.remakeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            containerViewBottomConstraint = make.bottom.equalToSuperview()/*.inset(tabBarHeight())*/.constraint
        }
        tableView.contentInset = UIEdgeInsets(
            top: tableView.contentInset.top + 10,
            left: tableView.contentInset.left,
            bottom: tableView.contentInset.bottom + 8,
            right: tableView.contentInset.right)
        tableView.scrollIndicatorInsets = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: 8,
            right: -16)
    }
    
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
