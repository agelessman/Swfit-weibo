//
//  YYControl.swift
//  weibo-swift
//
//  Created by 马超 on 16/1/12.
//  Copyright © 2016年 马超. All rights reserved.
//

import UIKit

class YYControl: UIView {

    var image :UIImage? {
        set{
            
            self.layer.contents = newValue!.CGImage as? AnyObject
            
        }
        get {
            var re: UIImage?
           
            let content = self.layer.contents
           
            if let _ = content {
                let cg = content! as! CGImageRef
                re = UIImage(CGImage: cg)
            }
               
//                if let _ = content {
//                   let ref = content! as! CGImage
//                    if CFGetTypeID(ref) == CGImageGetTypeID() {
////                        re = UIImage(CGImage: ref, scale: self.layer.contents!.scale, orientation: UIImageOrientation.Up)
//                        re = UIImage(CGImage: ref, scale: self.layer.contents!.scale, orientation: UIImageOrientation.Up)
//                    }else {
//                        re = nil
//                    }
//                }else {
//
//                   re = nil
//                }
            
            
            return re

        }
    }
    var touchBlock :((view :YYControl,  state :YYGestureRecognizerState, touches :NSSet , even :UIEvent ) -> Void)?
    var longPressBlock :((view :YYControl,  point :CGPoint) -> Void)?
    var _point :CGPoint?
    var _timer :NSTimer?
    var _longPressDetected :Bool?
    
    func startTimer() {
        
        self._timer?.invalidate()
        self._timer = NSTimer(timeInterval: 0.5, target: self, selector: "timerFire", userInfo: nil, repeats: false)
        
        NSRunLoop.mainRunLoop().addTimer(self._timer!, forMode: NSRunLoopCommonModes)
    }
    
    func endTimer() {
        self._timer?.invalidate()
        self._timer = nil
        
    }
    
    func timerFire() {
        self.touchesCancelled(nil, withEvent: nil)
        self._longPressDetected = true
        if let _ = self.longPressBlock {
            self.longPressBlock!(view: self, point: self._point!)
        }
        
        self.endTimer()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self._longPressDetected = false
        if let _ = self.touchBlock {
            self.touchBlock!(view: self, state: YYGestureRecognizerState.Began, touches: touches as NSSet, even: event!)
        }
        
        if let _ = self.longPressBlock {
            let touch = touches.first
            self._point = touch!.locationInView(self)
            self.startTimer()
        }
        
        
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if self._longPressDetected! { return }
        if let _ = self.touchBlock {
            self.touchBlock!(view: self, state: YYGestureRecognizerState.Moved, touches: touches as NSSet, even: event!)
        }
        self.endTimer()
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if self._longPressDetected! { return }
        if let _ = self.touchBlock {
            self.touchBlock!(view: self, state: YYGestureRecognizerState.Ended, touches: touches as NSSet, even: event!)
        }
        self.endTimer()
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        
        if self._longPressDetected! { return }
        if let _ = self.touchBlock {
            self.touchBlock!(view: self, state: YYGestureRecognizerState.Cancelled, touches: touches! as NSSet, even: event!)
        }
        self.endTimer()
    }
}
