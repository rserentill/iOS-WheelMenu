//
//  NumbersExtensions.swift
//  WheelMenu
//
//  Created by Roger Serentill Gené on 1/12/17.
//  Copyright © 2017 Roger Serentil. All rights reserved.
//

import Foundation

extension Int {
    var toRadians: Double { return Double(self) * .pi / 180 }
}

extension FloatingPoint {
    var toRadians: Self { return self * .pi / 180 }
    var toDegrees: Self { return self * 180 / .pi }
}

extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}
