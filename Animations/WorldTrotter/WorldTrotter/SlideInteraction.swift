//
//  SlideInteraction.swift
//  WorldTrotter
//
//  Created by Nicholas Ollis on 3/26/18.
//  Copyright © 2018 Big Nerd Ranch. All rights reserved.
//

import UIKit

class SlideInteraction: UIPercentDrivenInteractiveTransition {
    
    var tabBarController: UITabBarController?
    var currentlyInteractive = false
    
    @objc func handlePan(_ gr: UIScreenEdgePanGestureRecognizer) {
        guard let tabBarController = tabBarController else {
            print("TabBarController nil in SlideInteraction!")
            return
        }
        print("Panned to relative location: \(gr.translation(in: nil))")
        
        let x = gr.translation(in: tabBarController.view).x
        let tabCount = tabBarController.viewControllers!.count
        let selectedIndex = tabBarController.selectedIndex
        
        let dX = UIApplication.shared.userInterfaceLayoutDirection == .leftToRight ? x : -x
        
        switch gr.state {
        case .began:
            currentlyInteractive = true
            if dX >= 0 {
                tabBarController.selectedIndex = selectedIndex == 0 ? tabCount-1 : selectedIndex-1
            } else if dX <= 0 {
                tabBarController.selectedIndex = selectedIndex < tabCount-1 ? selectedIndex+1 : 0
            }
        case .changed:
            let fraction = abs(dX / tabBarController.view.bounds.width)
            update(fraction)
        case .cancelled:
            cancel()
            currentlyInteractive = false
        case .ended:
            let fraction = abs(dX / tabBarController.view.bounds.width)
            if fraction >= 0.5 {
                finish()
            } else {
                cancel()
            }
            currentlyInteractive = false
        default:
            break
        }
    }
}
