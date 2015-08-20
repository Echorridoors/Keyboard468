
//
//  KeyboardViewController.swift
//  Geomekey
//
//  Created by Devine Lu Linvega on 2014-12-26.
//  Copyright (c) 2014 XXIIVV. All rights reserved.
//

import UIKit

var currentLetter:String = ""
var currentIndex:Int?
var debugDataSetAccess:Int = 0

class KeyboardViewController: UIInputViewController
{
	@IBOutlet var wrapper: UIView!
    @IBOutlet var nextKeyboardButton: UIButton!
	var geomekeyView: UIView!
	var keyTimer:NSTimer?
	var keyRepeatTimer:NSTimer?
	var interfaceReady:NSTimer?
	var isKeyHeld = 0
	var isAltKeyboard = 0
	
    override func updateViewConstraints() {
        super.updateViewConstraints()
        // Add custom view sizing constraints here
    }
	
	func textInject( character:String)
	{
		println("INSERT: \(character) - \(isKeyHeld)")
		var proxy = textDocumentProxy as! UITextDocumentProxy
		
		if( isKeyHeld == 1 ){
			if( character == "'" ){ proxy.insertText("\"") }
			else if( character == ":" ){ proxy.insertText(":") }
			else if( character == "." ){ proxy.insertText(",") }
			else if( character == "-" ){ proxy.insertText("_") }
			else if( character == "(" ){ proxy.insertText("[") }
			else if( character == ")" ){ proxy.insertText("]") }
			else if( character == "@" ){ proxy.insertText("#") }
			else if( character == "+" ){ proxy.insertText("*") }
			else if( character == "/" ){ proxy.insertText("\\") }
			else if( character == "!" ){ proxy.insertText("?") }
			else if( character == " " ){ proxy.insertText(". ") }
			else{ proxy.insertText(character.uppercaseString) }
			isKeyHeld = 0
		}
		else{
			proxy.insertText(character)
		}
		
	}
	
	func textBackspace()
	{
		var proxy = textDocumentProxy as! UITextDocumentProxy
		proxy.deleteBackward()
	}
	
    override func viewDidLoad()
	{
        super.viewDidLoad()
		
		loadInterface()
    
        // Perform custom UI setup here
        self.nextKeyboardButton = UIButton.buttonWithType(.System) as! UIButton
    
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
		if( view.frame.width > 0 ){
			println("Loading interface, done.")
			interfaceReady?.invalidate()
		}
		else{
			println("Trying to load interface, retrying in 0.1sec")
			return
		}
		
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
		for subview in view.subviews as! [UIView] {
			
			let destination:CGRect = subview.frame
			let offsetDistance:CGFloat = 40 * CGFloat(count)
			subview.frame = CGRectOffset(subview.frame, 0, 200 + offsetDistance )

			UIView.animateWithDuration(0.5, delay:0, options: .CurveEaseOut, animations: {
				subview.frame = destination
			}, completion: { finished in
			})
			count += 1
		}
	}

	func templateUpdate()
	{
		var targetLayout:Array = dataSetOrdered(currentLetter)

		for subview in view.subviews as! [UIView]
		{
			if ( subview is UIButton )
			{
				var button = subview as! UIButton
				var currentLetterId:Int = Int(subview.tag)
				if( currentLetterId < targetLayout.count )
				{
					var currentLetterString = targetLayout[currentLetterId]
					button.frame = keyboardKeyLayouts(currentLetterId)
					
					// Select Button Character
					var buttonChar = currentLetterString.uppercaseString
					
					if count(buttonChar) > 1 {
						if currentLetterString == "space" { buttonChar = "_"}
						else if currentLetterString == "back" { buttonChar = "<"}
						else if currentLetterString == "alt" { buttonChar = "∆"}
						else if currentLetterString == "keyboard" { buttonChar = "≡"}
						else if currentLetterString == "enter" { buttonChar = "¶"}
						else if currentLetterString == "plus" { buttonChar = "+"}
						else if currentLetterString == "minus" { buttonChar = "-"}
						else if currentLetterString == "dash" { buttonChar = "/"}
						else if currentLetterString == "atsign" { buttonChar = "@"}
						else if currentLetterString == "parenthesisleft" { buttonChar = "("}
						else if currentLetterString == "parenthesisright" { buttonChar = ")"}
						else if currentLetterString == "colon" { buttonChar = ","}
						else if currentLetterString == "period" { buttonChar = "."}
						else if currentLetterString == "apostrophe" { buttonChar = "'"}
						else if currentLetterString == "exclamation" { buttonChar = "!"}
						else{
							println("Missing character: \(count(buttonChar)) -> \(currentLetterString)")
						}
					}
		
					if currentLetterString == "a" || currentLetterString == "e" || currentLetterString == "i" || currentLetterString == "o" || currentLetterString == "u" { button.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal) }
					else{ button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal) }
					
					button.setTitle(buttonChar, forState: UIControlState.Normal)
				}
				else if( button.tag == 28 ){ button.frame = keyboardKeyLayouts(28) }
				else if( button.tag == 29 ){ button.frame = keyboardKeyLayouts(29) }
				else if( button.tag == 30 ){ button.frame = keyboardKeyLayouts(30) }
				else if( button.tag == 31 ){ button.frame = keyboardKeyLayouts(31) }
				else if( button.tag == 32 ){ button.frame = keyboardKeyLayouts(32) }
			}
		}
	}
	
	func createButton(letter:String, order:Int)
	{
		let buttonFrame:CGRect = keyboardKeyLayouts(order)
		
		// Button
		
		let button   = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
		
		button.frame = buttonFrame
		button.tag = order;

		button.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
		button.addTarget(self, action: "buttonDown:", forControlEvents: UIControlEvents.TouchDown)
		button.addTarget(self, action: "buttonDrag:", forControlEvents: UIControlEvents.TouchDragOutside)
		button.layer.cornerRadius = 2
		button.clipsToBounds = true
		
		// Select Button Character
		var buttonChar = letter.uppercaseString
		
		if count(buttonChar) > 1 {
			if letter == "space" { buttonChar = "_"}
			else if letter == "back" { buttonChar = "<"}
			else if letter == "alt" { buttonChar = "∆"}
			else if letter == "keyboard" { buttonChar = "≡"}
			else if letter == "enter" { buttonChar = "¶"}
			else{
				println("\(count(buttonChar)) -> \(letter)")
			}
		}
		
		if letter == "a" || letter == "e" || letter == "i" || letter == "o" || letter == "u" { button.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal) }
		else{ button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal) }
		
		button.setTitle(buttonChar, forState: UIControlState.Normal)
		button.titleLabel?.font = UIFont(name: "Input Mono", size: 16)
		
		view.addSubview(button)
	}
	
	@IBAction func buttonDown(sender: UIButton)
	{
		keyTimer?.invalidate()
		sender.backgroundColor = UIColor.whiteColor()
		sender.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
		keyTimer = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: Selector("keyHeld"), userInfo: nil, repeats: false)
		
		if(sender.tag == 32 ){
			keyRepeatTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("textBackspace"), userInfo: nil, repeats: true)
		}
	}
	
	@IBAction func buttonDrag(sender: UIButton)
	{
		templateUpdate()
		sender.backgroundColor = UIColor.blackColor()
		sender.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
	}
	
	func keyHeld()
	{
		isKeyHeld = 1
	}
	
	@IBAction func buttonAction(sender: UIButton)
	{
		keyTimer?.invalidate()
		keyRepeatTimer?.invalidate()
		sender.backgroundColor = UIColor.blackColor()
		sender.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
		
		let currentDataSetOrdered = dataSetOrdered(currentLetter)
		
		if( isAltKeyboard == 1 )
		{
			if(sender.tag == 0 ){ currentLetter = "'" }
			else if(sender.tag == 1 ){ currentLetter = ":" }
			else if(sender.tag == 2 ){ currentLetter = "." }
			else if(sender.tag == 3 ){ currentLetter = "-" }
				
			else if(sender.tag == 4 ){ currentLetter = "(" }
			else if(sender.tag == 5 ){ currentLetter = ")" }
			else if(sender.tag == 6 ){ currentLetter = "@" }
			else if(sender.tag == 7 ){ currentLetter = "+" }
			else if(sender.tag == 8 ){ currentLetter = "/" }
			else if(sender.tag == 9 ){ currentLetter = "!" }
				
			else if(sender.tag == 10 ){ currentLetter = currentDataSetOrdered[10] }
			else if(sender.tag == 11 ){ currentLetter = currentDataSetOrdered[11] }
			else if(sender.tag == 12 ){ currentLetter = currentDataSetOrdered[12] }
			else if(sender.tag == 13 ){ currentLetter = currentDataSetOrdered[13] }
			else if(sender.tag == 14 ){ currentLetter = currentDataSetOrdered[14] }
			else if(sender.tag == 15 ){ currentLetter = currentDataSetOrdered[15] }
			else if(sender.tag == 16 ){ currentLetter = currentDataSetOrdered[16] }
			else if(sender.tag == 17 ){ currentLetter = currentDataSetOrdered[17] }

			textInject(currentLetter)
			// currentLetter = ""
		}
		// Letter Mods
		else if(sender.tag == 29 ){
			// Space
			currentLetter = " "
			textInject(currentLetter)
		}
		else if(sender.tag == 28 ){
			// ALT, input nothing
            currentLetter = ""
		}
		else if(sender.tag == 31 ){
			advanceToNextInputMode()
		}
		else if(sender.tag == 32 ){
			currentLetter = ""
			textBackspace()
		}
		else if(sender.tag == 30 ){
			currentLetter = "\n"
			textInject(currentLetter)
		}
		else{
			currentLetter = currentDataSetOrdered[sender.tag].lowercaseString
			textInject(currentLetter)
			currentLetter = currentLetter.lowercaseString
		}

		currentIndex = sender.tag
		
		if(sender.tag == 28 && isAltKeyboard == 0 ){
			if( isKeyHeld == 1 ){
				isKeyHeld = 0
				isAltKeyboard = 2
			}
			else{
				isAltKeyboard = 1
			}
			templateUpdate()
		}
		else if( isAltKeyboard == 2 && sender.tag != 28)
        {
            isAltKeyboard = 0
            templateUpdate()
		}
		else{
			isAltKeyboard = 0
			templateUpdate()
		}
		
		sender.frame = self.keyboardKeyLayouts(sender.tag)
	}
	
	func loadInterface()
	{
		// load the nib file
		var calculatorNib = UINib(nibName: "geomekey", bundle: nil)
		// instantiate the view
		geomekeyView = calculatorNib.instantiateWithOwner(self, options: nil)[0] as! UIView
		
		// add the interface to the main view
		geomekeyView.backgroundColor = UIColor.blackColor()
		view.addSubview(geomekeyView)
		view.backgroundColor = UIColor.blackColor()
		
		interfaceReady = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("templateStart"), userInfo: nil, repeats: true)		
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
        var proxy = self.textDocumentProxy as! UITextDocumentProxy
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
		let dataSetTarget = dataSet(target)

		if(dataSetTarget.count > 0 ){ segment1.append(dataSetTarget[0]) }
		if(dataSetTarget.count > 1 ){ segment1.append(dataSetTarget[1]) }
		if(dataSetTarget.count > 2 ){ segment1.append(dataSetTarget[2]) }
		if(dataSetTarget.count > 3 ){ segment1.append(dataSetTarget[3]) }
		
		segment1 = segment1.sorted {$0.localizedCaseInsensitiveCompare($1) == NSComparisonResult.OrderedAscending }

		var segment2:[String] = []

		if(dataSetTarget.count > 4 ){ segment2.append(dataSetTarget[4]) }
		if(dataSetTarget.count > 5 ){ segment2.append(dataSetTarget[5]) }
		if(dataSetTarget.count > 6 ){ segment2.append(dataSetTarget[6]) }
		if(dataSetTarget.count > 7 ){ segment2.append(dataSetTarget[7]) }
		if(dataSetTarget.count > 8 ){ segment2.append(dataSetTarget[8]) }
		if(dataSetTarget.count > 9 ){ segment2.append(dataSetTarget[9]) }
		
		// Preserve Current Letter
		
		segment2 = segment2.sorted {$0.localizedCaseInsensitiveCompare($1) == NSComparisonResult.OrderedAscending }

		var segment3:[String] = []

		if(dataSetTarget.count > 10 ){ segment2.append(dataSetTarget[10]) }
		if(dataSetTarget.count > 11 ){ segment2.append(dataSetTarget[11]) }
		if(dataSetTarget.count > 12 ){ segment2.append(dataSetTarget[12]) }
		if(dataSetTarget.count > 13 ){ segment2.append(dataSetTarget[13]) }
		if(dataSetTarget.count > 14 ){ segment2.append(dataSetTarget[14]) }
		if(dataSetTarget.count > 15 ){ segment2.append(dataSetTarget[15]) }
		if(dataSetTarget.count > 16 ){ segment2.append(dataSetTarget[16]) }
		if(dataSetTarget.count > 17 ){ segment2.append(dataSetTarget[17]) }
		
		segment3 = segment3.sorted {$0.localizedCaseInsensitiveCompare($1) == NSComparisonResult.OrderedAscending }

		var segment4:[String] = []

		if(dataSetTarget.count > 18 ){ segment2.append(dataSetTarget[18]) }
		if(dataSetTarget.count > 19 ){ segment2.append(dataSetTarget[19]) }
		if(dataSetTarget.count > 20 ){ segment2.append(dataSetTarget[20]) }
		if(dataSetTarget.count > 21 ){ segment2.append(dataSetTarget[21]) }
		if(dataSetTarget.count > 22 ){ segment2.append(dataSetTarget[22]) }
		if(dataSetTarget.count > 23 ){ segment2.append(dataSetTarget[23]) }
		if(dataSetTarget.count > 24 ){ segment2.append(dataSetTarget[24]) }
		if(dataSetTarget.count > 25 ){ segment2.append(dataSetTarget[25]) }
		
		segment4 = segment4.sorted {$0.localizedCaseInsensitiveCompare($1) == NSComparisonResult.OrderedAscending }
        
        var returnArray = segment1 + segment2 + segment3 + segment4
        
		// ALT
		
        if( isAltKeyboard == 1 ){
            returnArray[0] = "apostrophe"
            returnArray[1] = "colon"
            returnArray[2] = "period"
            returnArray[3] = "minus"
            
            returnArray[4] = "parenthesisleft"
            returnArray[5] = "parenthesisright"
            returnArray[6] = "atsign"
            returnArray[7] = "plus"
            returnArray[8] = "dash"
            returnArray[9] = "exclamation"
            
            returnArray[10] = returnArray[18]
            returnArray[11] = returnArray[19]
            returnArray[12] = returnArray[20]
            returnArray[13] = returnArray[21]
            returnArray[14] = returnArray[22]
            returnArray[15] = returnArray[23]
            returnArray[16] = returnArray[24]
            returnArray[17] = returnArray[25]
		}
		if( isAltKeyboard == 2 ){
            
            returnArray[0] = "0"
            returnArray[1] = "1"
            returnArray[2] = "2"
            returnArray[3] = "3"
            
            returnArray[4] = "4"
            returnArray[5] = "5"
            returnArray[6] = "6"
            returnArray[7] = "7"
            returnArray[8] = "8"
            returnArray[9] = "9"
        }
        
		if( currentLetter != "" && isAltKeyboard == 0 && currentIndex < 18 && currentIndex != nil){
			
			// If the letter already exists in the array, remove to avoid duplicates

			if( find(returnArray,currentLetter) != nil ){
				returnArray.removeAtIndex( find(returnArray,currentLetter)! )
			}
			
			// Add letter at current position
			returnArray.insert(currentLetter, atIndex: currentIndex! )
		}
        
        
		return returnArray
	}
	
	func dataSet(target:String) -> Array<String>
	{
		debugDataSetAccess += 1
		
		var dataList = [""]
		
		let letterFreq = ["e","t","a","o","i","n","s","h","r","d","l","c","u","m","w","f","g","y","p","b","v","k","j","x","q","z"]

		if target == "a" { dataList = ["n","l","t","r","c","s","b","m","p","d","g","e","u","i","v","k","f","y","w","z","h","x","o","q","j","a"] }
		else if target == "b" { dataList = ["l","e","a","i","r","o","u","b","s","y","c","d","t","m","p","h","j","f","v","g","n","w","k","q","z"] }
		else if target == "c" { dataList = ["o","a","h","e","i","r","t","u","l","k","y","c","s","n","q","z","m","d","w","p","b","f"] }
		else if target == "d" { dataList = ["e","i","o","a","r","u","l","y","d","n","g","s","m","w","h","f","b","v","t","j","p","c","k","z","q"] }
		else if target == "e" { dataList = ["r","n","s","d","l","t","a","c","m","p","x","e","o","u","i","v","f","g","b","w","y","q","h","k","z","j"] }
		else if target == "f" { dataList = ["o","i","e","l","u","a","r","f","t","y","s","n","w","h","m","d","c","b","g","j","p","k","v"] }
		else if target == "g" { dataList = ["e","a","r","i","l","o","u","n","y","h","g","m","s","w","t","b","f","d","p","z","k","c","v","j"] }
		else if target == "h" { dataList = ["e","o","i","a","y","u","r","t","l","n","m","w","b","f","s","p","h","c","d","g","k","v","q","z"] }
		else if target == "i" { dataList = ["n","c","s","t","o","a","d","l","m","z","v","f","p","r","g","e","b","k","u","i","x","q","h","j","w","y"] }
		else if target == "j" { dataList = ["u","a","o","e","i","r","h","y","n","d","l","m","p","b","t"] }
		else if target == "k" { dataList = ["e","i","a","o","l","n","u","y","h","s","r","w","b","t","f","k","m","d","p","j","c","g","v","z"] }
		else if target == "l" { dataList = ["e","i","a","y","l","o","u","t","d","p","m","v","c","s","n","f","k","g","b","w","h","r","z","x","j","q"] }
		else if target == "m" { dataList = ["a","e","i","o","p","u","y","b","m","n","s","l","f","r","d","w","c","t","h","v","k","g","j","z","q"] }
		else if target == "n" { dataList = ["e","t","o","i","g","a","d","c","s","n","u","y","f","k","v","l","p","r","m","z","h","b","j","w","q","x"] }
		else if target == "o" { dataList = ["n","r","u","p","s","m","l","t","c","g","v","d","i","o","b","w","a","f","e","x","k","h","y","z","q","j"] }
		else if target == "p" { dataList = ["r","e","h","a","o","i","l","t","u","s","y","p","n","m","w","f","b","c","k","g","d","j","v","q"] }
		else if target == "q" { dataList = ["u","e","o","a","r","q","i"] }
		else if target == "r" { dataList = ["e","a","i","o","t","y","m","s","c","d","r","u","n","p","b","g","h","l","v","k","f","w","j","q","z","x"] }
		else if target == "s" { dataList = ["t","s","e","i","u","c","h","p","a","o","m","l","y","n","k","w","q","f","b","r","g","d","v","j","z"] }
		else if target == "t" { dataList = ["e","i","r","a","o","h","y","u","t","l","c","w","s","m","f","n","b","p","g","z","d","k","v","j","q"] }
		else if target == "u" { dataList = ["n","s","l","r","m","t","c","i","a","p","e","d","g","b","o","f","v","k","x","z","y","j","h","q","u","w"] }
		else if target == "v" { dataList = ["e","i","a","o","u","y","r","v","l","s","c","k","n","g"] }
		else if target == "w" { dataList = ["a","i","o","e","h","r","n","l","s","d","k","y","b","t","u","m","f","w","p","c","g","q","v","z"] }
		else if target == "x" { dataList = ["i","a","e","y","o","t","u","c","p","l","b","h","w","f","m","s","d","g","n","q","r","k"] }
		else if target == "y" { dataList = ["l","s","t","a","c","p","m","o","n","e","r","i","g","d","w","b","h","u","f","z","x","k","q","y","v"] }
		else if target == "z" { dataList = ["e","a","o","i","y","z","u","l","w","d","r","m","c","h","k","s","n","g","t","p","b","f","v"] }
		else { dataList = ["e","t","a","o","i","n","s","h","r","d","l","c","u","m","w","f","g","y","p","b","v","k","j","x","q","z"] }
		
		// Add missing letters

		for (index,element) in enumerate(letterFreq) {
			if(( find(dataList,element) ) == nil){
				dataList.append(element) 
			}
		}
		
		return dataList
	}

	func keyboardKeyLayouts(order:Int) -> CGRect
	{
		let vh = self.view!.frame.height
		let vw = self.view!.frame.width
		
		var buttonFrame:CGRect
		
		var letterWidth = vw/4
		var letterHeight = vh/3
		var marginTop:CGFloat = 0
		
		let firstRowLetterHeight = letterHeight
		
		buttonFrame = CGRectMake(0, 0, 0, 0)
		
		if order == 0 { buttonFrame = CGRectMake(letterWidth*0, 0, letterWidth, letterHeight) }
		if order == 1 { buttonFrame = CGRectMake(letterWidth*1, 0, letterWidth, letterHeight) }
		if order == 2 { buttonFrame = CGRectMake(letterWidth*2, 0, letterWidth, letterHeight) }
		if order == 3 { buttonFrame = CGRectMake(letterWidth*3, 0, letterWidth, letterHeight) }
		
		marginTop = marginTop + letterHeight
		letterWidth = vw/6
		letterHeight = vh/4
		
		let secondRowLetterHeight = letterHeight
		
		if order == 4 { buttonFrame = CGRectMake(letterWidth*0, marginTop, letterWidth, letterHeight) }
		if order == 5 { buttonFrame = CGRectMake(letterWidth*1, marginTop, letterWidth, letterHeight) }
		if order == 6 { buttonFrame = CGRectMake(letterWidth*2, marginTop, letterWidth, letterHeight) }
		if order == 7 { buttonFrame = CGRectMake(letterWidth*3, marginTop, letterWidth, letterHeight) }
		if order == 8 { buttonFrame = CGRectMake(letterWidth*4, marginTop, letterWidth, letterHeight) }
		if order == 9 { buttonFrame = CGRectMake(letterWidth*5, marginTop, letterWidth, letterHeight) }
		
		marginTop = marginTop + letterHeight
		letterWidth = vw/8
		letterHeight = vh/6
		
		let thirdRowLetterHeight = letterHeight
		
		if order == 10 { buttonFrame = CGRectMake(letterWidth*0, marginTop, letterWidth, letterHeight) }
		if order == 11 { buttonFrame = CGRectMake(letterWidth*1, marginTop, letterWidth, letterHeight) }
		if order == 12 { buttonFrame = CGRectMake(letterWidth*2, marginTop, letterWidth, letterHeight) }
		if order == 13 { buttonFrame = CGRectMake(letterWidth*3, marginTop, letterWidth, letterHeight) }
		if order == 14 { buttonFrame = CGRectMake(letterWidth*4, marginTop, letterWidth, letterHeight) }
		if order == 15 { buttonFrame = CGRectMake(letterWidth*5, marginTop, letterWidth, letterHeight) }
		if order == 16 { buttonFrame = CGRectMake(letterWidth*6, marginTop, letterWidth, letterHeight) }
		if order == 17 { buttonFrame = CGRectMake(letterWidth*7, marginTop, letterWidth, letterHeight) }
		
		marginTop = (firstRowLetterHeight + secondRowLetterHeight + thirdRowLetterHeight)
		letterWidth = vw/8
		letterHeight = vh-(firstRowLetterHeight + secondRowLetterHeight + thirdRowLetterHeight)
		
		if order == 28 { buttonFrame = CGRectMake(letterWidth*0, marginTop, letterWidth, letterHeight) } // skip
		if order == 29 { buttonFrame = CGRectMake(letterWidth*2, marginTop, letterWidth*4, letterHeight) } // space
		if order == 30 { buttonFrame = CGRectMake(vw-letterWidth, marginTop, letterWidth, letterHeight) } // return
		if order == 31 { buttonFrame = CGRectMake(letterWidth*1, marginTop, letterWidth, letterHeight) } // change
		if order == 32 { buttonFrame = CGRectMake(vw-(letterWidth*2), marginTop, letterWidth, letterHeight) } // backspace
		
		buttonFrame = CGRectMake(buttonFrame.origin.x + 1, buttonFrame.origin.y + 1, buttonFrame.size.width - 2, buttonFrame.size.height - 2)
		
		return buttonFrame
	}

}
