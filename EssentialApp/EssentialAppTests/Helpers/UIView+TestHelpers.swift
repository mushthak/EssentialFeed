//
//  UIView+TestHelpers.swift
//  EssentialAppTests
//
//  Created by Mushthak Ebrahim on 06/07/23.
//

import UIKit

extension UIView {
    func enforceLayoutCycle() {
        layoutIfNeeded()
        RunLoop.current.run(until: Date())
    }
}
