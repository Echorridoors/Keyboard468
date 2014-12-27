//
//  KeyboardViewController.swift
//  Geomekey
//
//  Created by Devine Lu Linvega on 2014-12-26.
//  Copyright (c) 2014 XXIIVV. All rights reserved.
//

import UIKit

var touchStart:CGPoint?
let tileSize:CGFloat = 40
var currentPosition:String?
var previousPosition:String?
var letterInsert:String?
var letterRelease:String?

class KeyboardViewController: UIInputViewController {

	@IBOutlet var wrapper: UIView!
    @IBOutlet var nextKeyboardButton: UIButton!
	var geomekeyView: UIView!
	
	@IBOutlet var pointer1: UIView!
	@IBOutlet var pointer2: UIView!
	
	@IBOutlet var someButton: UIButton!
	
    override func updateViewConstraints() {
        super.updateViewConstraints()
		println("yup")
        // Add custom view sizing constraints here
    }
	
	@IBAction func someBUtton(sender: AnyObject)
	{
		var proxy = textDocumentProxy as UITextDocumentProxy
		proxy.insertText("watwat")
	}
	
	override func touchesBegan(touches: NSSet, withEvent event: UIEvent)
	{
		let touchesFix = touches.anyObject() as UITouch
		var newPoint = touchesFix.locationInView(self.wrapper)
		touchStart = newPoint
		pointer1.frame = CGRectMake(newPoint.x, newPoint.y, 10, 10)
		
		letterRelease = ""
		letterInsert = ""
		
		previousPosition = ""
		currentPosition = ""
	}
	
	override func touchesMoved(touches: NSSet, withEvent event: UIEvent)
	{
		var render = 0
		
		let touchesFix = touches.anyObject() as UITouch
		var newPoint = touchesFix.locationInView(self.wrapper)
		
		var startPressX = touchStart?.x
		var startPressY = touchStart?.y
		
		letterInsert = ""
		
		if( startPressX! - newPoint.x > tileSize ){
			println("CADRAN LEFT: \(startPressX)")
			touchStart = newPoint
			currentPosition = "left"
			render = 1
		}
		if( startPressX! - newPoint.x < tileSize * -1 ){
			println("CADRAN RIGHT: \(startPressX)")
			touchStart = newPoint
			currentPosition = "right"
			render = 1
		}
		if( startPressY! - newPoint.y > tileSize ){
			println("CADRAN TOP: \(startPressX)")
			touchStart = newPoint
			currentPosition = "top"
			render = 1
		}
		if( startPressY! - newPoint.y < tileSize * -1 ){
			println("CADRAN DOWN: \(startPressX)")
			touchStart = newPoint
			currentPosition = "down"
			render = 1
		}
		
		if( previousPosition == "top" && currentPosition == "down"){
			currentPosition = "topdown"
			render = 1
		}
		
		if( render == 1 ){
			
			//TOP CLUSTER
			if( previousPosition == "" && currentPosition == "top" )    { letterRelease = "t" }
			if( previousPosition == "top" && currentPosition == "right"){ letterInsert = "h" }
			if( previousPosition == "top" && currentPosition == "left") { letterInsert = "s" }
			if( previousPosition == "top" && currentPosition == "top")  { letterInsert = "'" }
			if( previousPosition == "top" && currentPosition == "down" ){ letterRelease = "m" }
			
			//DOWN CLUSTER
			if( previousPosition == "" && currentPosition == "down" )    { letterRelease = "o" }
			if( previousPosition == "down" && currentPosition == "right"){ letterInsert = "d" }
			if( previousPosition == "down" && currentPosition == "left") { letterInsert = "r" }
			if( previousPosition == "down" && currentPosition == "top" ) { letterRelease = "w" }
			if( previousPosition == "down" && currentPosition == "down") { letterInsert = "," }
			
			//LEFT CLUSTER
			if( previousPosition == "" && currentPosition == "left" )    { letterRelease = "a" }
			if( previousPosition == "left" && currentPosition == "right"){ letterRelease = "y" }
			if( previousPosition == "left" && currentPosition == "left") { letterInsert = "<" }
			if( previousPosition == "left" && currentPosition == "top" ) { letterInsert = "n" }
			if( previousPosition == "left" && currentPosition == "down") { letterInsert = "c" }
			
			//RIGHT CLUSTER
			if( previousPosition == "" && currentPosition == "right" )    { letterRelease = "e" }
			if( previousPosition == "right" && currentPosition == "right"){ letterInsert = ">" }
			if( previousPosition == "right" && currentPosition == "left") { letterRelease = "u" }
			if( previousPosition == "right" && currentPosition == "top" ) { letterInsert = "i" }
			if( previousPosition == "right" && currentPosition == "down") { letterInsert = "l" }
			
			if( letterInsert != "" )
			{
				textInject(letterInsert!)
			}
			
			previousPosition = currentPosition
		}
		
		pointer1.frame = CGRectMake(startPressX!, startPressY!, 10, 10)
		pointer2.frame = CGRectMake(newPoint.x, newPoint.y, 10, 10)
	}
	
	override func touchesEnded(touches: NSSet, withEvent event: UIEvent)
	{
		if( letterRelease != "" ){
			textInject(letterRelease!)
		}
	}
	
	func textSetup()
	{
		letterRelease = ""
		letterInsert = ""
		
		previousPosition = ""
		currentPosition = ""
	}

	func textInject( character:String)
	{
		println("INSERT: \(character)")
		var proxy = textDocumentProxy as UITextDocumentProxy
		proxy.insertText(character)
		textSetup()
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		loadInterface()
    
        // Perform custom UI setup here
        self.nextKeyboardButton = UIButton.buttonWithType(.System) as UIButton
    
        self.nextKeyboardButton.setTitle(NSLocalizedString("Next Keyboard", comment: "Title for 'Next Keyboard' button"), forState: .Normal)
        self.nextKeyboardButton.sizeToFit()
        self.nextKeyboardButton.setTranslatesAutoresizingMaskIntoConstraints(false)
    
        self.nextKeyboardButton.addTarget(self, action: "advanceToNextInputMode", forControlEvents: .TouchUpInside)
        
        self.view.addSubview(self.nextKeyboardButton)
    
        var nextKeyboardButtonLeftSideConstraint = NSLayoutConstraint(item: self.nextKeyboardButton, attribute: .Left, relatedBy: .Equal, toItem: self.view, attribute: .Left, multiplier: 1.0, constant: 0.0)
        var nextKeyboardButtonBottomConstraint = NSLayoutConstraint(item: self.nextKeyboardButton, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
        self.view.addConstraints([nextKeyboardButtonLeftSideConstraint, nextKeyboardButtonBottomConstraint])
    }
	
	func loadInterface() {
		// load the nib file
		var calculatorNib = UINib(nibName: "geomekey", bundle: nil)
		// instantiate the view
		geomekeyView = calculatorNib.instantiateWithOwner(self, options: nil)[0] as UIView
		
		// add the interface to the main view
		view.addSubview(geomekeyView)
		
		// copy the background color
		view.backgroundColor = geomekeyView.backgroundColor
		
		pointer1.frame = CGRectMake(0, 0, 10, 10)
		pointer2.frame = CGRectMake(0, 0, 10, 10)
	}
	

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }

    override func textWillChange(textInput: UITextInput) {
        // The app is about to change the document's contents. Perform any preparation here.
    }

    override func textDidChange(textInput: UITextInput) {
        // The app has just changed the document's contents, the document context has been updated.
    
        var textColor: UIColor
        var proxy = self.textDocumentProxy as UITextDocumentProxy
        if proxy.keyboardAppearance == UIKeyboardAppearance.Dark {
            textColor = UIColor.whiteColor()
        } else {
            textColor = UIColor.blackColor()
        }
        self.nextKeyboardButton.setTitleColor(textColor, forState: .Normal)
    }

}
