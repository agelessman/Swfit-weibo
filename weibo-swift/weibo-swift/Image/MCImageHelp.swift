//
//  MCImageHelp.swift
//  weibo-swift
//
//  Created by 马超 on 15/12/20.
//  Copyright © 2015年 马超. All rights reserved.
//

import UIKit




class MCImageHelp: NSObject {
    
    //tap
    class func addTapControlToAnimatedImageView( view :YYAnimatedImageView?) -> Void
    {
        if view == nil
        {
            return
        }
        
        view?.userInteractionEnabled = true
        
        let tap :UITapGestureRecognizer = UITapGestureRecognizer { (sender) -> Void in
            
            if view!.isAnimating()
            {
                view?.stopAnimating()
            }else
            {
                view?.startAnimating()
            }
            
            //添加弹簧效果
            let op :UIViewAnimationOptions = [UIViewAnimationOptions.CurveEaseOut,UIViewAnimationOptions.BeginFromCurrentState,UIViewAnimationOptions.AllowAnimatedContent]
            
            UIView.animateWithDuration(0.1, delay: 0, options: op, animations: { () -> Void in
                view?.layer.transformScale = 0.97
                }, completion: { (finished) -> Void in
                    UIView.animateWithDuration(0.1, delay: 0, options: op, animations: { () -> Void in
                        view?.layer.transformScale = 1.008
                        }, completion: { (finished) -> Void in
                            UIView.animateWithDuration(0.1, delay: 0, options: op, animations: { () -> Void in
                                view?.layer.transformScale = 1
                                }, completion: { (finished) -> Void in
                                    
                            })
                    })
            })
            
        }
        
        view?.addGestureRecognizer(tap)
    }

    
    //pan
    class func addPanControlToAnimatedImageView( view :YYAnimatedImageView?) -> Void
    {
        if view == nil
        {
            return
        }
        
        view?.userInteractionEnabled = true
        var previousIsPlaying :Bool = false
        
        let pan :UIPanGestureRecognizer = UIPanGestureRecognizer { (sender) -> Void in
            
            let image :YYImage = (view?.image)! as! YYImage
            
            if image.conformsToProtocol(YYAnimatedImage) == false
            {
                return
            }
            
            let gestrue :UIPanGestureRecognizer = sender as! UIPanGestureRecognizer
            
            let p :CGPoint = gestrue.locationInView(gestrue.view)
            let progress :CGFloat = p.x / (gestrue.view?.width)!
            
            if gestrue.state == UIGestureRecognizerState.Began
            {
                previousIsPlaying = (view?.isAnimating())!
                view?.stopAnimating()
                view?.currentAnimatedImageIndex = UInt(CGFloat(image.animatedImageFrameCount()) * progress)
            }else if  gestrue.state == UIGestureRecognizerState.Ended || gestrue.state == UIGestureRecognizerState.Cancelled
            {
                if previousIsPlaying
                {
                    view?.startAnimating()
                }
            }else
            {
                view?.currentAnimatedImageIndex = UInt(CGFloat(image.animatedImageFrameCount()) * progress)
            }
            
        }
        
        view?.addGestureRecognizer(pan)
    }
}


