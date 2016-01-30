//
//  WBStatusTitleView.swift
//  weibo-swift
//
//  Created by 马超 on 16/1/9.
//  Copyright © 2016年 马超. All rights reserved.
//

import UIKit



class WBStatusTitleView: UIView {

    var titleLabel :YYLabel!
    var arrowButton :UIButton!
    var cell :WBStatusCell!
    
    override init(var frame: CGRect) {
        
        if (frame.size.width == 0 && frame.size.height == 0) {
            frame.size.width = kScreenWidth
            frame.size.height = CGFloat(kWBCellTitleHeight)
        }
        
        super.init(frame: frame)
        
        titleLabel = YYLabel()
        titleLabel.size = CGSizeMake(kScreenWidth - 100, self.height)
        titleLabel.left = CGFloat(kWBCellPadding)
        titleLabel.displaysAsynchronously = true
        titleLabel.ignoreCommonProperties = true
        titleLabel.fadeOnHighlight = false
        titleLabel.fadeOnAsynchronouslyDisplay = true
        self.addSubview(titleLabel)
        
        let line = CALayer()
        line.size = CGSizeMake(self.width, CGFloatFromPixel(1))
        line.bottom = self.height
        line.backgroundColor = kWBCellLineColor.CGColor
        self.layer.addSublayer(line)
        
        self.exclusiveTouch = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
