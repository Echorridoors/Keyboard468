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
	
	@IBOutlet var row1order1button: UIButton!
	@IBOutlet var row1order2button: UIButton!
	@IBOutlet var row1order3button: UIButton!
	@IBOutlet var row1order4button: UIButton!
	
	@IBOutlet var wrapper: UIView!
    @IBOutlet var nextKeyboardButton: UIButton!
	var geomekeyView: UIView!
	
	@IBOutlet var someButton: UIButton!
	
    override func updateViewConstraints() {
        super.updateViewConstraints()
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
	}
	
	override func touchesMoved(touches: NSSet, withEvent event: UIEvent)
	{
	}
	
	override func touchesEnded(touches: NSSet, withEvent event: UIEvent)
	{
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
		self.nextKeyboardButton.hidden = true;
		
        self.view.addSubview(self.nextKeyboardButton)
    
        var nextKeyboardButtonLeftSideConstraint = NSLayoutConstraint(item: self.nextKeyboardButton, attribute: .Left, relatedBy: .Equal, toItem: self.view, attribute: .Left, multiplier: 1.0, constant: 0.0)
        var nextKeyboardButtonBottomConstraint = NSLayoutConstraint(item: self.nextKeyboardButton, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
        self.view.addConstraints([nextKeyboardButtonLeftSideConstraint, nextKeyboardButtonBottomConstraint])
    }
	
	func templateStart()
	{
		createButton("A", order: 0)
		createButton("B", order: 1)
		createButton("C", order: 2)
		createButton("D", order: 3)
		
		createButton("E", order: 4)
		createButton("F", order: 5)
		createButton("G", order: 6)
		createButton("H", order: 7)
		createButton("I", order: 8)
		createButton("J", order: 9)
		
		createButton("K", order: 10)
		createButton("L", order: 11)
		createButton("M", order: 12)
		createButton("N", order: 13)
		createButton("O", order: 14)
		createButton("P", order: 15)
		createButton("Q", order: 16)
		createButton("R", order: 17)
		
		createButton("S", order: 18)
		createButton("T", order: 19)
		createButton("U", order: 20)
		createButton("V", order: 21)
		
		createButton("W", order: 22)
		createButton("X", order: 23)
		createButton("Y", order: 24)
		createButton("Z", order: 25)
		createButton(">", order: 26)
		createButton("<", order: 27)
		
		
		createButton("!", order: 28) // skip
		createButton("-", order: 29) // space
		createButton("=", order: 30) // return
		createButton("?", order: 31) // change keyboard
	}
	
	func createButton(letter:String, order:Int)
	{
		let vh = self.view!.frame.height
		let vw = self.view!.frame.width
		
		var buttonFrame:CGRect?
		
		var letterWidth = vw/4
		var letterHeight = vh/3
		var marginTop:CGFloat = 0
		
		buttonFrame = CGRectMake(0, 0, 0, 0)
		
		if order == 0 { buttonFrame = CGRectMake(letterWidth*0, 0, letterWidth, letterHeight) }
		if order == 1 { buttonFrame = CGRectMake(letterWidth*1, 0, letterWidth, letterHeight) }
		if order == 2 { buttonFrame = CGRectMake(letterWidth*2, 0, letterWidth, letterHeight) }
		if order == 3 { buttonFrame = CGRectMake(letterWidth*3, 0, letterWidth, letterHeight) }
		
		marginTop = marginTop + letterHeight
		letterWidth = vw/6
		letterHeight = vh/4
		
		if order == 4 { buttonFrame = CGRectMake(letterWidth*0, marginTop, letterWidth, letterHeight) }
		if order == 5 { buttonFrame = CGRectMake(letterWidth*1, marginTop, letterWidth, letterHeight) }
		if order == 6 { buttonFrame = CGRectMake(letterWidth*2, marginTop, letterWidth, letterHeight) }
		if order == 7 { buttonFrame = CGRectMake(letterWidth*3, marginTop, letterWidth, letterHeight) }
		if order == 8 { buttonFrame = CGRectMake(letterWidth*4, marginTop, letterWidth, letterHeight) }
		if order == 9 { buttonFrame = CGRectMake(letterWidth*5, marginTop, letterWidth, letterHeight) }
		
		marginTop = marginTop + letterHeight
		letterWidth = vw/8
		letterHeight = vh/6
		
		if order == 10 { buttonFrame = CGRectMake(letterWidth*0, marginTop, letterWidth, letterHeight) }
		if order == 11 { buttonFrame = CGRectMake(letterWidth*1, marginTop, letterWidth, letterHeight) }
		if order == 12 { buttonFrame = CGRectMake(letterWidth*2, marginTop, letterWidth, letterHeight) }
		if order == 13 { buttonFrame = CGRectMake(letterWidth*3, marginTop, letterWidth, letterHeight) }
		if order == 14 { buttonFrame = CGRectMake(letterWidth*4, marginTop, letterWidth, letterHeight) }
		if order == 15 { buttonFrame = CGRectMake(letterWidth*5, marginTop, letterWidth, letterHeight) }
		if order == 16 { buttonFrame = CGRectMake(letterWidth*6, marginTop, letterWidth, letterHeight) }
		if order == 17 { buttonFrame = CGRectMake(letterWidth*7, marginTop, letterWidth, letterHeight) }
		
		marginTop = (vh/3) + (vh/4) + (vh/6)
		letterWidth = vw/8
		letterHeight = 54
		
		if order == 28 { buttonFrame = CGRectMake(letterWidth*0, marginTop, letterWidth, letterHeight) } // skip
		if order == 29 { buttonFrame = CGRectMake(letterWidth*2, marginTop, letterWidth*5, letterHeight) } // space
		if order == 30 { buttonFrame = CGRectMake(vw-letterWidth, marginTop, letterWidth, letterHeight) } // return
		if order == 31 { buttonFrame = CGRectMake(letterWidth*1, marginTop, letterWidth, letterHeight) } // change
		
		let button   = UIButton.buttonWithType(UIButtonType.System) as UIButton
		button.frame = buttonFrame!
		button.tag = order;
		button.backgroundColor = UIColor.greenColor()
		button.setTitle(letter, forState: UIControlState.Normal)
		button.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
		view.addSubview(button)
		
	}
	
	func loadInterface() {
		// load the nib file
		var calculatorNib = UINib(nibName: "geomekey", bundle: nil)
		// instantiate the view
		geomekeyView = calculatorNib.instantiateWithOwner(self, options: nil)[0] as UIView
		
		// add the interface to the main view
		view.addSubview(geomekeyView)
		
		NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("templateStart"), userInfo: nil, repeats: false)
		
		// copy the background color
		view.backgroundColor = geomekeyView.backgroundColor
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
	
	
	func dataSet()
	{
		let a = ["n","l","t","r","c","s","b","m","p","d","g","e","u","i","v","k","f","y","w","z","h","x","o","q","j","a"]
		let b = ["l","e","a","i","r","o","u","b","s","y","c","d","t","m","p","h","j","f","v","g","n","w","k","q","z"]
		let c = ["o","a","h","e","i","r","t","u","l","k","y","c","s","n","q","z","m","d","w","p","b","f"]
		let d = ["e","i","o","a","r","u","l","y","d","n","g","s","m","w","h","f","b","v","t","j","p","c","k","z","q"]
		let e = ["r","n","s","d","l","t","a","c","m","p","x","e","o","u","i","v","f","g","b","w","y","q","h","k","z","j"]
		let f = ["o","i","e","l","u","a","r","f","t","y","s","n","w","h","m","d","c","b","g","j","p","k","v"]
		let g = ["e","a","r","i","l","o","u","n","y","h","g","m","s","w","t","b","f","d","p","z","k","c","v","j"]
		let h = ["e","o","i","a","y","u","r","t","l","n","m","w","b","f","s","p","h","c","d","g","k","v","q","z"]
		let i = ["n","c","s","t","o","a","d","l","m","z","v","f","p","r","g","e","b","k","u","i","x","q","h","j","w","y"]
		let j = ["u","a","o","e","i","r","h","y","n","d","l","m","p","b","t"]
		let k = ["e","i","a","o","l","n","u","y","h","s","r","w","b","t","f","k","m","d","p","j","c","g","v","z"]
		let l = ["e","i","a","y","l","o","u","t","d","p","m","v","c","s","n","f","k","g","b","w","h","r","z","x","j","q"]
		let m = ["a","e","i","o","p","u","y","b","m","n","s","l","f","r","d","w","c","t","h","v","k","g","j","z","q"]
		let n = ["e","t","o","i","g","a","d","c","s","n","u","y","f","k","v","l","p","r","m","z","h","b","j","w","q","x"]
		let o = ["n","r","u","p","s","m","l","t","c","g","v","d","i","o","b","w","a","f","e","x","k","h","y","z","q","j"]
		let p = ["r","e","h","a","o","i","l","t","u","s","y","p","n","m","w","f","b","c","k","g","d","j","v","q"]
		let q = ["u","e","o","a","r","q","i"]
		let r = ["e","a","i","o","t","y","m","s","c","d","r","u","n","p","b","g","h","l","v","k","f","w","j","q","z","x"]
		let s = ["t","s","e","i","u","c","h","p","a","o","m","l","y","n","k","w","q","f","b","r","g","d","v","j","z"]
		let t = ["e","i","r","a","o","h","y","u","t","l","c","w","s","m","f","n","b","p","g","z","d","k","v","j","q"]
		let u = ["n","s","l","r","m","t","c","i","a","p","e","d","g","b","o","f","v","k","x","z","y","j","h","q","u","w"]
		let v = ["e","i","a","o","u","y","r","v","l","s","c","k","n","g"]
		let w = ["a","i","o","e","h","r","n","l","s","d","k","y","b","t","u","m","f","w","p","c","g","q","v","z"]
		let x = ["i","a","e","y","o","t","u","c","p","l","b","h","w","f","m","s","d","g","n","q","r","k"]
		let y = ["l","s","t","a","c","p","m","o","n","e","r","i","g","d","w","b","h","u","f","z","x","k","q","y","v"]
		let z = ["e","a","o","i","y","z","u","l","w","d","r","m","c","h","k","s","n","g","t","p","b","f","v"]

	}

}
