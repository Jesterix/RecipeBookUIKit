//
//  MeasureViewTransitionAnimator.swift
//  RecipeBookUIKit
//
//  Created by Георгий on 02.03.2021.
//  Copyright © 2021 George Khaydenko. All rights reserved.
//

import UIKit

final class MeasureViewTransitionAnimator: NSObject {
    fileprivate enum Style {
        case present
        case dismiss
    }
    
    private let sourceRect: CGRect
    
    init(sourceRect: CGRect) {
        self.sourceRect = sourceRect
    }
}

extension MeasureViewTransitionAnimator: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return style(for: transitionContext).transitionDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let style = self.style(for: transitionContext)
        style.performPreAnimationConfiguration(
            using: transitionContext,
            sourceRect: sourceRect)
        
        UIView.animateKeyframes(
            withDuration: transitionDuration(using: transitionContext),
            delay: 0,
            options: [],
            animations: {
                style.addAlphaChangeKeyFrameAnimations(using: transitionContext)
            },
            completion: nil
        )
        
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            delay: 0,
            usingSpringWithDamping: style.springDamping,
            initialSpringVelocity: 18,
            options: [],
            animations: {
                style.performTransitionAnimations(
                    using: transitionContext,
                    sourceRect: self.sourceRect
                )
            },
            completion: { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        )
    }
    
    private func style(for transitionContext: UIViewControllerContextTransitioning?) -> Style {
        let toViewController = transitionContext!.viewController(forKey: .to)!
        return toViewController.isBeingPresented ? .present : .dismiss
    }
}

private extension MeasureViewTransitionAnimator.Style {
    var transitionDuration: TimeInterval {
        switch self {
        case .present:
            return 0.5
        case .dismiss:
            return 0.5
        }
    }
    
    var springDamping: CGFloat {
        switch self {
        case .present:
            return 0.8
        case .dismiss:
            return 1.0
        }
    }
    
    func performPreAnimationConfiguration(
        using transitionContext: UIViewControllerContextTransitioning,
        sourceRect: CGRect
    ) {
        switch self {
        case .present:
            let toViewController = transitionContext.viewController(forKey: .to)!
            transitionContext.containerView.addSubview(toViewController.view)
            toViewController.view.frame = transitionContext.finalFrame(for: toViewController)
            toViewController.view.center = CGPoint(
                x: sourceRect.midX,
                y: sourceRect.midY
            )
            toViewController.view.transform = CGAffineTransform.scaleTransformForTransitioning(
                fromSize: toViewController.view.frame.size,
                toSize: sourceRect.size
            )
        case .dismiss:
            break
        }
    }
    
    func addAlphaChangeKeyFrameAnimations(using transitionContext: UIViewControllerContextTransitioning) {
        switch self {
        case .present:
            break
        case .dismiss:
            let fromViewController = transitionContext.viewController(forKey: .from)!
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
                fromViewController.view.alpha = 0
            }
        }
    }
    
    func performTransitionAnimations(
        using transitionContext: UIViewControllerContextTransitioning,
        sourceRect: CGRect
    ) {
        switch self {
        case .present:
            let toViewController = transitionContext.viewController(forKey: .to)!
            toViewController.view.transform = .identity
            let toViewControllerFinalFrame = transitionContext.finalFrame(for: toViewController)
            toViewController.view.center = CGPoint(
                x: toViewControllerFinalFrame.midX,
                y: toViewControllerFinalFrame.midY
            )
        case .dismiss:
            let fromViewController = transitionContext.viewController(forKey: .from)!
            fromViewController.view.transform = CGAffineTransform.scaleTransformForTransitioning(
                fromSize: fromViewController.view.frame.size,
                toSize: sourceRect.size
            )
            fromViewController.view.center = CGPoint(
                x: sourceRect.midX,
                y: sourceRect.midY
            )
        }
    }
}

private extension CGAffineTransform {
    static func scaleTransformForTransitioning(
        fromSize: CGSize,
        toSize: CGSize
    ) -> CGAffineTransform {
        return CGAffineTransform(
            scaleX: toSize.width / fromSize.width,
            y: toSize.height / fromSize.height
        )
    }
}
