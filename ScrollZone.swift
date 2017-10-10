//
//  ScrollZone.swift
//  Jobok
//
//  Created by Богдан Маншилин on 10/10/2017.
//  Copyright © 2017 Jobok. All rights reserved.
//

import CoreGraphics

struct ScrollZone {
    let loadRange: ClosedRange<CGFloat>
    var zone: Zone
    
    mutating func willChange(forYOffset yOffset: CGFloat) -> Bool {
        return zone.willChange(forYOffset: yOffset, loadRange: loadRange)
    }
    
    enum Zone {
        case load, freeScroll
        
        mutating func willChange(
            forYOffset yOffset: CGFloat,
            loadRange: ClosedRange<CGFloat>
            ) -> Bool
        {
            switch (self, yOffset) {
            case (.load, loadRange): return false
            case (.load, _): self = .freeScroll; return true
            case (.freeScroll, loadRange): self = .load; return true
            case (.freeScroll, _): return false
            }
        }
    }
}


