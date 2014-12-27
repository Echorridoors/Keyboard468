//
//  KeyboardViewController.swift
//  Geomekey
//
//  Created by Devine Lu Linvega on 2014-12-26.
//  Copyright (c) 2014 XXIIVV. All rights reserved.
//

import UIKit

var currentLetter:String = "other"

class KeyboardViewController: UIInputViewController
{
	@IBOutlet var wrapper: UIView!
    @IBOutlet var nextKeyboardButton: UIButton!
	var geomekeyView: UIView!
	
    override func updateViewConstraints() {
        super.updateViewConstraints()
        // Add custom view sizing constraints here
    }
	
	override func touchesBegan(touches: NSSet, withEvent event: UIEvent)
	{
		let touchesFix = touches.anyObject() as UITouch
		var newPoint = touchesFix.locationInView(self.wrapper)
	}
	
	override func touchesMoved(touches: NSSet, withEvent event: UIEvent)
	{
	}
	
	override func touchesEnded(touches: NSSet, withEvent event: UIEvent)
	{
	}
	
	
	func textInject( character:String)
	{
		println("INSERT: \(character)")
		var proxy = textDocumentProxy as UITextDocumentProxy
		proxy.insertText(character)
	}
	
	func textBackspace()
	{
		var proxy = textDocumentProxy as UITextDocumentProxy
		proxy.deleteBackward()
	}
	
	func textEnter()
	{
		var proxy = textDocumentProxy as UITextDocumentProxy
		proxy.returnKeyType
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
		var targetLayout:Array = dataSet(currentLetter)
		
		var i = 0
		
		while( i < 27)
		{
			if(i < targetLayout.count){
				createButton(targetLayout[i], order: i)
			}
			
			i += 1
		}
		
		createButton("alt", order: 28) // skip
		createButton("space", order: 29) // space
		createButton("enter", order: 30) // return
		createButton("keyboard", order: 31) // change keyboard
		createButton("back", order: 32) // backspace
	}
	
	func templateErase()
	{
		var subViews = self.view.subviews
		for subview in subViews as [UIView]   {
			subview.removeFromSuperview()
		}
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
		if order == 29 { buttonFrame = CGRectMake(letterWidth*2, marginTop, letterWidth*4, letterHeight) } // space
		if order == 30 { buttonFrame = CGRectMake(vw-letterWidth, marginTop, letterWidth, letterHeight) } // return
		if order == 31 { buttonFrame = CGRectMake(letterWidth*1, marginTop, letterWidth, letterHeight) } // change
		if order == 32 { buttonFrame = CGRectMake(vw-(letterWidth*2), marginTop, letterWidth, letterHeight) } // backspace
		
		// Button
		
		let button   = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
		
		button.frame = CGRectMake(buttonFrame!.origin.x + 1, buttonFrame!.origin.y + 1, buttonFrame!.size.width - 2, buttonFrame!.size.height - 2)
		button.tag = order;
		if( letter == currentLetter ){
			button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
			button.backgroundColor = UIColor.redColor()
		}
		else{
			button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
			button.backgroundColor = UIColor.whiteColor()
		}
//		button.setTitle(letter.lowercaseString, forState: UIControlState.Normal)
		button.titleLabel!.font =  UIFont(name: "Apple SD Gothic Neo", size: 20)
		button.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
		button.addTarget(self, action: "buttonDown:", forControlEvents: UIControlEvents.TouchDown)
		button.layer.borderWidth = 1
		button.layer.borderColor = UIColor.blackColor().CGColor
		button.layer.cornerRadius = 2
		button.clipsToBounds = true
		
		if let image  = UIImage(named: "char.\(letter.lowercaseString)") {
			button.setImage(image, forState: UIControlState.Normal)
		}
		else{
			button.backgroundColor = UIColor.redColor()
		}
		
		var DynamicView=UIImageView(frame: CGRectMake(1, button.frame.height - 4, button.frame.width - 2, 4))
		DynamicView.image = UIImage(named: "halftone2")
		DynamicView.contentMode = UIViewContentMode.Center;
		DynamicView.alpha = 0.2
		DynamicView.clipsToBounds = true
		button.addSubview(DynamicView)
		
		view.addSubview(button)
	}
	
	@IBAction func buttonDown(sender: UIButton)
	{
//		sender.titleLabel?.frame = CGRectOffset(sender.titleLabel!.frame, 0, 4)
	}
	
	@IBAction func buttonAction(sender: UIButton)
	{
		var proxy = textDocumentProxy as UITextDocumentProxy
		proxy.insertText("")
		
		if(sender.tag == 29 ){
			currentLetter = " "
			textInject(currentLetter)
		}
		else if(sender.tag == 32 ){
			currentLetter = " "
			textBackspace()
		}
		else if(sender.tag == 30 ){
			currentLetter = " "
			textEnter()
		}
		else{
			currentLetter = dataSet(currentLetter)[sender.tag]
			textInject(currentLetter)
		}
		
		templateErase()
		templateStart()
		
	}
	
	func loadInterface() {
		// load the nib file
		var calculatorNib = UINib(nibName: "geomekey", bundle: nil)
		// instantiate the view
		geomekeyView = calculatorNib.instantiateWithOwner(self, options: nil)[0] as UIView
		
		// add the interface to the main view
		geomekeyView.backgroundColor = UIColor.whiteColor()
		view.addSubview(geomekeyView)
		view.backgroundColor = UIColor.whiteColor()
		
		NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("templateStart"), userInfo: nil, repeats: false)
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
	
	
	func dataSet(target:String) -> Array<String>
	{
		if target == "a" { return ["n","l","t","r","c","s","b","m","p","d","g","e","u","i","v","k","f","y","w","z","h","x","o","q","j","a"] }
		else if target == "b" { return ["l","e","a","i","r","o","u","b","s","y","c","d","t","m","p","h","j","f","v","g","n","w","k","q","z"] }
		else if target == "c" { return ["o","a","h","e","i","r","t","u","l","k","y","c","s","n","q","z","m","d","w","p","b","f"] }
		else if target == "d" { return ["e","i","o","a","r","u","l","y","d","n","g","s","m","w","h","f","b","v","t","j","p","c","k","z","q"] }
		else if target == "e" { return ["r","n","s","d","l","t","a","c","m","p","x","e","o","u","i","v","f","g","b","w","y","q","h","k","z","j"] }
		else if target == "f" { return ["o","i","e","l","u","a","r","f","t","y","s","n","w","h","m","d","c","b","g","j","p","k","v"] }
		else if target == "g" { return ["e","a","r","i","l","o","u","n","y","h","g","m","s","w","t","b","f","d","p","z","k","c","v","j"] }
		else if target == "h" { return ["e","o","i","a","y","u","r","t","l","n","m","w","b","f","s","p","h","c","d","g","k","v","q","z"] }
		else if target == "i" { return ["n","c","s","t","o","a","d","l","m","z","v","f","p","r","g","e","b","k","u","i","x","q","h","j","w","y"] }
		else if target == "j" { return ["u","a","o","e","i","r","h","y","n","d","l","m","p","b","t"] }
		else if target == "k" { return ["e","i","a","o","l","n","u","y","h","s","r","w","b","t","f","k","m","d","p","j","c","g","v","z"] }
		else if target == "l" { return ["e","i","a","y","l","o","u","t","d","p","m","v","c","s","n","f","k","g","b","w","h","r","z","x","j","q"] }
		else if target == "m" { return ["a","e","i","o","p","u","y","b","m","n","s","l","f","r","d","w","c","t","h","v","k","g","j","z","q"] }
		else if target == "n" { return ["e","t","o","i","g","a","d","c","s","n","u","y","f","k","v","l","p","r","m","z","h","b","j","w","q","x"] }
		else if target == "o" { return ["n","r","u","p","s","m","l","t","c","g","v","d","i","o","b","w","a","f","e","x","k","h","y","z","q","j"] }
		else if target == "p" { return ["r","e","h","a","o","i","l","t","u","s","y","p","n","m","w","f","b","c","k","g","d","j","v","q"] }
		else if target == "q" { return ["u","e","o","a","r","q","i"] }
		else if target == "r" { return ["e","a","i","o","t","y","m","s","c","d","r","u","n","p","b","g","h","l","v","k","f","w","j","q","z","x"] }
		else if target == "s" { return ["t","s","e","i","u","c","h","p","a","o","m","l","y","n","k","w","q","f","b","r","g","d","v","j","z"] }
		else if target == "t" { return ["e","i","r","a","o","h","y","u","t","l","c","w","s","m","f","n","b","p","g","z","d","k","v","j","q"] }
		else if target == "u" { return ["n","s","l","r","m","t","c","i","a","p","e","d","g","b","o","f","v","k","x","z","y","j","h","q","u","w"] }
		else if target == "v" { return ["e","i","a","o","u","y","r","v","l","s","c","k","n","g"] }
		else if target == "w" { return ["a","i","o","e","h","r","n","l","s","d","k","y","b","t","u","m","f","w","p","c","g","q","v","z"] }
		else if target == "x" { return ["i","a","e","y","o","t","u","c","p","l","b","h","w","f","m","s","d","g","n","q","r","k"] }
		else if target == "y" { return ["l","s","t","a","c","p","m","o","n","e","r","i","g","d","w","b","h","u","f","z","x","k","q","y","v"] }
		else if target == "z" { return ["e","a","o","i","y","z","u","l","w","d","r","m","c","h","k","s","n","g","t","p","b","f","v"] }
		else { return ["e","t","a","o","i","n","s","h","r","d","l","c","u","m","w","f","g","y","p","b","v","k","j","x","q","z"] }

	}

}
