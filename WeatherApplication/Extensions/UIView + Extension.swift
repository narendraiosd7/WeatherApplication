//
//  UIView + Extension.swift
//  WeatherApplication
//
//  Created by UW-IN-LPT0108 on 4/3/23.
//

import Foundation
import UIKit

extension UIView {
    func setupRoundedCornersAndShadow() {
        self.layer.cornerRadius = 25
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner]
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize(width: 0, height: 5)
        self.layer.shadowRadius = 5
    }
}
