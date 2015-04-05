//
//  EqnView.swift
//  CAS
//
//  Created by Evan Peterson on 2/28/15.
//  Copyright (c) 2015 Evan Peterson. All rights reserved.
//

import Foundation
import Cocoa

class EquationText: NSTextField {
    
    init(text: String, size: Int, x: Float, y: Float) {
        super.init(frame:CGRect(x: CGFloat(x), y: CGFloat(y), width: 0, height: 0))
        self.editable = false
        self.drawsBackground = false
        self.bezeled = false
        self.stringValue = text
        //        self.selectable = true
        self.font = NSFont(name: self.font!.fontName, size: CGFloat(size))
        self.sizeToFit()
    }
    convenience init(text: String) {
        self.init(text:text, size:20, x:0, y:0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

func formatOut(expr: Basic, view: NSView!,x1:Float,y1:Float) -> (Float, Float) {
    //    var testText: NSTextField = NSTextField(frame: CGRect(x: 0, y: 0, width: 200.00, height: 40.00))
    var x = x1; var y = y1
    
    if let new = expr as? OperatorList {
        //        let tempView = EquationText(text:"\(expr)",size: 20,x: x,y: y)
        //        view.addSubview(tempView)
        //        x += Float(tempView.frame.width)
        
        //        var text = ""
        let tempView0 = EquationText(text:"(",size: 20,x: x,y: y)
        view.addSubview(tempView0)
        x += Float(tempView0.frame.width)-4
        for (i1,i) in enumerate(new.elements) {
            var x2:Float; var y2:Float
            (x2,y2) = formatOut(i, view, x, y)
            x = x2-4
            
            if i1 != new.elements.count-1 {
                let tempView = EquationText(text:new.symbol,size: 20,x: x,y: y)
                view.addSubview(tempView)
                x += Float(tempView.frame.width)-4
            }
        }
        let tempView3 = EquationText(text:")",size: 20,x: x,y: y)
        view.addSubview(tempView3)
        x += Float(tempView3.frame.width)-0
        
    } else if let new = expr as? Pow {
        //        let tempView1 = EquationText(text:"\(new.base)",size: 20,x: x,y: y)
        //        view.addSubview(tempView1)
        //        x += Float(tempView1.frame.width)
        //
        //        let tempView2 = EquationText(text:"\(new.exp)",size: 12,x: x-4,y: y+12)
        //        view.addSubview(tempView2)
        //        x += Float(tempView2.frame.width)
        
        var x2:Float; var y2:Float
        (x2,y2) = formatOut(new.base, view, x, y)
        x = x2-4
        
        var x22:Float; var y22:Float
        (x22,y22) = formatOut(new.exp, view, x, y+10)
        x = x22
    } else {
        let tempView = EquationText(text:"\(expr)",size: 20,x: x,y: y)
        view.addSubview(tempView)
        x += Float(tempView.frame.width)
    }
    //
    //    let textText = EquationText(text:"\(expr)")
    //    println(textText.frame)
    //    
    //    view.addSubview(textText)
    return (x,y)
}