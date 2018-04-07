//
//  TabDelegate.swift
//  WorldTrotter
//
//  Created by Nicholas Ollis on 3/26/18.
//  Copyright © 2018 Big Nerd Ranch. All rights reserved.
//

import UIKit

class TabDelegate: NSObject, UITabBarControllerDelegate {
    private let slideTransition = SlideTransition()
    private let slideInteraction = SlideInteraction()
    private var backgroundView: UIView
    
    var layoutDirection: UIUserInterfaceLayoutDirection = UIApplication.shared.userInterfaceLayoutDirection
    
    init(tabBarController: UITabBarController) {
        tabBarController.addInteraction(slideInteraction)
        slideInteraction.tabBarController = tabBarController
        
        // Add custom view
        backgroundView = UIView.init(frame: tabBarController.view.frame)
        backgroundView.backgroundColor = UIColor.white
        tabBarController.view.addSubview(backgroundView)
        tabBarController.view.sendSubview(toBack: backgroundView)
        
        super.init()
    }
    
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        let fromIndex = tabBarController.viewControllers!.index(of: fromVC)!
        let toIndex = tabBarController.viewControllers!.index(of: toVC)!
        
        if (layoutDirection == .leftToRight) {
            slideTransition.animationDirection = (fromIndex < toIndex) ? .left : .right
        } else {
            slideTransition.animationDirection = (fromIndex < toIndex) ? .right : .left
        }

        return slideTransition
    }
    
    func tabBarController(_ tabBarController: UITabBarController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return slideInteraction.currentlyInteractive ? slideInteraction : nil
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let coordinator = tabBarController.transitionCoordinator {
            coordinator.animate(alongsideTransition: { (context) in
                self.set(background: UIColor.white.cgColor)
                self.set(background: UIColor.magenta.cgColor)
            }, completion: nil)
        }
    }
    
    func set(background color: CGColor) {
        backgroundView.backgroundColor = UIColor(cgColor: color)
    }
}
