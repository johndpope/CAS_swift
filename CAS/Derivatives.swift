//
//  Derivatives.swift
//  CAS
//
//  Created by Evan Peterson on 2/25/15.
//  Copyright (c) 2015 Evan Peterson. All rights reserved.
//

import Foundation

//MARK - Differentiation

infix operator ^ { associativity left precedence 160 }
infix operator ++{ associativity left precedence 140 }
infix operator **{ associativity left precedence 150 }
infix operator ^^{ associativity left precedence 160 }

protocol Diff: Basic {
    func diff(dVar: Var) -> Basic
}

extension Var:Diff {
    func diff(var dVar: Var) -> Basic {
        if (dVar as Basic)==self {
            return Num(1)
        } else {
            return Num(0)
        }
    }
}
extension Num:Diff {
    func diff(var dVar: Var) -> Basic {
        return Num(0)
    }
}

extension Const:Diff {
    func diff(var dVar: Var) -> Basic {
        return Num(0)
    }
}

extension Add:Diff {
    func diff(dVar: Var) -> Basic {
        var newElem:Basic = Num(0)
        for i in self.elements {
            newElem = newElem+(i as! Diff).diff(dVar) //BAD FORCE DOWNCAST
        }
        return newElem.sim()
    }
}
extension Mul:Diff {
    func diff(dVar: Var) -> Basic {
        let f = self.elements[0]
        var g: Basic = Num(1)
        for i in Array(self.elements[1..<self.elements.count]){
            g = g*i
        }
        g = g.sim()
//        var test = g
//        var test2: Basic = Var("x")
//        var test3: Diff = (g as Diff)
        let g1 = g as! Diff //TWO BAD FORCE DOWNCASTS
        let f1 = f as! Diff
        
        return ((f * g1.diff(dVar)) + g * f1.diff(dVar)).sim()
    }
}
extension Pow:Diff {
    func diff(dVar: Var) -> Basic {
        //f**(g-Num(1))*g*derivative(f,var=var)+f**g*functions.log(f)*derivative(g,var=var)
        let f = self.base as! Diff; let g = self.exp as! Diff // BAD FORCE DOWNCAST
//        return (f^(g-Num(1))*g*f.diff(dVar)).sim() //+f**g*log(f)*g.diff(dVar)

        return (f^(g-Num(1))*g*f.diff(dVar)).sim() + f^g*Log(f)*g.diff(dVar)
    }
}