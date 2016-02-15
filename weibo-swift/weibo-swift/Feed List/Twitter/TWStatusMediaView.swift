//
//  TWStatusMediaView.swift
//  weibo-swift
//
//  Created by 马超 on 16/2/4.
//  Copyright © 2016年 马超. All rights reserved.
//

import UIKit

class TWStatusMediaView: YYControl {


    var imageViews: NSArray!
    var cell: TWeetCell!
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        
        self.width = kTWContentWidth
        self.clipsToBounds = true
        self.layer.cornerRadius = 2
        self.layer.borderColor = UIColor(white: 0.865, alpha: 1.000).CGColor;
        self.layer.borderWidth = CGFloatFromPixel(1)
        
        let imageVs = NSMutableArray()
        
        for var i = 0 ; i < 4 ; i++ {
            
            let imageView = UIImageView()
            imageView.backgroundColor = UIColor(white: 0.958, alpha: 1.000)
            imageView.clipsToBounds = true
            imageView.contentMode = UIViewContentMode.ScaleAspectFill
            imageView.layer.borderColor = self.layer.borderColor
            imageView.layer.borderWidth = self.layer.borderWidth
            self.addSubview(imageView)
            imageVs.addObject(imageView)
            
        }
        
        self.imageViews = imageVs
        
     
        self.touchBlock =  { (view :YYControl,  state :YYGestureRecognizerState, touches :NSSet , even :UIEvent ) -> Void in
        
            if state != YYGestureRecognizerState.Ended { return }
            
            let touch = touches.anyObject()! as! UITouch
            let p = touch.locationInView(self)
            
            let index = self.imageIndexForPoint(p)
            if index != NSNotFound {
                
                //点击了图片
                if self.cell.delegate != nil {
                    
                    self.cell.delegate!.cell(self.cell, didClickImageAtIndex: index!, withLongPress: false)
                    
                }
            }
        }
        
        self.longPressBlock = { (view :YYControl,point: CGPoint) -> Void in
            
            let index = self.imageIndexForPoint(point)
            if index != NSNotFound {
                
                //图片长按
                if self.cell.delegate != nil {
                    
                    self.cell.delegate!.cell(self.cell, didClickImageAtIndex: index!, withLongPress: true)
                    
                }
            }
        
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func imageIndexForPoint(p: CGPoint) -> Int? {
        
        for var i = 0 ; i < 4 ; i++ {
            
            let view = self.imageViews[i] as! UIImageView
            if !view.hidden && CGRectContainsPoint(view.frame, p) {
                return i
            }
            
        }
        
        return NSNotFound

    }
    
    func setWithMedias(medias: NSArray?) {
        
        if medias == nil {
        
            for var i = 0 ; i < 4 ; i++ {
                
                let view = self.imageViews[i] as! UIImageView
                view.hidden = true
                view.cancelCurrentImageRequest()
                
            }
            
            return
        }
        for var i = 0 ; i < 4 ; i++ {
            
            let view = self.imageViews[i] as! UIImageView
            if i >= medias!.count {
                
                view.hidden = true
                view.cancelCurrentImageRequest()
                
            }else {
                
                view.hidden = false
                let media: TWMedia = medias![i] as! TWMedia
                view.setImageWithURL(media.mediaSmall!.url!, options: YYWebImageOptions.SetImageWithFadeAnimation)
            }
        }

        //计算布局
        switch medias!.count {
            
        case 1:
            
            let view = self.imageViews.firstObject! as! UIImageView
            view.frame = self.bounds
            
        case 2:
            
            let view0 = self.imageViews[0] as! UIImageView
            view0.origin = CGPointZero
            view0.height = self.height
            view0.width = (self.width - kTWImagePadding) / 2
            
            let view1 = self.imageViews[1] as! UIImageView
            view1.top = 0
            view1.size = view0.size
            view1.right = self.width
            
        case 3 :
            
            let view0 = self.imageViews[0] as! UIImageView
            view0.origin = CGPointZero
            view0.height = self.height
            view0.width = (self.width - kTWImagePadding) / 2
            
            let view1 = self.imageViews[1] as! UIImageView
            view1.top = 0
            view1.size = view0.size
            view1.right = self.width
            view1.height = (self.height - kTWImagePadding) / 2
            
            let view2 = self.imageViews[2] as! UIImageView
            view2.size = view1.size
            view2.right = self.width
            view2.bottom = self.height
            
        case 4 :
            
            let  view0 = self.imageViews[0] as! UIImageView
            view0.origin = CGPointZero
            view0.width = (self.width - kTWImagePadding) / 2
            view0.height = (self.height - kTWImagePadding) / 2
            
            let view1 = self.imageViews[1] as! UIImageView
            view1.size = view0.size
            view1.top = 0
            view1.right = self.width
            
            let view2 = self.imageViews[2] as! UIImageView
            view2.size = view0.size
            view2.left = 0
            view2.bottom = self.height
            
            let view3 = self.imageViews[3] as! UIImageView
            view3.size = view0.size
            view3.right = self.width
            view3.bottom = self.height
            
        default :
            
            break
        }

    }

}
