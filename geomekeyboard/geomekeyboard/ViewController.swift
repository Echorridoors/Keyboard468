
//  Created by Devine Lu Linvega on 2014-12-26.
//  Copyright (c) 2014 XXIIVV. All rights reserved.

import UIKit

class ViewController: UIViewController
{
	@IBOutlet var tutorialLabel: UILabel!
	@IBOutlet var tutorialInput: UITextField!
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}

	override func didReceiveMemoryWarning()
	{
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	@IBAction func testInput(sender: UITextField)
	{
		textUpdate(sender.text!)
	}
	
	func textUpdate(text:String!)
	{
		if( text == nil || text == "" ){
			tutorialLabel.text = "Try typing: See you at 3pm."
			tutorialLabel.textColor = UIColor.blackColor()
		}
		else if( text.substringToIndex(text.startIndex.advancedBy(1)) == "s" ){
			tutorialLabel.text = "Hold a key down to capitalize it."
			tutorialLabel.textColor = UIColor.redColor()
		}
		else if( text == "See you at " || text == "See you at" ){
			tutorialLabel.text = "Hold/release the Diamond key for the numbers."
			tutorialLabel.textColor = UIColor.redColor()
		}
		else if( text == "See you at 3" ){
			tutorialLabel.text = "Tap the Diamond key to switch to accents."
			tutorialLabel.textColor = UIColor.redColor()
		}
		else if( text == "See you at 3pm." ){
			tutorialInput.text = ""
			tutorialLabel.textColor = UIColor.blackColor()
			textUpdate("Well done! Enjoy 468")
		}
		else {
			tutorialLabel.text = "Try typing: See you at 3pm."
			tutorialLabel.textColor = UIColor.blackColor()
		}
		
		NSLog("%@",text)
	}
	
	override func prefersStatusBarHidden() -> Bool
	{
		return true
	}
}
