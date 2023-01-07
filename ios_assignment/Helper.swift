//
//  Helper.swift
//  ios_assignment
//
//  Created by Shubham Kushwaha on 06/01/23.
//

import Foundation
import UIKit


struct Helper {
    static func checkIfViewLies( view: UIView ,inside: UIView) -> Bool {
        // Centre point of the view
        if let globalPoint = view.superview?.convert(view.frame.origin, to: nil) {
            let getCGRect = CGRectMake(inside.frame.origin.x, inside.frame.origin.y, inside.frame.size.width, inside.frame.size.height)
            let isPresent = CGRectContainsPoint(getCGRect, globalPoint)
            if isPresent {
                return true
            }
            else {
                return false
            }
        }
        else {
            return false
        }
    }
}
