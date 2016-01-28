//
//  MCImageProgressiveExample.swift
//  weibo-swift
//
//  Created by 马超 on 15/12/16.
//  Copyright © 2015年 马超. All rights reserved.
//

import UIKit

class MCImageProgressiveExample: UIViewController {

    var imageView :UIImageView!
    var seg0 :UISegmentedControl!
    var seg1 :UISegmentedControl!
    var slider0 :UISlider!
    var slider1 :UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.whiteColor()
        
        imageView = UIImageView()
        imageView.size = CGSizeMake(300, 300)
        imageView.backgroundColor = UIColor(white: 0.079, alpha: 1.00)
        imageView.centerX = self.view.width * 0.5
        
        
        seg0 = UISegmentedControl(items: ["baseLine","progressive/interlacd"])
        seg0.selectedSegmentIndex = 0
        seg0.size = CGSizeMake(imageView.width, 30)
        seg0.centerX = self.view.width * 0.5
        
        
        seg1 = UISegmentedControl(items: ["JPEG","PNG","GIF"])
        seg1.frame = seg0.frame
        seg1.selectedSegmentIndex = 0
        
        
        slider0 = UISlider()
        slider0.width = seg0.width
        slider0.sizeToFit()
        slider0.minimumValue = 0
        slider0.maximumValue = 1.05
        slider0.value = 0
        slider0.centerX = self.view.width * 0.5
        
        
        slider1 = UISlider()
        slider1.frame = slider0.frame
        slider1.minimumValue = 0
        slider1.maximumValue = 20.0
        slider1.value = 0
        
        
        imageView.top = 64 + 10
        seg0.top = imageView.bottom + 10
        seg1.top = seg0.bottom + 10
        slider0.top = seg1.bottom + 10
        slider1.top = slider0.bottom + 10
        
        
        
        view.addSubview(imageView)
        view.addSubview(seg0)
        view.addSubview(seg1)
        view.addSubview(slider0)
        view.addSubview(slider1)
        
        //添加点击时间
        seg0.addBlockForControlEvents(UIControlEvents.ValueChanged) { (sender) -> Void in
            self.change()
        }
        
        seg1.addBlockForControlEvents(UIControlEvents.ValueChanged) { (sender) -> Void in
            self.change()
        }
        
        slider0.addBlockForControlEvents(UIControlEvents.ValueChanged) { (sender) -> Void in
            self.change()
        }
        
        slider1.addBlockForControlEvents(UIControlEvents.ValueChanged) { (sender) -> Void in
            self.change()
        }
    }
    
    
    func change(){
    
        var name :String?
        if seg0.selectedSegmentIndex == 0
        {
            if seg1.selectedSegmentIndex == 0
            {
                name = "mew_baseline.jpg"
            }
            else if seg1.selectedSegmentIndex == 1
            {
                name = "mew_baseline.png"
            }
            else
            {
                name = "mew_baseline.gif"
            }
        }
        else
        {
            if seg1.selectedSegmentIndex == 0
            {
                name = "mew_progressive.jpg"
            }
            else if seg1.selectedSegmentIndex == 1
            {
                name = "mew_interlaced.png"
            }
            else
            {
                name = "mew_interlaced.gif"
            }
        }
        
        let data :NSData = NSData(named: name!)
        var progress :Float = slider0.value
        if progress > 1.0
        {
            progress = 1.0
        }
        
        let subData :NSData = data.subdataWithRange(NSMakeRange(0, Int(Float(data.length) * progress)))
        
        let decoder :YYImageDecoder = YYImageDecoder(scale: UIScreen.mainScreen().scale)
        //更新数据，，处于，当得到的数据不是完整数据的时候使用
        decoder.updateData(subData, final: false)
        
        let frame :YYImageFrame? = decoder.frameAtIndex(0, decodeForDisplay: true)
        if frame != nil
        {
            let image :UIImage = frame!.image.imageByBlurRadius(CGFloat(slider1.value), tintColor: nil, tintMode: CGBlendMode.Clear, saturation: 1, maskImage: nil)
            imageView.image = image
        }
        
    }


}
