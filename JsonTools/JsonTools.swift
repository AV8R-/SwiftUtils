//
//  PropertyToJsonConvertion.swift
//  UltimateGuitar
//
//  Created by admin on 1/16/17.
//
//

import Foundation
import CoreData

func mapReflection<T, U>(x: T, transform: (Mirror) -> U) -> U {
    let mirror = Mirror(reflecting: x)
    return transform(mirror)
}

func objectToJsonMap(mirror: Mirror) -> [String: Any] {
    var result = [String: Any]()
    mirror.children.forEach {
        switch $0.value {
        case Optional<Any>.some(let data) where data is NSData: print("WARNING: " + String(describing: $0.label) + " is serialized!")
        case is NSData: print("WARNING: " + String(describing: $0.label) + " is serialized!")
        case Optional<Any>.none: break
        case Optional<Any>.some(let x):
            print(x)
            switch x {
            case is Int16, is Int32, is Int64, is Int, is Double, is Float, is String, is Bool: result[$0.label ?? ""] = x
            default: result[$0.label ?? ""] = anyToJson(x)
            }
        case is Int, is Double, is Float, is String: result[$0.label ?? ""] = $0.value
        default: result[$0.label ?? ""] = anyToJson($0.value)
        }
        
    }
    return result
}

func anyToJson(_ object: Any) -> Any {
    //Arrays
    if let numericArray = object as? [Numeric] { return numericArray.propsToJson() }
    if let strictValues = object as? [StrictType] { return strictValues.propsToJson() }
    if let managedArray = object as? [NSManagedObject] { return managedArray.propsToJson() }
    if let array = object as? [Any] { return array.propsToJson() }
    if let dictionary = object as? [AnyHashable: Any] {
        var ans = [String: Any]()
        dictionary.forEach {
//            if let stringable = $0 {
                ans[String(describing: $0.0)] = anyToJson($0.1)
//            }
        }
        return ans
    }
    
    //Objects
    if let number = object as? Numeric { return number }
    if let simple = object as? StrictType { return simple.string() }
    if let managed = object as? NSManagedObject { return managed.propsToJson() }
    if object is NSNull {
        print("hello, kitty")
    }
    return mapReflection(x: object, transform: objectToJsonMap)
}

extension Swift.Collection {
    func mapReflection<U>(transform: @escaping (Mirror) -> U) -> [U] {
        return map { transform(Mirror(reflecting: $0)) }
    }
    
    func propsToJson() -> [Any] {
        return flatMap {
            let extra = ($0 as? ExtraJsonConvertable)?.extraJsonFields() ?? [:]
            let json = anyToJson($0)
            if let dic = json as? [String: Any] {
                return dic + extra
            } else {
                return nil
            }
        }
    }
}

extension Swift.Collection where Iterator.Element: NSManagedObject {
    func propsToJson() -> [Any] {
        return flatMap {
            let extra = ($0 as? ExtraJsonConvertable)?.extraJsonFields() ?? [:]
            let json = anyToJson($0)
            if let dic = json as? [String: Any] {
                return dic + extra
            } else {
                return nil
            }
        }
    }
}

extension Swift.Collection where Iterator.Element == Numeric {
    func propsToJson() -> [Any] {
        switch first {
        case is NSNumber: return flatMap { ($0 as! NSNumber).intValue }
        default: return self as! [Any]
        }
    }
    
}

extension Swift.Collection where Iterator.Element == StrictType {
    func propsToJson() -> [Any] {
        return self as! [Any]
    }
}

extension NSManagedObject {
    func propsToJson() -> [String: Any] {
        let allKeys = NSDictionary(dictionary: entity.attributesByName).allKeys as! [String]
        var dict = [String: Any]()
        dictionaryWithValues(forKeys: allKeys).filter { !($0.1 is Data) && !($0.1 is NSNull) }.forEach {
            if $0.1 is StrictType {
                dict[$0.0] = $0.1
            } else {
                dict[$0.0] = anyToJson($0.1)
            }
        }
        if let extra = self as? ExtraJsonConvertable {
            return dict + extra.extraJsonFields()
        } else {
            return dict
        }
    }
}

//MARK: Костыли
protocol ExtraJsonConvertable {
    func extraJsonFields() -> [String: Any]
}
