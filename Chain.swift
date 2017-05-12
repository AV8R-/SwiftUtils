//
//  Chain.swift
//  Jobok
//
//  Created by Bogdan Manshilin on 12.05.17.
//  Copyright © 2017 Jobok. All rights reserved.
//

import Foundation

protocol Chain: class {
    associatedtype Value
    
    var startProcess: (Value) -> Void { set get }
    func process<Responder: Chain>(value: Value, next: Responder?) where Value == Responder.Value
}

extension Chain {
    func chain<Responder: Chain>(to next: Responder) where Self.Value == Responder.Value {
        let start = { [unowned self] in
            self.process(value: $0, next: next)
        }
        self.startProcess = start
    }
}
