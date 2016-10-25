//
//  UIButtonExtension.swift
//  StopWatch
//
//  Created by Mutee ur Rehman on 10/25/16.
//  Copyright © 2016 Mutee ur Rehman. All rights reserved.
//

import UIKit
extension UIButton {
    func makeRound() {
        if self.frame.size.width == self.frame.size.height {
            self.layer.cornerRadius = self.frame.size.width/2
        }
    }
    func setBorder(width: Float, color: UIColor) {
        self.layer.borderWidth = CGFloat(width)
        self.layer.borderColor = color.CGColor
    }
}