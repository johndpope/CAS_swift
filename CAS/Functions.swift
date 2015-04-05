//
//  Functions.swift
//  CAS
//
//  Created by Evan Peterson on 3/21/15.
//  Copyright (c) 2015 Evan Peterson. All rights reserved.
//

import Foundation

infix operator ^ { associativity left precedence 160 }

@objc protocol Function: Basic {
    var arg: Basic {get set}
    var name: String {get set}
}

class Log:NSObject,Function,Diff {
    var arg: Basic
    var name = "log"
    init(_ arg:Basic) {
        self.arg = arg
    }
    
    func sim() -> Basic {
        return Log(simplify(arg))
    }
    
    func diff(dVar: Var) -> Basic {
        return simplify((arg as! Diff).diff(dVar)*arg^Num(-1))
    }
    
    override var description: String {
        return "log(\(arg))"
    }
}

class Sin:NSObject,Function,Diff {
    var arg: Basic
    var name = "sin"
    init(_ arg:Basic) {
        self.arg = arg
    }
    
    func sim() -> Basic {
        return Sin(simplify(arg))
    }
    
    func diff(dVar: Var) -> Basic {
        return simplify((arg as! Diff).diff(dVar)*Cos(arg))
    }
    
    override var description: String {
        return "sin(\(arg))"
    }
}

class Cos:NSObject,Function,Diff {
    var arg: Basic
    var name = "cos"
    init(_ arg:Basic) {
        self.arg = arg
    }
    
    func sim() -> Basic {
        return Cos(simplify(arg))
    }
    
    func diff(dVar: Var) -> Basic {
        return simplify((arg as! Diff).diff(dVar)*Sin(arg)*Num(-1))
    }
    
    override var description: String {
        return "cos(\(arg))"
    }
}