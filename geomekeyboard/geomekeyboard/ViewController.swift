//
//  ViewController.swift
//  geomekeyboard
//
//  Created by Devine Lu Linvega on 2014-12-26.
//  Copyright (c) 2014 XXIIVV. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
	@IBOutlet var tutorialLabel: UILabel!
	@IBOutlet var tutorialInput: UITextField!
	
	var stage:Int = 1
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	@IBAction func testInput(sender: UITextField)
	{
		textUpdate(sender.text)
	}
	
	func textUpdate(text:String)
	{
		
		if( stage == 1 ){
			if( text == "" ){
				tutorialLabel.text = "Try typing: The help is on its way."
				tutorialLabel.textColor = UIColor.whiteColor()
			}
			else if( text.substringToIndex(advance(text.startIndex, 1)) == "t" ){
				tutorialLabel.text = "Hold a key down to capitalize it."
				tutorialLabel.textColor = UIColor.redColor()
			}
			else if( text == "The help is on its way" ){
				tutorialLabel.text = "Double tap the spacebar to insert a period."
				tutorialLabel.textColor = UIColor.redColor()
			}
			else if( text == "The help is on its way. " || text == "The help is on its way." ){
				tutorialInput.text = ""
				stage = 2
				textUpdate("")
			}
		}
		else if( stage == 2 )
		{
			if( text == "" ){
				tutorialLabel.text = "Well done, try typing: See you at 3pm."
				tutorialLabel.textColor = UIColor.greenColor()
			}
			else if( text.substringToIndex(advance(text.startIndex, 1)) == "s" ){
				tutorialLabel.text = "Hold a key down to capitalize it."
				tutorialLabel.textColor = UIColor.redColor()
			}
			else if( text == "See you at " || text == "See you at" ){
				tutorialLabel.text = "Hold/release the Diamond key for the numbers."
				tutorialLabel.textColor = UIColor.redColor()
			}
			else if( text == "See you at 3" ){
				tutorialLabel.text = "Tap the Diamond key to switch between accents and letters."
				tutorialLabel.textColor = UIColor.redColor()
			}
			else if( text == "See you at 3pm." ){
				tutorialInput.text = ""
				stage = 3
				textUpdate("")
			}
		}
		else if( stage == 3 )
		{
			if( text == "" ){
				tutorialLabel.text = "Well done, enjoy the keyboard!"
				tutorialLabel.textColor = UIColor.greenColor()
			}
		}
		NSLog("%@",text)
	}
	
}

