//
//  MCImageDisplayExample.swift
//  weibo-swift
//
//  Created by 马超 on 15/12/16.
//  Copyright © 2015年 马超. All rights reserved.
//

import UIKit

class MCImageDisplayExample: UIViewController,UIGestureRecognizerDelegate {

    var scrollView :UIScrollView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(white: 0.863, alpha: 1.000)
        self.scrollView = UIScrollView()
        self.scrollView.frame = self.view.bounds
        if UIDevice.currentDevice().systemVersion > "7"
        {
            self.scrollView.height -= 44
        }
        self.view.addSubview(self.scrollView)
        
        
        let descLabel :UILabel = UILabel()
        descLabel.backgroundColor = UIColor.clearColor()
        descLabel.size = CGSizeMake(self.view.width, 60)
        descLabel.top = 20;
        descLabel.textAlignment = NSTextAlignment.Center
        descLabel.numberOfLines = 0
        descLabel.text = "Tap the image to pause/play\n Slide on the image to forward/rewind"
        self.scrollView.addSubview(descLabel)
        
        
        self.addImageWithName("niconiconi", text: "Animated GIF")
//        self.addImageWithName("wall-e", text: "wbpg")
        self.addImageWithName("pia", text: "Animated PNG (APNG)")
        self.addFrameImageWithText("重组动画")
        self.addSpriteSheetImageWithText("关键帧动画")
        
        
        self.scrollView.panGestureRecognizer.cancelsTouchesInView = true
        
        
        
    }

    
    //添加关键帧动画，就是可以便利一张图片上的位置，来生成的动画 
    func addSpriteSheetImageWithText(text :String)
    {
        let path :String = NSBundle.mainBundle().bundlePath + "/ResourceTwitter.bundle/fav02l-sheet@2x.png"
        let sheet :UIImage = UIImage(data: NSData(contentsOfFile: path)!, scale: 2)!
        
        let contentRects :NSMutableArray = NSMutableArray()
        let durations :NSMutableArray = NSMutableArray()
        
        // 8 * 12 sprites in a single sheet image
        let size = CGSizeMake(sheet.size.width / 8, sheet.size.height / 12)
        for (var j = 0 ; j < 12 ; j++) {
            for (var i = 0 ; i < 8 ; i++) {
                var rect :CGRect = CGRect()
                rect.size = size
                rect.origin.x = sheet.size.width / CGFloat(8) * CGFloat(i)
                rect.origin.y = sheet.size.height / CGFloat(12) * CGFloat(j)
                contentRects.addObject(NSValue(CGRect: rect))
                let value :NSValue = (1 / 60.0)
                durations.addObject(value)
            }
        }
        
        let sprit :YYSpriteSheetImage = YYSpriteSheetImage(spriteSheetImage: sheet, contentRects: contentRects as [AnyObject], frameDurations: durations as [AnyObject], loopCount: 0)
        
        self.addImage(sprit, size: size, text: text)
        
    }
    
    
    //添加frame动画，，可以g根据路径把多张图片拼接成一个动画
    func addFrameImageWithText(text :String)
    {
        let basePath :String = NSBundle.mainBundle().bundlePath.stringByAppendingString("/EmoticonWeibo.bundle/com.sina.default")
        
        let paths :NSMutableArray = NSMutableArray()
        
        paths.addObject(basePath + "/d_aini@3x.png")
        paths.addObject(basePath + "/d_baibai@3x.png")
        paths.addObject(basePath + "/d_chanzui@3x.png")
        paths.addObject(basePath + "/d_chijing@3x.png")
        paths.addObject(basePath + "/d_dahaqi@3x.png")
        paths.addObject(basePath + "/d_guzhang@3x.png")
        paths.addObject(basePath + "/d_haha@2x.png")
        paths.addObject(basePath + "/d_haixiu@3x.png")
        
        let image :UIImage = YYFrameImage(imagePaths: paths as [AnyObject], oneFrameDuration: 0.1, loopCount: 0)
        self.addImage(image, size: CGSizeZero, text: text)
        
        
    }
   
    func addImageWithName(name :String , text :String) -> Void
    {

        let image :YYImage = YYImage(named: name)
        self.addImage(image, size: CGSizeZero, text: text)
        
    }
    
    //添加图片的私有方法
    func addImage(image :UIImage , size :CGSize , text :String) -> Void
    {
        let imageView :YYAnimatedImageView = YYAnimatedImageView(image: image)
        if size.width > 0 && size.height > 0
        {
            imageView.size = size
        }
        imageView.centerX = self.view.width * 0.5
        imageView.top = (self.scrollView.subviews.last?.bottom)! + 30
        
        self.scrollView .addSubview(imageView)
        MCImageHelp.addTapControlToAnimatedImageView(imageView)
        MCImageHelp.addPanControlToAnimatedImageView(imageView)
        
        //遍历
        for  a :UIGestureRecognizer in imageView.gestureRecognizers!
        {
            a.delegate = self
        }
        
        //创建图片下方说明文字
        let imageLabel :UILabel = UILabel()
        imageLabel.backgroundColor = UIColor.clearColor()
        imageLabel.frame = CGRectMake(0, 0, self.view.width, 20)
        imageLabel.top = imageView.bottom + 10
        imageLabel.textAlignment = NSTextAlignment.Center
        imageLabel.text = text
        self.scrollView.addSubview(imageLabel)

        scrollView.contentSize = CGSizeMake(self.view.width, imageLabel.bottom + 20)

        
     
    }
    
    
     func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
    }

}
