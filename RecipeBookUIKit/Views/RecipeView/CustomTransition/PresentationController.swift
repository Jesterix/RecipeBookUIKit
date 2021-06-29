//
//  PresentationController.swift
//  RecipeBookUIKit
//
//  Created by Георгий on 02.03.2021.
//  Copyright © 2021 George Khaydenko. All rights reserved.
//

import UIKit

final class PresentationController: UIPresentationController {
    private lazy var backgroundDimmingView: UIView = {
        let dimmingView = UIView()
        dimmingView.layoutBlur(intensity: 0.2)
        return dimmingView
    }()
    
    override func presentationTransitionWillBegin() {
        if let containerView = containerView {
            backgroundDimmingView.frame = containerView.bounds
            containerView.addSubview(backgroundDimmingView)
            backgroundDimmingView.alpha = 0.0
        }
        
        presentedViewController.transitionCoordinator?.animate(
            alongsideTransition: { _ in
                self.backgroundDimmingView.alpha = 1.0
            },
            completion: nil)
    }
    
    override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator?.animate(
            alongsideTransition: { _ in
                self.backgroundDimmingView.alpha = 0.0
            },
            completion: nil)
    }
}
