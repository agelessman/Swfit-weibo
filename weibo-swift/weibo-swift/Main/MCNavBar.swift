//
//  MCNavBar.swift
//  weibo-swift
//
//  Created by 马超 on 15/12/8.
//  Copyright © 2015年 马超. All rights reserved.
//

import UIKit

class MCNavBar: UINavigationBar {

    var previousSize :CGSize = CGSizeZero
    
    //重写系统方法
    override func sizeThatFits(var size: CGSize) -> CGSize {
        
        size = super.sizeThatFits(size)
        
        if UIApplication.sharedApplication().statusBarHidden
        {
            size.height = 64
        }
        
        return size
    }
    
    //重写布局
    override func layoutSubviews() {
        
        super.layoutSubviews()
        if self.bounds.size != self.previousSize
        {
            self.previousSize = self.bounds.size
            self.layer .removeAllAnimations()
            for  layer in self.layer.sublayers!
            {
                layer.removeAllAnimations()
            }
        }
    }
}

