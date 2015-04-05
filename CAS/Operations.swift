//
//  Operations.swift
//  CAS
//
//  Created by Evan Peterson on 2/25/15.
//  Copyright (c) 2015 Evan Peterson. All rights reserved.
//

import Foundation

//MARK: - Operators

infix operator ^ { associativity left precedence 160 }
infix operator ++{ associativity left precedence 140 }
infix operator **{ associativity left precedence 150 }
infix operator ^^{ associativity left precedence 160 }

func +(left: Basic, right: Basic) -> Basic  {
    var newElements: [Basic] = []
    
    if let l = left as? Add {
        newElements += l.elements
    } else if left != Num(0) {
        newElements += [left]
    }
    if let r = right as? Add {
        newElements += r.elements
    } else if right != Num(0) {
        newElements += [right]
    }
    
    if newElements.count == 1 {
        return newElements[0]
    }
    if newElements.count == 0 {
        return Num(0)
    }
    
    return Add(elements: newElements)
}
func -(left: Basic, right: Basic) -> Basic  {
    return left + Num(-1)*right
}

func *(left: Basic, right: Basic) -> Basic  {
    var newElements: [Basic] = []
    
    if left==Num(0) || right==Num(0) {
        return Num(0)
    }
    
    if let l = left as? Mul {
        newElements += l.elements
    } else if left != Num(1) {
        newElements += [left]
    }
    if let r = right as? Mul {
        newElements += r.elements
    } else if right != Num(1) {
        newElements += [right]
    }
    
    if newElements.count == 1 {
        return newElements[0]
    }
    if newElements.count == 0 {
        return Num(1)
    }
    
    return Mul(elements: newElements)
}
func /(left: Basic, right: Basic) -> Basic  {
    return left * right^(Num(-1))
}

func ^(base: Basic, exp: Basic)   -> Basic  {
    if base==Num(1) || exp==Num(0) {
        return Num(1)
    }
    if exp==Num(1) {
        return base
    }
    
    return Pow(base, exp)
}
func ^(base: Double, exp: Double) -> Double {
    return pow(base,exp)
}

func ++(left: Basic, right: Basic) -> Basic {
    if let l = left as? Num {
        if let r = right as? Num {
            return Num(l.val+r.val)
        }
    }
    return left+right
}
func **(left: Basic, right: Basic) -> Basic {
    if let l = left as? Num {
        if let r = right as? Num {
            return Num(l.val*r.val)
        }
    }
    return left*right
}
func ^^(left: Basic, right: Basic) -> Basic {
    if let l = left as? Num {
        if let r = right as? Num {
            return Num(pow(l.val,r.val))
        }
    }
    return left*right
}

prefix func -(arg: Basic) -> Basic {
    return Num(-1)*arg
}

func ==(left: Basic, right:Basic) -> Bool {
    if let l = left as? Var {
        if let r = right as? Var {
            return l.name==r.name
        }
    }
    if let l = left as? Num {
        if let r = right as? Num {
            return l.val==r.val
        }
    }
    if let l = left as? OperatorList {
        if let r = right as? OperatorList {
            return l.elements==r.elements
        }
    }
    if let l = left as? Pow {
        if let r = right as? Pow {
            return l.base==r.base && l.exp==r.exp
        }
    }
    
    return false
}
func ==(left: [Basic], right: [Basic]) -> Bool {
    if left.count != right.count {
        return false
    }
    var l = left; var r = right
    while l.count > 0 {
        var contains = false
        for (j1, j2) in enumerate(r) {
            if l[0]==j2 {
                contains = true
                l.removeAtIndex(0); r.removeAtIndex(j1)
                break
            }
        }
        if !contains {
            return false
        }
    }
    return true
}

func !=(left: Basic, right:Basic) -> Bool {
    return !(left==right)
}

//MARK: - Simplify

func multExpand(arg: Basic) -> (Basic,Num)   {
    var mult:Basic = Num(1); var elem: [Basic] = []
    var temp: [Basic]
    if let arg1 = arg as? Mul {
        temp = arg1.elements
    } else {
        temp = [arg]
    }
    
    for i in temp {
        i
        if let i1 = i as? Num {
            mult = mult**i
        } else {
            elem += [i]
        }
    }
    if elem.count == 1{
        return (elem[0],(mult as? Num)!)
    }
    return (Mul(elements: elem),(mult as? Num)!)
}
func powExpand(arg: Basic)  -> (Basic,Basic) {
    if let arg1 = arg as? Pow {
        return (arg1.base, arg1.exp)
    }
    return (arg,Num(1))
}

extension Var {
    func sim() -> Basic {
        return self
    }
}
extension Num {
    func sim() -> Basic {
        return self
    }
}
extension Add {
    func sim() -> Basic {
        var elem: [Basic] = self.elements
        var elemNew: [Basic] = []
        for i0 in elem {
            let i = i0.sim()
            
            if i==Num(0){
                continue
            }
            
            var i1: Basic; var i2: Num
            (i1, i2) = multExpand(i)
            var done = false
            for (pos,j0) in enumerate(elemNew) {
                var j = j0.sim()
                var j1: Basic; var j2: Num
                (j1,j2) = multExpand(j)
//                print("\(i1):\(i2),");println("\(j1):\(j2)")
                if j1==i1 {
                    elemNew[pos] = ((j2++i2)*j1).sim()
                    if elemNew[pos] == Num(0) {
                        elemNew.removeAtIndex(pos)
                    }
                    done = true; break
                }
            }
            if !done {
                elemNew += [i]
            }
        }
        
        if elemNew.count==1 {
            return elemNew[0]
        }
        if elemNew.count==0 {
            return Num(0)
        }
        
        return Add(elements: elemNew)
    }
}
extension Mul {
    func sim() -> Basic {
        var elem: [Basic] = self.elements
        var elemNew: [Basic] = []
        for i0 in elem {
            let i = simplify(i0)
            
            if i==Num(1){
                continue
            }
            if i==Num(0){
                return Num(0)
            }
            
            var i1: Basic; var i2: Basic
            (i1, i2) = powExpand(i)
            var done = false
            for (pos,j) in enumerate(elemNew) {
                var j1: Basic; var j2: Basic
                (j1,j2) = powExpand(j)
                
                if i2==Num(1) && j2==Num(1){
                    if let i11 = i1 as? Num {
                        if let j11 = j1 as? Num {
                            elemNew[pos] = (i11**j11).sim()
                            done = true; break
                        }
                    }
                }
                
                if j1==i1 {
                    elemNew[pos] = (j1^(j2++i2)).sim()
                    done = true; break
                }
            }
            if !done {
                elemNew += [i]
            }
        }
        
        if elemNew.count==1 {
            return elemNew[0]
        }
        if elemNew.count==0 {
            return Num(1)
        }
        
        return Mul(elements: elemNew)
    }
}
extension Pow {
    func sim() -> Basic {
        let base0 = simplify(self.base); let exp0 = simplify(self.exp)
        if let base1 = base0 as? Pow {
            return simplify(base1.base^(base1.exp*exp0))
        }
        return base0^exp0
    }
}

extension Const {
    func sim() -> Basic {
        return self
    }
}

func simplify(arg: Basic) -> Basic {
    return arg.sim()
}

//MARK: - Other functions

func isInt(arg: Basic) -> Bool {
    if let a = arg as? Num {
        return Double(Int(a.val)) == a.val
    }
    return false
}