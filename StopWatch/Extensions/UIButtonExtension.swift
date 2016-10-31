//
//  UIButtonExtension.swift
//  StopWatch
//
//  Created by Mutee ur Rehman on 10/25/16.
//  Copyright © 2016 Mutee ur Rehman. All rights reserved.
//

import UIKit
import QuartzCore
extension UIView {
    func makeRound() {
        if self.frame.size.width == self.frame.size.height {
            self.layer.cornerRadius = self.frame.size.width/2
        }
    }
    func setBorder(width: Float, color: UIColor) {
        self.layer.borderWidth = CGFloat(width)
        self.layer.borderColor = color.cgColor
    }
    func setBorder(width: Float, colorIfNotEuqalToSelected normalColor: UIColor, colorIfEqualToSelected selectedColor: UIColor, selectedView: UIView?) {
        if selectedView != nil && self == selectedView {
            setBorder(width: width, color: selectedColor)
        }
        else {
            setBorder(width: width, color: normalColor)
        }
        
    }
}
