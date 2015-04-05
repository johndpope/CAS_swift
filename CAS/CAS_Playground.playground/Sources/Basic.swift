//
//  Basic.swift
//  CAS
//
//  Created by Evan Peterson on 2/25/15.
//  Copyright (c) 2015 Evan Peterson. All rights reserved.
//

import Foundation

extension String {
    subscript(i: Int) -> Character {
        return self[advance(startIndex, i)]
    }
    
    subscript(range: Range<Int>) -> String {
        return self[advance(startIndex, range.startIndex)..<advance(startIndex, range.endIndex)]
    }
}

//MARK: - Basic Objects

// For Add and Mul
@objc protocol OperatorList:Basic {
    var elements: [Basic] {get set}
    var symbol: String {get set}
}

// For all objects used by CAS
@objc protocol Basic {
    func sim() -> Basic
}

// 
class Var:NSObject,Basic {
    var name: String
    init(_ name: String){
        self.name = name
    }
    override var description: String {
        return name
    }
    
}

class Const:NSObject,Basic{
    var name: String
    var val: Double
    init(_ name:String,_ val: Double){
        self.name = name
        self.val  = val
    }
    override var description: String {
        return name
    }
}

class Num:NSObject,Basic {
    var val: Double
    init(_ val: Double){
        self.val = val
    }
    override var description: String {
        if isInt(self) {
            return "\(Int(val))"
        }
        return "\(val)"
    }
    
}

class Add:NSObject,OperatorList {
    var elements: [Basic]
    var symbol: String
    init(elements:[Basic]){
        self.elements = elements
        symbol = "+"
    }
    override var description: String {
        var out = "("
        for (j,i) in enumerate(elements){
            
            out+="\(i)\(symbol)"
        }
        return "\(out[0..<count(out)-1]))"
    }
}

class Mul:NSObject,OperatorList {
    var elements: [Basic]
    var symbol: String
    init(elements:[Basic]){
        self.elements = elements
        symbol = "*"
    }
    override var description: String {
        var out = "("
        for (j,i) in enumerate(elements){
//            if let i1=i as? Num {
//                if i1.val == -1 && (j != countElements(elements)-1){
//                    out+="-"; continue
//                }
//            }
            
            out+="\(i)\(symbol)"
        }
        return "\(out[0..<count(out)-1]))"
    }
}

class Pow:NSObject,Basic {
    var base: Basic; var exp: Basic
    init(_ base: Basic,_ exp:Basic) {
        self.base = base; self.exp = exp
    }
    override var description: String {
        if let base1 = self.base as? Pow {
            if let exp1 = self.exp as? OperatorList {
                return "(\(base))^\(exp)"
            }
            return "(\(base))^(\(exp))"
        }
        if let exp1 = self.exp as? OperatorList {
            return "(\(base))^\(exp)"
        }
        
        return "\(base)^(\(exp))"
    }
}

