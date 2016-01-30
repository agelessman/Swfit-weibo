//
//  MCTextEmoticonExampleController.swift
//  weibo-swift
//
//  Created by 马超 on 15/12/22.
//  Copyright © 2015年 马超. All rights reserved.
//

import UIKit

class MCTextEmoticonExampleController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.whiteColor()
        if self.respondsToSelector("setAutomaticallyAdjustsScrollViewInsets:")
        {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        

        var mapper = Dictionary<String,UIImage>()
        mapper["smile"] = self.imageWithName("002")
        mapper["cool"] = self.imageWithName("013")
        mapper["biggrin"] = self.imageWithName("047")
        mapper["arrow"] = self.imageWithName("007")
        mapper["confused"] = self.imageWithName("041")
        mapper["cry"] = self.imageWithName("010")
        mapper["wink"] = self.imageWithName("085")
        
        
        let parser = YYTextSimpleEmoticonParser()
        parser.emoticonMapper = mapper
        
        
        //作用，就是让每一行都保持一个固定的高度
        let mod = YYTextLinePositionSimpleModifier()
        mod.fixedLineHeight = 22
        
        
        let textView = YYTextView()
        textView.text = "Hahahah:smile:, it\'s emoticons::cool::arrow::cry::wink:\n\nYou can input \":\" + \"smile\" + \":\" to display smile emoticon, or you can copy and paste these emoticons.\n\nSee \'YYTextEmoticonExample.m\' for example."
        textView.font = UIFont.systemFontOfSize(17)
        textView.textParser = parser
        textView.size = self.view.size
        textView.linePositionModifier = mod
        textView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10)
        textView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.Interactive
        textView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0)
        textView.scrollIndicatorInsets = textView.contentInset
        self.view.addSubview(textView)
    
    }
    
    
    
    func imageWithName(name: String) -> UIImage
    {
        let pathName :String? = NSBundle.mainBundle().pathForResource("EmoticonQQ", ofType: "bundle")
        let bundle :NSBundle? = NSBundle(path: (pathName)!)
        let path =  bundle?.pathForScaledResource(name, ofType: "gif")
        let data = NSData(contentsOfFile: path!)
        let image = YYImage(data: data!, scale: 2)
        image?.preloadAllAnimatedImageFrames = true
        return image!
    }

}
