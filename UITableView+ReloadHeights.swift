//
//  UITableView+ReloadHeights.swift
//  Jobok
//
//  Created by Bogdan Manshilin on 11.05.17.
//  Copyright © 2017 Jobok. All rights reserved.
//

import UIKit

extension UITableView {
    func reloadHeights() {
        let currentOffset = contentOffset
        UIView.setAnimationsEnabled(false)
        beginUpdates()
        endUpdates()
        UIView.setAnimationsEnabled(true)
        setContentOffset(currentOffset, animated: false)
    }
}
