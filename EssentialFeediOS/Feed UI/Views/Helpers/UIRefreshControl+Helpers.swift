//
//  UIRefreshControl+Helpers.swift
//  EssentialFeediOS
//
//  Created by Mushthak Ebrahim on 21/06/23.
//

import UIKit

 extension UIRefreshControl {
     func update(isRefreshing: Bool) {
         isRefreshing ? beginRefreshing() : endRefreshing()
     }
 }
