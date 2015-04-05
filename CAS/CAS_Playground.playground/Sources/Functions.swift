//
//  Functions.swift
//  CAS
//
//  Created by Evan Peterson on 3/21/15.
//  Copyright (c) 2015 Evan Peterson. All rights reserved.
//

import Foundation

@objc protocol Function: Basic {
    
}

class Log:NSObject,Function,Diff {
    var arg: Basic
    init(_ arg:Basic) {
        self.arg = arg
    }
    
    func sim() -> Basic {
        return Log(simplify(arg))
    }
    
    func diff(dVar: Var) -> Basic {
        return arg^Num(-1)
    }
    
    override var description: String {
        return "log(\(arg))"
    }
}