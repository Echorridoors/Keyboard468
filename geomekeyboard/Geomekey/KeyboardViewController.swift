//
//  KeyboardViewController.swift
//  Geomekey
//
//  Created by Devine Lu Linvega on 2014-12-26.
//  Copyright (c) 2014 XXIIVV. All rights reserved.
//

import UIKit

class KeyboardViewController: UIInputViewController {

	@IBOutlet var wrapper: UIView!
    @IBOutlet var nextKeyboardButton: UIButton!
	var geomekeyView: UIView!
	
	@IBOutlet var someButton: UIButton!
	
    override func updateViewConstraints() {
        super.updateViewConstraints()
    
        // Add custom view sizing constraints here
    }
	
	@IBAction func someBUtton(sender: AnyObject) {
		
		var proxy = textDocumentProxy as UITextDocumentProxy
		
		proxy.insertText("watwat")
		
	}
	
	override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
		
		let touchesFix = touches.anyObject() as UITouch
		var newPoint = touchesFix.locationInView(self.wrapper)
		println(newPoint.x)
		
	}
	
	override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
		
	}
	
	override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
		
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
