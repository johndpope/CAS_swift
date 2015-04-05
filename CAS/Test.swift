//
//  Test.swift
//  CAS
//
//  Created by Evan Peterson on 2/25/15.
//  Copyright (c) 2015 Evan Peterson. All rights reserved.
//

import Foundation

//var aa = Var("x")

infix operator ^ { associativity left precedence 160 }
infix operator ++{ associativity left precedence 140 }
infix operator **{ associativity left precedence 150 }
infix operator ^^{ associativity left precedence 160 }

func print1() {
    println("loaded")
    let x = Var("x")
    let a = x^Num(2)
    let b = x*x+x^Num(5)*Num(2)
    println("\(b)")
    println("\((b as! Diff).diff(x))") // BAD FORCE DOWNCAST
    
    println("-------------")
}


let π = Const("π",3.1415926535897932384626433)
