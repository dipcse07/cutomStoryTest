//
//  Extensions.swift
//  customStoryTest
//
//  Created by MD SAZID HASAN DIP on 17/7/21.
//

import Foundation
import UIKit

extension UIView {
    public func removeAllSubviews() {
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
    }
}

