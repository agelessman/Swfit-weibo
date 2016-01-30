//
//  MCTextAttachmentExampleController.swift
//  weibo-swift
//
//  Created by 马超 on 15/12/22.
//  Copyright © 2015年 马超. All rights reserved.
//

import UIKit

class MCTextAttachmentExampleController: UIViewController,UIGestureRecognizerDelegate {

    var label :YYLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.whiteColor()
        MCTextExampleHelper.addDebugOptionToViewController(self)
        
        let text :NSMutableAttributedString = NSMutableAttributedString()
        let font :UIFont = UIFont.systemFontOfSize(16.0)
        
        
        let title0 = "This is UIImage attachment:"
        text.appendAttributedString(NSAttributedString(string: title0))
        var image0 :UIImage = UIImage(named: "dribbble64_imageio")!
        image0 = UIImage(CGImage: image0.CGImage!, scale: 2, orientation: UIImageOrientation.Up)
        let attachText0:NSMutableAttributedString = NSMutableAttributedString.attachmentStringWithContent(image0, contentMode: UIViewContentMode.Center, attachmentSize: image0.size, alignToFont: font, alignment: YYTextVerticalAlignment.Center)
        text.appendAttributedString(attachText0)
        text.appendAttributedString(NSAttributedString(string: "\n"))
        
        
        
        let title1 = "This is UIView attachment: "
        text.appendAttributedString(NSAttributedString(string: title1))
        let switcher :UISwitch = UISwitch()
        switcher.sizeToFit()
        let attachText1:NSMutableAttributedString = NSMutableAttributedString.attachmentStringWithContent(switcher, contentMode: UIViewContentMode.Center, attachmentSize: switcher.size, alignToFont: font, alignment: YYTextVerticalAlignment.Center)
        text.appendAttributedString(attachText1)
        text.appendAttributedString(NSAttributedString(string: "\n"))
        
        
        let title2 = "This is Animated Image attachment:"
        text.appendAttributedString(NSAttributedString(string: title2))
        let names = ["001", "022", "019","056","085"]
        for name in names
        {
            let path :String = NSBundle.mainBundle().pathForScaledResource(name, ofType: "gif", inDirectory: "EmoticonQQ.bundle")!
            let data :NSData = NSData(contentsOfFile: path)!
            let image :YYImage = YYImage(data: data)!
            image.preloadAllAnimatedImageFrames = true
            
            let imageView :YYAnimatedImageView = YYAnimatedImageView(image: image)
            let attachText2:NSMutableAttributedString = NSMutableAttributedString.attachmentStringWithContent(imageView, contentMode: UIViewContentMode.Center, attachmentSize: imageView.size, alignToFont: font, alignment: YYTextVerticalAlignment.Center)
            text.appendAttributedString(attachText2)
        }
        
        let webImage :YYImage = YYImage(named: "pia")
        webImage.preloadAllAnimatedImageFrames = true
        let imageView :YYAnimatedImageView = YYAnimatedImageView(image: webImage)
        imageView.autoPlayAnimatedImage = false
        imageView.startAnimating()
        MCImageHelp.addTapControlToAnimatedImageView(imageView)
        let attachText3:NSMutableAttributedString = NSMutableAttributedString.attachmentStringWithContent(imageView, contentMode: UIViewContentMode.Center, attachmentSize: imageView.size, alignToFont: font, alignment: YYTextVerticalAlignment.Center)
        text.appendAttributedString(attachText3)
        text.appendAttributedString(NSAttributedString(string: "\n"))
        
        
        text.font = font
        
        label = YYLabel()
        label.userInteractionEnabled = true
        label.numberOfLines = 0
        label.size = CGSizeMake(260, 260)
        label.center = CGPointMake(self.view.width / 2, self.view.height / 2 );
        label.attributedText = text
        self.view.addSubview(label)
        
        
        label.layer.borderWidth = CGFloatFromPixel(1)
        label.layer.borderColor = UIColor.redColor().CGColor

        
        let dot = self.newDotView()
        dot.center = CGPointMake(label.width, label.height);
        dot.autoresizingMask = [UIViewAutoresizing.FlexibleLeftMargin,UIViewAutoresizing.FlexibleTopMargin];
        label.addSubview(dot)
        
        let ges :YYGestureRecognizer = YYGestureRecognizer()
        ges.action = {(gesture :YYGestureRecognizer! ,state :YYGestureRecognizerState!) in
            
            if state != YYGestureRecognizerState.Moved
            {
                return
            }
            
            let width :CGFloat = ges.currentPoint.x
            let height :CGFloat = ges.currentPoint.y
            self.label.width = width < 30 ? 30 : width;
            self.label.height = height < 30 ? 30 : height;
        
        }
        
        ges.delegate = self
        label.addGestureRecognizer(ges)
        
    }


    func newDotView() -> UIView
    {
        let view = UIView()
        view.size = CGSizeMake(50, 50)
        
        let dot = UIView()
        dot.size = CGSizeMake(10, 10)
        dot.backgroundColor = UIColor.redColor()
        dot.clipsToBounds = true
        dot.layer.cornerRadius = dot.height / 2
        dot.center = CGPointMake(view.width/2, view.height / 2)
        view.addSubview(dot)
        
        return view
        
    }
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        let p :CGPoint = gestureRecognizer.locationInView(label)
        if p.x < label.width - 20
        {
            return false
        }
        
        if p.y < label.height - 20
        {
            return false
        }
        
        return true
    }
}
