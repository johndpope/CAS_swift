//
//  AppDelegate.swift
//  CAS
//
//  Created by Evan Peterson on 3/18/15.
//  Copyright (c) 2015 Evan Peterson. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!

    @IBOutlet weak var inputText: NSTextField!
    
    @IBOutlet weak var outInText: NSTextField!
    @IBOutlet weak var outputText: NSTextField!
    
    @IBOutlet weak var formatOutView: NSView!

    
    @IBAction func diffButton(sender: AnyObject) {
        let input = strInput(inputText.stringValue)
        outInText.stringValue = "\(input)"
        if let diffin = input as? Diff {
            let diffout = diffin.diff(Var("x"))
            outputText.stringValue = "\(diffout)"
            formatOutView.subviews = []
            formatOut(diffout,formatOutView,0,0,20)

            
        } else {
            outputText.stringValue = "Not differentiable"
            formatOutView.subviews = []
            formatOutView.addSubview(EquationText(text:"Not differentiable"))
        }
    }
    
    @IBAction func simButton(sender: AnyObject) {
        let input = strInput(inputText.stringValue)
        outInText.stringValue = "\(input)"
        let simout = input.sim()
        outputText.stringValue = "\(simout)"
        
        formatOutView.subviews = []
        formatOut(simout,formatOutView,0,0,20)
    }
    
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(sender: NSApplication) -> Bool {
        return true
    }

}

