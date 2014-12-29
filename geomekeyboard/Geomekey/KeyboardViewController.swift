//
//  KeyboardViewController.swift
//  Geomekey
//
//  Created by Devine Lu Linvega on 2014-12-26.
//  Copyright (c) 2014 XXIIVV. All rights reserved.
//

import UIKit

var currentLetter:String = ""

class KeyboardViewController: UIInputViewController
{
	@IBOutlet var wrapper: UIView!
    @IBOutlet var nextKeyboardButton: UIButton!
	var geomekeyView: UIView!
	var keyTimer:NSTimer?
	var isKeyHeld = 0
	var isAltKeyboard = 0
	
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
		println("INSERT: \(character) - \(isKeyHeld)")
		var proxy = textDocumentProxy as UITextDocumentProxy
		
		if( isKeyHeld == 1 ){
			if( character == "'" ){ proxy.insertText("0") }
			else if( character == "," ){ proxy.insertText("1") }
			else if( character == "." ){ proxy.insertText("2") }
			else if( character == "-" ){ proxy.insertText("3") }
			else if( character == "(" ){ proxy.insertText("4") }
			else if( character == ")" ){ proxy.insertText("5") }
			else if( character == ":" ){ proxy.insertText("6") }
			else if( character == ";" ){ proxy.insertText("7") }
			else if( character == "@" ){ proxy.insertText("8") }
			else if( character == "#" ){ proxy.insertText("9") }
			else{ proxy.insertText(character.uppercaseString) }
			isKeyHeld = 0
		}
		else{
			proxy.insertText(character)
		}
		
	}
	
	func textBackspace()
	{
		var proxy = textDocumentProxy as UITextDocumentProxy
		proxy.deleteBackward()
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
		var targetLayout:Array = dataSetOrdered(currentLetter)
		
		var i = 0
		
		while( i < 18)
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

		// Animate In
		var count = 0
		for subview in view.subviews as [UIView]   {
			
			let destination:CGRect = subview.frame
			let offsetDistance:CGFloat = 40 * CGFloat(count)
			subview.frame = CGRectOffset(subview.frame, 0, 200 + offsetDistance )

			UIView.animateWithDuration(0.6, delay:0, options: .CurveEaseOut, animations: {
				subview.frame = destination
			}, completion: { finished in
			})

			count += 1

		}
	}

	func templateUpdate()
	{
		var targetLayout:Array = dataSetOrdered(currentLetter)
		
		for subview in view.subviews as [UIView] {
			
			if ( subview is UIButton ) {
				var button = subview as UIButton
				
				var currentLetterId:Int = Int(subview.tag)
				
				if( currentLetterId < targetLayout.count ){
					
					var currentLetterString = targetLayout[currentLetterId]
					
					button.frame = keyboardKeyLayouts(currentLetterId)
					
					if let image  = UIImage(named: "char.\(currentLetterString)") {
						button.setImage(image, forState: UIControlState.Normal)
						
						if( currentLetter == currentLetterString ){
							button.layer.borderColor = UIColor(red: 1, green: 0.0, blue: 0.0, alpha: 1).CGColor
						}
						else{
							button.layer.borderColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1).CGColor
						}
						
					}
				}
			}
			
		}
	}
	
	func createButton(letter:String, order:Int)
	{
		let buttonFrame:CGRect = keyboardKeyLayouts(order)
		
		// Button
		
		let button   = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
		
		button.frame = buttonFrame
		button.tag = order;
		
		button.layer.borderWidth = 1
		
		if( letter == currentLetter ){
			button.layer.borderColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1).CGColor
		}
		else{
			button.layer.borderColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1).CGColor
		}
		
		button.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
		button.addTarget(self, action: "buttonDown:", forControlEvents: UIControlEvents.TouchDown)
		button.addTarget(self, action: "buttonDrag:", forControlEvents: UIControlEvents.TouchDragOutside)
		button.layer.cornerRadius = 2
		button.clipsToBounds = true
		
		if let image  = UIImage(named: "char.\(letter.lowercaseString)") {
			button.setImage(image, forState: UIControlState.Normal)
			button.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
		}
		else{
			button.backgroundColor = UIColor.redColor()
		}
		
		if( order < 10 && isAltKeyboard == 1 ){
			var numberImage=UIImageView(frame: CGRectMake( 4 , 3 , 9, 11))
			numberImage.image = UIImage(named:"char.\(order)")
			numberImage.alpha = 0.5
			button.addSubview(numberImage)
		}
		
		view.addSubview(button)
	}
	
	@IBAction func buttonDown(sender: UIButton)
	{
		keyTimer?.invalidate()
		sender.frame = CGRectMake(sender.frame.origin.x, sender.frame.origin.y + 6, sender.frame.width, sender.frame.height - 6)
		sender.backgroundColor = UIColor.whiteColor()
		keyTimer = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: Selector("keyHeld"), userInfo: nil, repeats: false)
		
		
	}
	
	@IBAction func buttonDrag(sender: UIButton)
	{
		templateUpdate()
	}
	
	func keyHeld()
	{
		isKeyHeld = 1
	}
	
	@IBAction func buttonAction(sender: UIButton)
	{
		keyTimer?.invalidate()
		
		if( isAltKeyboard == 1 )
		{
			if(sender.tag == 0 ){ currentLetter = "'" }
			else if(sender.tag == 1 ){ currentLetter = "," }
			else if(sender.tag == 2 ){ currentLetter = "." }
			else if(sender.tag == 3 ){ currentLetter = "-" }
				
			else if(sender.tag == 4 ){ currentLetter = "(" }
			else if(sender.tag == 5 ){ currentLetter = ")" }
			else if(sender.tag == 6 ){ currentLetter = ":" }
			else if(sender.tag == 7 ){ currentLetter = ";" }
			else if(sender.tag == 8 ){ currentLetter = "@" }
			else if(sender.tag == 9 ){ currentLetter = "#" }
				
			else if(sender.tag == 10 ){ currentLetter = dataSetOrdered(currentLetter)[10] }
			else if(sender.tag == 11 ){ currentLetter = dataSetOrdered(currentLetter)[11]}
			else if(sender.tag == 12 ){ currentLetter = dataSetOrdered(currentLetter)[12] }
			else if(sender.tag == 13 ){ currentLetter = dataSetOrdered(currentLetter)[13] }
			else if(sender.tag == 14 ){ currentLetter = dataSetOrdered(currentLetter)[14] }
			else if(sender.tag == 15 ){ currentLetter = dataSetOrdered(currentLetter)[15] }
			else if(sender.tag == 16 ){ currentLetter = dataSetOrdered(currentLetter)[16] }
			else if(sender.tag == 17 ){ currentLetter = dataSetOrdered(currentLetter)[17] }
			
			textInject(currentLetter)
			currentLetter = ""
		}
		// Letter Mods
		else if(sender.tag == 29 ){
			// Space
			currentLetter = " "
			textInject(currentLetter)
		}
		else if(sender.tag == 28 ){
			// ALT, input nothing
		}
		else if(sender.tag == 31 ){
			advanceToNextInputMode()
		}
		else if(sender.tag == 32 ){
			currentLetter = " "
			textBackspace()
		}
		else if(sender.tag == 30 ){
			currentLetter = "\n"
			textInject(currentLetter)
		}
		else{
			currentLetter = dataSetOrdered(currentLetter)[sender.tag].lowercaseString
			textInject(currentLetter)
			currentLetter = currentLetter.lowercaseString
		}
		
		if(sender.tag == 28 && isAltKeyboard == 0 ){
			isAltKeyboard = 1
			templateUpdate()
		}
		else{
			isAltKeyboard = 0
			templateUpdate()
		}
		
		UIView.animateWithDuration(0.3, delay:0, options: .CurveEaseOut, animations: {
			sender.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
			sender.frame = self.keyboardKeyLayouts(sender.tag)
			}, completion: { finished in
		})
		
	}
	
	func loadInterface() {
		// load the nib file
		var calculatorNib = UINib(nibName: "geomekey", bundle: nil)
		// instantiate the view
		geomekeyView = calculatorNib.instantiateWithOwner(self, options: nil)[0] as UIView
		
		// add the interface to the main view
		geomekeyView.backgroundColor = UIColor.blackColor()
		view.addSubview(geomekeyView)
		view.backgroundColor = UIColor.blackColor()
		
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
	
	func dataSetOrdered(target:String) -> Array<String>
	{
		var segment1:[String] = []

		if(dataSet(target).count > 0 ){ segment1.append(dataSet(target)[0]) }
		if(dataSet(target).count > 1 ){ segment1.append(dataSet(target)[1]) }
		if(dataSet(target).count > 2 ){ segment1.append(dataSet(target)[2]) }
		if(dataSet(target).count > 3 ){ segment1.append(dataSet(target)[3]) }
		
		segment1 = segment1.sorted {$0.localizedCaseInsensitiveCompare($1) == NSComparisonResult.OrderedAscending }

		var segment2:[String] = []

		if(dataSet(target).count > 4 ){ segment2.append(dataSet(target)[4]) }
		if(dataSet(target).count > 5 ){ segment2.append(dataSet(target)[5]) }
		if(dataSet(target).count > 6 ){ segment2.append(dataSet(target)[6]) }
		if(dataSet(target).count > 7 ){ segment2.append(dataSet(target)[7]) }
		if(dataSet(target).count > 8 ){ segment2.append(dataSet(target)[8]) }
		if(dataSet(target).count > 9 ){ segment2.append(dataSet(target)[9]) }
		
		segment2 = segment2.sorted {$0.localizedCaseInsensitiveCompare($1) == NSComparisonResult.OrderedAscending }

		var segment3:[String] = []

		if(dataSet(target).count > 10 ){ segment3.append(dataSet(target)[10]) }
		if(dataSet(target).count > 11 ){ segment3.append(dataSet(target)[11]) }
		if(dataSet(target).count > 12 ){ segment3.append(dataSet(target)[12]) }
		if(dataSet(target).count > 13 ){ segment3.append(dataSet(target)[13]) }
		if(dataSet(target).count > 14 ){ segment3.append(dataSet(target)[14]) }
		if(dataSet(target).count > 15 ){ segment3.append(dataSet(target)[15]) }
		if(dataSet(target).count > 16 ){ segment3.append(dataSet(target)[16]) }
		if(dataSet(target).count > 17 ){ segment3.append(dataSet(target)[17]) }
		
		segment3 = segment3.sorted {$0.localizedCaseInsensitiveCompare($1) == NSComparisonResult.OrderedAscending }

		var segment4:[String] = []

		if(dataSet(target).count > 18 ){ segment4.append(dataSet(target)[18]) }
		if(dataSet(target).count > 19 ){ segment4.append(dataSet(target)[19]) }
		if(dataSet(target).count > 20 ){ segment4.append(dataSet(target)[20]) }
		if(dataSet(target).count > 21 ){ segment4.append(dataSet(target)[21]) }
		if(dataSet(target).count > 22 ){ segment4.append(dataSet(target)[22]) }
		if(dataSet(target).count > 23 ){ segment4.append(dataSet(target)[23]) }
		if(dataSet(target).count > 24 ){ segment4.append(dataSet(target)[24]) }
		if(dataSet(target).count > 25 ){ segment4.append(dataSet(target)[25]) }
		
		segment4 = segment4.sorted {$0.localizedCaseInsensitiveCompare($1) == NSComparisonResult.OrderedAscending }

		// ALT
		
		if( isAltKeyboard == 1 ){
			segment1 = ["apostrophe","comma","period","dash"]
			segment2 = ["parenthesisleft","parenthesisright","colon","semicolon","atsign","hash"]
			segment3 = segment4
		}
		
		return segment1 + segment2 + segment3
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
	func keyboardKeyLayouts(order:Int) -> CGRect
	{
		let vh = self.view!.frame.height
		let vw = self.view!.frame.width
		
		var buttonFrame:CGRect
		
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
		
		buttonFrame = CGRectMake(buttonFrame.origin.x + 1, buttonFrame.origin.y + 1, buttonFrame.size.width - 2, buttonFrame.size.height - 2)
		
		return buttonFrame
	}

}
