//
//  FadeOutAnimationController.swift
//  StoreSearch_RWbookTUT
//
//  Created by Emin Roblack on 11/20/18.
//  Copyright © 2018 emiN Roblack. All rights reserved.
//

import UIKit

class FadeOutAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0.4
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    
    if let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from) {
      
      let time = transitionDuration(using: transitionContext)
      UIView.animate(withDuration: time, animations: {
        fromView.alpha = 0
      }, completion: { finished in
        transitionContext.completeTransition(finished)
      })
    }
  }
}

class SlideOutAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0.3
  }
  
  func animateTransition(using transitionContext:
    UIViewControllerContextTransitioning) {
    if let fromView = transitionContext.view(forKey:
      UITransitionContextViewKey.from) {
      let containerView = transitionContext.containerView
      let time = transitionDuration(using: transitionContext)
      UIView.animate(withDuration: time, animations: {
        fromView.center.y -= containerView.bounds.size.height
        fromView.transform = CGAffineTransform(scaleX: 0.5,
                                               y: 0.5)
      }, completion: { finished in
        transitionContext.completeTransition(finished)
      })
    }
  }
}
