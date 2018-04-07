//
//  ModalDelegate.swift
//  WorldTrotter
//
//  Created by Nicholas Ollis on 4/3/18.
//  Copyright © 2018 Big Nerd Ranch. All rights reserved.
//

import UIKit

class ModalDelegate: NSObject, UINavigationControllerDelegate {
    private let dropTransition = DropTransition()
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return dropTransition
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }
}
