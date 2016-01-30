//
//  TWStatusView.swift
//  weibo-swift
//
//  Created by 马超 on 16/1/30.
//  Copyright © 2016年 马超. All rights reserved.
//

import UIKit

class TWStatusView: YYControl {

    var cell: TWeetCell!
    
    
    func setWithLayout(layout: TWLayout) {
        
        self.height = layout.height
        self.topLine.hidden = !layout.showTopLine
        
        self.socialLabel.textLayout = layout.socialTextLayout
    }

    override init(frame: CGRect) {
        
        self.topLine = UIView()
        self.socialIconView = UIImageView()
        self.socialLabel = YYLabel()
        
        
        super.init(frame: frame)
        
        self.width = kScreenWidth
        self.backgroundColor = UIColor.whiteColor()
        self.exclusiveTouch = true
        self.clipsToBounds = true
        
        
        self.topLine.width = kScreenWidth
        self.topLine.height = CGFloatFromPixel(1)
        self.topLine.backgroundColor = UIColor(white: 0.823, alpha: 1.000)
        self.addSubview(self.topLine)
        
        
        self.socialLabel.textVerticalAlignment = YYTextVerticalAlignment.Center
        self.socialLabel.displaysAsynchronously = true
        self.socialLabel.ignoreCommonProperties = true
        self.socialLabel.fadeOnHighlight = false
        self.socialLabel.fadeOnAsynchronouslyDisplay = false
        self.socialLabel.size = CGSizeMake(kTWContentWidth, kTWUserNameSubFontSize * 2)
        self.socialLabel.left = kTWContentLeft
        self.socialLabel.centerY = kTWCellPadding + kTWUserNameSubFontSize / 2
        self.socialLabel.userInteractionEnabled = false
        self.addSubview(self.socialLabel)
        
        self.socialIconView.size = CGSizeMake(16, 16)
        self.socialIconView.centerY = self.socialLabel.centerY - 1
        self.socialIconView.right = kTWCellPadding + kTWAvatarSize
        self.socialIconView.contentMode = UIViewContentMode.ScaleAspectFit
        self.socialIconView.userInteractionEnabled = false
        self.addSubview(self.socialIconView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var topLine: UIView
    private var socialIconView: UIImageView
    private var socialLabel: YYLabel
}
