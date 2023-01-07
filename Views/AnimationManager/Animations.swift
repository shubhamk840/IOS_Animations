//
//  Animations.swift
//  ios_assignment
//
//  Created by Shubham Kushwaha on 07/01/23.
//

import Foundation
import UIKit

struct AnimationManager {
    
    static func showTheToast(message:String, delay: Double , label: UILabel , labelPosX: CGFloat?, labelPosY: CGFloat?) {
        label.alpha = 0
        label.text = message
        label.center = CGPoint(x: labelPosX ?? 0.0, y: labelPosY ?? 0.0)
        UIView.animate(withDuration: 1, delay: delay, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, animations: {
            label.center = CGPoint(x: label.center.x, y: label.center.y - 80)
            label.alpha = 1
        
        })
    }
    
    
    static func hideContainerView(containerCircleView : UIView) {
        UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, animations: {
            containerCircleView.center = CGPoint(x: containerCircleView.center.x, y: containerCircleView.center.y + 150)
            containerCircleView.alpha = 0
        })
    }
    
    static func hideViewByReducingBorder(view: UIView) {
        view.layer.borderWidth = 0
    }
    
    static func showViewByIncreasingBorder(view:UIView) {
        view.layer.borderWidth = 5
    }
    
    
    static func addBlinkingEffect(On view: UIView) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [.repeat, .autoreverse] , animations: {
            view.alpha = 0
        })
    }
    
    static func animateToOldPositions(view:UIView, completion: @escaping ()->Void ) {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, animations: {
            view.transform = .identity
            completion()
        })
    }
    
}
