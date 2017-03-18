//
//  StringConvertable.swift
//  UltimateGuitar
//
//  Created by admin on 2/17/17.
//
//

import Foundation

protocol StringConvertable {
    func string() -> String
}

extension StringConvertable {
    func string() -> String {
        return String(describing: self)
    }
}
