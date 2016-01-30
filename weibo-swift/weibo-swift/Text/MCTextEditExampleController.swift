//
//  MCTextEditExampleController.swift
//  weibo-swift
//
//  Created by 马超 on 15/12/22.
//  Copyright © 2015年 马超. All rights reserved.
//

import UIKit

class MCTextEditExampleController: UIViewController,YYTextViewDelegate,YYTextKeyboardObserver {
    
    var textView :YYTextView!
    var imageView :UIImageView!
    var verticalSwitch :UISwitch!
    var debugSwitch :UISwitch!
    var exclusionSwitch :UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.whiteColor()
        if self.respondsToSelector("setAutomaticallyAdjustsScrollViewInsets:")
        {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        self.initImageView()
        
        let toobar :UIToolbar = UIToolbar()
        toobar.size = CGSizeMake(UIScreen.mainScreen().bounds.size.width, 40)
        toobar.top = 64
        toobar.backgroundColor = UIColor.redColor()
        self.view.addSubview(toobar)
        
        let text = NSMutableAttributedString(string: "It was the best of times, it was the worst of times, it was the age of wisdom, it was the age of foolishness, it was the season of light, it was the season of darkness, it was the spring of hope, it was the winter of despair, we had everything before us, we had nothing before us. We were all going direct to heaven, we were all going direct the other way.\n\n这是最好的时代，这是最坏的时代；这是智慧的时代，这是愚蠢的时代；这是信仰的时期，这是怀疑的时期；这是光明的季节，这是黑暗的季节；这是希望之春，这是失望之冬；人们面前有着各样事物，人们面前一无所有；人们正在直登天堂，人们正在直下地狱。")
        
        text.font = UIFont(name: "Times New Roman", size: 20)
        text.lineSpacing = 4
        text.firstLineHeadIndent = 20
        
        
        textView = YYTextView()
        textView.attributedText = text
        textView.size = self.view.size
        textView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10)
        textView.delegate = self
        textView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.Interactive;
        textView.contentInset = UIEdgeInsetsMake(toobar.bottom, 0, 0, 0);
        textView.scrollIndicatorInsets = textView.contentInset;
        textView.selectedRange = NSMakeRange(text.length, 0);
        self.view.insertSubview(textView, belowSubview: toobar)
        
        dispatch_after(UInt64(0.6 * 1000000000), dispatch_get_main_queue()) { () -> Void in
            self.textView.becomeFirstResponder()
        }
        
        
        let label0 = UILabel()
        label0.font = UIFont.systemFontOfSize(14.0)
        label0.backgroundColor = UIColor.clearColor()
        label0.text = "Vertical:"
        let str = label0.text! as NSString
        label0.size = CGSizeMake(str.widthForFont(label0.font) + 2, toobar.height)
        label0.left = 10
        toobar.addSubview(label0)
        
        verticalSwitch = UISwitch()
        verticalSwitch.sizeToFit()
        verticalSwitch.centerY = toobar.height / 2
        verticalSwitch.left = label0.right - 5
        verticalSwitch.layer.transformScale = 0.8
        verticalSwitch.addBlockForControlEvents(UIControlEvents.ValueChanged) { (sender) -> Void in
            self.textView.endEditing(true)
            if self.verticalSwitch.on
            {
                self.setExclusionPathEnabled(false)
                self.exclusionSwitch.on = false
            }
            
            self.exclusionSwitch.enabled = !self.verticalSwitch.on
            self.textView.verticalForm = self.verticalSwitch.on
        }
        toobar.addSubview(verticalSwitch)
        
        
        
        let label1 = UILabel()
        label1.font = UIFont.systemFontOfSize(14.0)
        label1.backgroundColor = UIColor.clearColor()
        label1.text = "Debug:"
        let str1 = label1.text! as NSString
        label1.size = CGSizeMake(str1.widthForFont(label1.font) + 2, toobar.height)
        label1.left = verticalSwitch.right + 5
        toobar.addSubview(label1)
        
        debugSwitch = UISwitch()
        debugSwitch.sizeToFit()
        debugSwitch.centerY = toobar.height / 2
        debugSwitch.left = label1.right - 5
        debugSwitch.layer.transformScale = 0.8
        debugSwitch.addBlockForControlEvents(UIControlEvents.ValueChanged) { (sender) -> Void in
            
            let swi = sender as! UISwitch
            MCTextExampleHelper.setDebug(swi.on)
        }
        toobar.addSubview(debugSwitch)
        
        
        
        let label2 = UILabel()
        label2.font = UIFont.systemFontOfSize(14.0)
        label2.backgroundColor = UIColor.clearColor()
        label2.text = "Exclusion:"
        let str2 = label2.text! as NSString
        label2.size = CGSizeMake(str2.widthForFont(label2.font) + 2, toobar.height)
        label2.left = debugSwitch.right + 5
        toobar.addSubview(label2)
        
        exclusionSwitch = UISwitch()
        exclusionSwitch.sizeToFit()
        exclusionSwitch.centerY = toobar.height / 2
        exclusionSwitch.left = label2.right - 5
        exclusionSwitch.layer.transformScale = 0.8
        exclusionSwitch.addBlockForControlEvents(UIControlEvents.ValueChanged) { (sender) -> Void in
            self.setExclusionPathEnabled(self.exclusionSwitch.on)
        }
        toobar.addSubview(exclusionSwitch)
        
        
        YYTextKeyboardManager.defaultManager().addObserver(self)
        
    }

    
    
    func initImageView()
    {
        let data :NSData = NSData(named: "dribbble256_imageio.png")
        let image :UIImage = UIImage(data: data)!
        imageView = YYAnimatedImageView(image: image)
        imageView.clipsToBounds = true
        imageView.userInteractionEnabled = true
        imageView.layer.cornerRadius = imageView.height / 2
        imageView.center = CGPointMake(UIScreen.mainScreen().bounds.size.width / 2, UIScreen.mainScreen().bounds.size.width / 2)
        
        let pan :UIPanGestureRecognizer = UIPanGestureRecognizer { (sender ) -> Void in
            
            let pan = sender as! UIPanGestureRecognizer
            let p :CGPoint = pan.locationInView(self.textView)
            self.imageView.center = p
            
            let path :UIBezierPath = UIBezierPath(roundedRect: self.imageView.frame, cornerRadius: self.imageView.layer.cornerRadius)
            self.textView.exclusionPaths = [path]
        }
        
        
        imageView .addGestureRecognizer(pan)
     
    }
    
    func setExclusionPathEnabled(enabled :Bool)
    {
        if enabled
        {
            self.textView.addSubview(self.imageView)
            let path = UIBezierPath(roundedRect: self.imageView.frame, cornerRadius: self.imageView.layer.cornerRadius)
            self.textView.exclusionPaths = [path]
        }else
        {
            self.imageView.removeFromSuperview()
            self.textView.exclusionPaths = nil
        }
    }
    
    
    func keyboardChangedWithTransition(transition: YYTextKeyboardTransition) {
        
        var clipped = false
        if self.textView.verticalForm && transition.toVisible
        {
            let rect = YYTextKeyboardManager.defaultManager().convertRect(transition.toFrame, toView: self.view)
            if CGRectGetMaxY(rect) == self.view.height
            {
                var textFrame = self.view.bounds
                textFrame.size.height -= rect.size.height
                self.textView.frame = textFrame
                clipped = true
            }
        }
        
        if clipped == false
        {
            self.textView.frame = self.view.bounds
        }
        
    }
    
    deinit
    {
        YYTextKeyboardManager.defaultManager().removeObserver(self)
    }

}
