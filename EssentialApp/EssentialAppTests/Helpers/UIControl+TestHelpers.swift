//
//  UIControl+TestHelpers.swift
//  EssentialFeediOSTests
//
//  Created by Mushthak Ebrahim on 04/06/23.
//

import UIKit

extension UIControl {
    func simulate(event: UIControl.Event) {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: event)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}
