//
//  DropTransition.swift
//  WorldTrotter
//
//  Created by Nicholas Ollis on 4/3/18.
//  Copyright © 2018 Big Nerd Ranch. All rights reserved.
//

import UIKit

class DropTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    let animationDuration: TimeInterval = 0.25
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        guard let toView = transitionContext.view(forKey: .to),
            let fromView = transitionContext.view(forKey: .from) else {
                preconditionFailure("Transition started with missing context info!")
        }
        
        guard let toSnap = toView.snapshotView(afterScreenUpdates: true),
            let fromSnap = fromView.snapshotView(afterScreenUpdates: false) else {
            return
        }

        fromSnap.frame = fromView.frame
        toSnap.frame = fromSnap.frame

        container.addSubview(toSnap)
        container.addSubview(fromSnap)
        container.bringSubview(toFront: toSnap)


        fromView.removeFromSuperview()

        toSnap.transform = CGAffineTransform(translationX: 0.0, y: -toView.frame.height)
        toSnap.clipsToBounds = true

        let moveViewsClosure = {
            toSnap.transform = .identity

        }
        
        let cleanUpClosure = { (didComplete: Bool) in
            let transitionCompleted = didComplete && !transitionContext.transitionWasCancelled
            let endingView = transitionCompleted ? toView : fromView
            container.addSubview(endingView)
            toSnap.removeFromSuperview()
            fromSnap.removeFromSuperview()
            transitionContext.completeTransition(transitionCompleted)
        }
        
        UIView.animate(withDuration: animationDuration, animations: moveViewsClosure, completion: cleanUpClosure)
    }
    
    private func offscreenTransform(for view: UIView, inContainer container: UIView) -> CGAffineTransform {
        var transform = view.transform
        transform = transform.translatedBy(x: 0.0, y: -view.frame.height)
        return transform
    }
    
}
