//
//  StrictTypes.swift
//  UltimateGuitar
//
//  Created by admin on 2/17/17.
//
//

import Foundation

protocol StrictType: StringConvertable {}

protocol Numeric: StrictType {
}

extension Float: Numeric {}
extension Double: Numeric {}
extension Int: Numeric {}
extension Int8: Numeric {}
extension Int16: Numeric {}
extension Int32: Numeric {}
extension Int64: Numeric {}

extension UInt: Numeric {}
extension UInt8: Numeric {}
extension UInt16: Numeric {}
extension UInt32: Numeric {}
extension UInt64: Numeric {}
extension NSNumber: Numeric {}

extension Bool: StrictType {}
extension String: StrictType {}
extension String: StringConvertable {}
extension NSString: StrictType {}
