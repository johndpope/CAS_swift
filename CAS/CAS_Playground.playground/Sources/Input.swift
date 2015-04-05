//
//  Input.swift
//  CAS
//
//  Created by Evan Peterson on 2/25/15.
//  Copyright (c) 2015 Evan Peterson. All rights reserved.
//

import Foundation

infix operator ^ { associativity left precedence 160 }

class CharObj:NSObject {
    var val: Character
    init(arg: Character) {
        val = arg
    }
    override var description:String {
        return String(val)
    }
}

func strInput(arg0: String) -> Basic {
    let arg1 = arg0.stringByReplacingOccurrencesOfString(" ", withString: "", options: .RegularExpressionSearch)
    var arg:[Character] = Array(arg1)
    
    var newArg:[CharObj] = []
    for i in arg {
        newArg+=[CharObj(arg: i)]
    }
    
    return convert(newArg)
}

func convert(arg: [AnyObject]) -> Basic {
//    let tempout = strAdd(strMul(strPow((strPar(arg)))))
    var tempout = arg
    let operations:[Character] =  Array(")^-*/+")
    for i in operations {
        tempout = strGen(tempout, i)
    }
//    println(tempout)
    
    //TODO: fix error when empty parentheses
    // fixed?
    
    var nums = true
    for (i1,i0) in enumerate(tempout) {
        if let i2 = i0 as? CharObj {
            let i3 = String(i2.val).toInt()
            if i3 != nil || i2.val=="." || (i1==0 && i2.val=="-") {
                
            } else {
                nums = false
            }
        } else {
            nums = false
        }
    }
    
    if tempout.count==0{
        return Var("EMPTY")
    }else if tempout.count==1 || nums {
        if let out = tempout[0] as? Basic {
            return out
        } else {
            return charNum(tempout, -1, true).0
        }
    }else {
        var tempout2: [AnyObject] = []
        for (i1,i2) in enumerate(tempout) {
            var remove = false
            if let i22 = i2 as? CharObj {
                if i22.val == ")" || i22.val == "(" {
                    remove = true
                }
            }
            if let i22 = i2 as? Basic {
                if i22 == Var("EMPTY") {
                    remove = true
                }
            }
            if !remove {
                tempout2 += [i2]
            }
        }
        if tempout2.count==1 {
            println("An attempt has been made to fix mismatched parentheses ")
            if let out = tempout2[0] as? Basic {
                return out
            } else {
                var temp12: Basic; var temp22: Int
                (temp12,temp22) = charNum(tempout2, -1, true)
                return temp12
            }
        } else if tempout2.count==0{
            return Var("EMPTY")
        }
    }


    //TODO: Remove extra parenteses
    
    println(tempout)
    return Var("ERROR2")
}

func charNum(arg: [AnyObject], initial:Int, dir: Bool) -> (Basic,Int) {
    // dir = true: right, dir = false: left
    
    var out0:[Character] = []
    var finPos = 0
    var array = Array(arg[initial+1..<arg.count])
    if !dir {
        array = Array(arg[0..<initial]).reverse()
    }
    
    for (i1,i2) in enumerate(array) {
        if let i3 = i2 as? CharObj {
            let i4 = String(i3.val).toInt()
            if i4 != nil || i3.val=="." || (i1==0 && i3.val=="-") {
                finPos = i1
                out0 += [i3.val]
            } else if out0.count == 0 {
                finPos = i1
                out0 = [i3.val]; break
            } else if let out1 = out0.last {
                if out1 == "-" {
                    finPos = i1
                    out0 += [i3.val]
                } else {
                    break
                }
            }else {
                break
            }
            
        } else {
            
            if let i3 = i2 as? [AnyObject] {
                return (convert(i3),finPos)
            } else if let i3 = i2 as? Basic {
                return (i3,finPos)
            } else {
                return (Var("ERROR"),finPos)
            }
        }
    }
    
    var out = String(out0)
    if !dir {
        out = String(out0.reverse())
    }
    
    if out != ""{
        let out1 = (out as NSString).doubleValue
        //TODO: Fix so works with 0.0 as well
        if out1 != 0 || out == "0" {
            return (Num(Double(out1)),finPos)
        } else {
            return (Var(out),finPos)
        }
    } else {
        return (Var("EMPTY"),0)
    }
}

func strGen(arg: [AnyObject], oper: Character) -> [AnyObject] {
    if oper == "-" {
        for (i11,i12) in enumerate(arg.reverse()) {
            if let i13 = i12 as? CharObj {
                if i13.val == "-" {
                    var value: Basic; var pos: Int
                    (value,pos) = charNum(arg, arg.count-i11-1, true)
                    let inside = -value; pos = (arg.count-i11)+pos
                    
                    if arg.count-1-i11-1 >= 0{
                        if let nextPos = arg[arg.count-1-i11-1] as? CharObj {
                            if !(nextPos.val=="*"||nextPos.val=="/"||nextPos.val=="+"||nextPos.val=="^"||nextPos.val=="-") {
                                
                                return strGen(Array(arg[0..<arg.count-i11-1]) + [CharObj(arg: "+") as AnyObject] + [inside] + Array(arg[pos+1..<arg.count]),oper)
                            }
                        }
                    }
                    return strGen(Array(arg[0..<arg.count-i11-1]) + [inside] + Array(arg[pos+1..<arg.count]),oper)
                }
            }
        }
        return arg
    }
    
    
    for (i1,i2) in enumerate(arg) {
        if let i3 = i2 as? CharObj {
            if i3.val == oper {
                var value1: Basic; var pos1: Int; var value2: Basic; var pos2: Int
                (value1,pos1) = charNum(arg, i1, false); (value2,pos2) = charNum(arg, i1, true)
                pos1 = i1-pos1-1; pos2 = i1+pos2+1
                
                var inside: Basic
                switch oper {
                case ")":
                    for (j1,j2) in enumerate(arg[0...i1].reverse()){
                        if let j3 = j2 as? CharObj {
                            if j3.val == "(" {
                                let in0:[AnyObject] = [convert(Array(arg[(i1-j1+1)..<i1]))]
                                return strGen(Array(arg[0..<i1-j1]) + in0 + Array(arg[i1+1..<arg.count]),")")
                            }
                        }
                    }
                    return arg
                case "^":
                    inside = value1^value2
                case "*":
                    inside = value1*value2
                case "/":
                    inside = value1/value2
                case "+":
                    //TODO: Allow '+' as prefix
                    inside = value1+value2

                default:
                    return strGen(Array(arg[0..<pos1]) + Array(arg[pos2+1..<arg.count]),oper)
                }
                
                //TODO: Return error instead of causing error
                if pos1 < 0 {
//                    pos1 = 0
                    return [Var("ERROR"+String(oper))]
                }
                return strGen(Array(arg[0..<pos1]) + [inside] + Array(arg[pos2+1..<arg.count]),oper)
            }
        }
    }
    
    return arg
}
