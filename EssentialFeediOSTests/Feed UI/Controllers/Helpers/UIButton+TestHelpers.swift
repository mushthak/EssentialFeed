//
//  UIButton+TestHelpers.swift
//  EssentialFeediOSTests
//
//  Created by Mushthak Ebrahim on 04/06/23.
//

import UIKit

extension UIButton {
    func simulateTap() {
        simulate(event: .touchUpInside)
    }
}
