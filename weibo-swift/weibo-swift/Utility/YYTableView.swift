//
//  YYTableView.swift
//  weibo-swift
//
//  Created by 马超 on 16/1/13.
//  Copyright © 2016年 马超. All rights reserved.
//

import UIKit

class YYTableView: UITableView {
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        self.delaysContentTouches = false
        self.canCancelContentTouches = true
        self.separatorStyle = UITableViewCellSeparatorStyle.None
        
        // Remove touch delay (since iOS 8)
        let wrapView :UIView? = self.subviews.first
        
        if wrapView == nil { return }
        
        // UITableViewWrapperView
        if wrapView!.className().hasSuffix("WrapperView") {
            for gesture :UIGestureRecognizer in wrapView!.gestureRecognizers! {
                // UIScrollViewDelayedTouchesBeganGestureRecognizer
                if gesture.className().containsString("DelayedTouchesBegan") {
                    gesture.enabled = false
                    break
                }

            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func touchesShouldCancelInContentView(view: UIView) -> Bool {
        
        if view.isKindOfClass(UIControl.self) { return true }
        
        return super.touchesShouldCancelInContentView(view)
    }
}
