//
//  MeasureViewTransitioningDelegate.swift
//  RecipeBookUIKit
//
//  Created by Георгий on 02.03.2021.
//  Copyright © 2021 George Khaydenko. All rights reserved.
//

import UIKit

final class MeasureViewTransitioningDelegate: NSObject {
    private let sourceRect: CGRect
    
    init(sourceRect: CGRect) {
        self.sourceRect = sourceRect
    }
}

extension MeasureViewTransitioningDelegate: UIViewControllerTransitioningDelegate {
    func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
    ) -> UIPresentationController? {
        return PresentationController(
            presentedViewController: presented,
            presenting: presenting
        )
    }
    
    func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        return MeasureViewTransitionAnimator(sourceRect: sourceRect)
    }
    
    func animationController(
        forDismissed dismissed: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        return MeasureViewTransitionAnimator(sourceRect: sourceRect)
    }
}
