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
	
	
	func dataSet(){
	
//		a: n=16.210% l=14.568% t=14.195% r=10.176% c=6.912% s=5.171% b=5.064% m=4.195% p=4.023% d=3.725% g=3.052% e=2.608% u=2.033% i=1.846% v=1.198% k=1.041% f=0.938% y=0.695% w=0.575% z=0.526% h=0.418% x=0.415% o=0.167% q=0.143% j=0.058% a=0.044%
//		b: l=17.794% e=15.060% a=14.682% i=13.580% r=11.514% o=10.468% u=7.700% b=2.327% s=1.397% y=0.983% c=0.740% d=0.717% t=0.665% m=0.467% p=0.422% h=0.321% j=0.299% f=0.209% v=0.205% g=0.161% n=0.134% w=0.093% k=0.022% q=0.022% z=0.015%
//		c: o=20.811% a=16.729% h=14.334% e=10.216% i=7.048% r=6.699% t=5.881% u=5.188% l=4.251% k=3.528% y=3.112% c=1.410% s=0.421% n=0.194% q=0.050% z=0.043% m=0.038% d=0.014% w=0.013% p=0.007% b=0.007% f=0.004%
//		d: e=27.744% i=25.361% o=11.381% a=11.007% r=7.149% u=4.272% l=2.729% y=2.355% d=2.021% n=1.654% g=0.992% s=0.723% m=0.451% w=0.436% h=0.408% f=0.328% b=0.204% v=0.176% t=0.155% j=0.139% p=0.133% c=0.105% k=0.040% z=0.028% q=0.009%
//		e: r=21.117% n=13.720% s=10.833% d=8.337% l=6.612% t=5.970% a=5.168% c=4.474% m=3.585% p=2.908% x=2.738% e=2.371% o=2.318% u=2.300% i=1.332% v=1.015% f=1.012% g=1.006% b=0.772% w=0.608% y=0.563% q=0.462% h=0.402% k=0.182% z=0.106% j=0.090%
//		f: o=17.155% i=16.589% e=13.451% l=12.484% u=10.544% a=10.472% r=9.432% f=5.256% t=2.223% y=1.625% s=0.171% n=0.105% w=0.079% h=0.079% m=0.072% d=0.066% c=0.046% b=0.046% g=0.033% j=0.026% p=0.026% k=0.013% v=0.007%
//		g: e=17.649% a=13.966% r=12.663% i=12.536% l=9.725% o=8.520% u=6.482% n=4.632% y=4.127% h=3.810% g=2.676% m=1.414% s=0.559% w=0.329% t=0.230% b=0.226% f=0.136% d=0.123% p=0.107% z=0.033% k=0.025% c=0.021% v=0.008% j=0.004%
//		h: e=23.123% o=17.132% i=15.573% a=15.400% y=13.297% u=3.464% r=3.023% t=2.513% l=1.780% n=1.460% m=1.009% w=0.537% b=0.404% f=0.350% s=0.289% p=0.166% h=0.109% c=0.109% d=0.095% g=0.065% k=0.054% v=0.020% q=0.014% z=0.014%
//		i: n=19.675% c=13.060% s=11.182% t=8.071% o=7.785% a=7.516% d=5.369% l=4.947% m=3.005% z=2.518% v=2.501% f=2.307% p=2.230% r=2.127% g=1.968% e=1.965% b=1.331% k=0.914% u=0.877% i=0.200% x=0.193% q=0.097% h=0.067% j=0.037% w=0.032% y=0.026%
//		j: u=27.992% a=26.987% o=19.958% e=17.741% i=6.192% r=0.293% h=0.209% y=0.167% n=0.126% d=0.084% l=0.084% m=0.042% p=0.042% b=0.042% t=0.042%
//		k: e=34.017% i=18.734% a=12.784% o=5.597% l=5.393% n=4.768% u=3.084% y=2.962% h=2.649% s=2.160% r=1.766% w=1.005% b=0.910% t=0.842% f=0.815% k=0.720% m=0.706% d=0.299% p=0.299% j=0.163% c=0.163% g=0.095% v=0.054% z=0.014%
//		l: e=20.017% i=18.093% a=13.940% y=12.417% l=10.787% o=10.420% u=3.428% t=2.218% d=1.325% p=1.181% m=0.950% v=0.935% c=0.858% s=0.675% n=0.631% f=0.560% k=0.461% g=0.448% b=0.293% w=0.148% h=0.105% r=0.079% z=0.021% x=0.003% j=0.003% q=0.003%
//		m: a=22.239% e=19.785% i=19.341% o=15.400% p=5.855% u=4.606% y=3.800% b=3.623% m=2.911% n=1.174% s=0.316% l=0.271% f=0.185% r=0.091% d=0.070% w=0.068% c=0.063% t=0.055% h=0.050% v=0.034% k=0.026% g=0.021% j=0.008% z=0.008% q=0.003%
//		n: e=17.225% t=12.959% o=12.242% i=11.314% g=10.255% a=9.098% d=6.285% c=5.591% s=3.606% n=2.071% u=2.024% y=1.072% f=0.998% k=0.951% v=0.638% l=0.621% p=0.511% r=0.486% m=0.394% z=0.391% h=0.318% b=0.290% j=0.242% w=0.230% q=0.127% x=0.062%
//		o: n=15.524% r=11.107% u=7.706% p=7.613% s=6.841% m=6.823% l=6.395% t=6.010% c=5.344% g=4.665% v=3.711% d=3.530% i=2.467% o=2.323% b=2.121% w=1.757% a=1.267% f=1.065% e=0.954% x=0.869% k=0.729% h=0.389% y=0.302% z=0.286% q=0.134% j=0.072%
//		p: r=16.661% e=15.491% h=15.215% a=12.458% o=11.376% i=7.165% l=6.448% t=3.589% u=3.528% s=3.152% y=2.008% p=1.901% n=0.590% m=0.117% w=0.079% f=0.075% b=0.044% c=0.040% k=0.030% g=0.018% d=0.008% j=0.002% v=0.002% q=0.002%
//		q: u=99.635% e=0.091% o=0.091% a=0.046% r=0.046% q=0.046% i=0.046%
//		r: e=17.368% a=14.913% i=14.802% o=12.431% t=4.222% y=3.883% m=3.838% s=3.063% c=3.007% d=2.979% r=2.956% u=2.656% n=2.234% p=2.145% b=1.610% g=1.527% h=1.398% l=1.321% v=1.074% k=1.002% f=0.820% w=0.493% j=0.100% q=0.091% z=0.059% x=0.007%
//		s: t=19.285% s=10.149% e=9.633% i=9.576% u=7.644% c=6.541% h=6.366% p=5.951% a=5.921% o=5.063% m=4.181% l=2.188% y=1.958% n=1.448% k=1.097% w=0.984% q=0.801% f=0.308% b=0.230% r=0.184% g=0.179% d=0.159% v=0.094% j=0.049% z=0.011%
//		t: e=21.499% i=21.350% r=12.072% a=10.525% o=10.266% h=9.607% y=3.576% u=3.410% t=2.402% l=1.364% c=0.847% w=0.699% s=0.650% m=0.337% f=0.334% n=0.292% b=0.236% p=0.144% g=0.108% z=0.102% d=0.070% k=0.038% v=0.033% j=0.028% q=0.012%
//		u: n=37.203% s=15.536% l=9.359% r=9.257% m=5.863% t=4.438% c=2.816% i=2.544% a=2.395% p=2.229% e=2.100% d=1.624% g=1.367% b=1.263% o=0.598% f=0.379% v=0.299% k=0.224% x=0.217% z=0.080% y=0.066% j=0.038% h=0.038% q=0.027% u=0.024% w=0.016%
//		v: e=45.838% i=24.611% a=18.107% o=9.087% u=1.744% y=0.302% r=0.123% v=0.066% l=0.038% s=0.028% c=0.019% k=0.019% n=0.009% g=0.009%
//		w: a=23.647% i=16.779% o=16.412% e=14.446% h=9.947% r=4.216% n=3.979% l=2.084% s=1.445% d=1.149% k=0.853% y=0.817% b=0.805% t=0.663% u=0.604% m=0.568% f=0.462% w=0.343% p=0.343% c=0.237% g=0.154% q=0.024% v=0.012% z=0.012%
//		x: i=29.700% a=18.094% e=12.050% y=9.937% o=9.714% t=9.232% u=2.744% c=2.225% p=2.113% l=0.853% b=0.667% h=0.519% w=0.445% f=0.445% m=0.408% s=0.222% d=0.148% g=0.148% n=0.148% q=0.111% r=0.037% k=0.037%
//		y: l=15.983% s=10.095% t=8.919% a=8.022% c=7.723% p=7.239% m=6.135% o=6.094% n=5.042% e=4.733% r=4.228% i=3.702% g=2.506% d=2.475% w=1.464% b=1.433% h=1.072% u=0.949% f=0.897% z=0.557% x=0.474% k=0.155% q=0.041% y=0.031% v=0.031%
//		z: e=41.064% a=18.986% o=17.462% i=9.072% y=5.798% z=4.093% u=1.160% l=1.046% w=0.205% d=0.205% r=0.114% m=0.114% c=0.114% h=0.091% k=0.091% s=0.091% n=0.068% g=0.045% t=0.045% p=0.045% b=0.045% f=0.023% v=0.023%
		
	}

}
