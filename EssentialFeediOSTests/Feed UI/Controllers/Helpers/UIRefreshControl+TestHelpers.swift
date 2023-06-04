//
//  UIRefreshControl+TestHelpers.swift
//  EssentialFeediOSTests
//
//  Created by Mushthak Ebrahim on 04/06/23.
//

import UIKit

extension UIRefreshControl {
    func simulatePullToRefresh() {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: .valueChanged)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}
