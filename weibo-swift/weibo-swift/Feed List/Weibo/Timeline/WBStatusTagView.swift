//
//  WBStatusTagView.swift
//  weibo-swift
//
//  Created by 马超 on 16/1/12.
//  Copyright © 2016年 马超. All rights reserved.
//

import UIKit

class WBStatusTagView: UIView {

    var imageView :UIImageView!
    var button :UIButton!
    var label :YYLabel!
    var cell :WBStatusCell!
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.exclusiveTouch = true

        self.button                            = UIButton()
        self.button.setBackgroundImage(UIImage(color: kWBCellBackgroundColor), forState: UIControlState.Normal)
        self.button.setBackgroundImage(UIImage(color: UIColor(white: 0.000, alpha: 0.200)), forState: UIControlState.Highlighted)
        self.button.addBlockForControlEvents(UIControlEvents.TouchUpInside) { (sender) -> Void in
            self.cell.delegate.cellDidClickTag(self.cell)
        }
        self.button.hidden                     = true
        self.addSubview(self.button)


        self.label                             = YYLabel()
        self.label.textVerticalAlignment       = YYTextVerticalAlignment.Center
        self.label.displaysAsynchronously      = true
        self.label.ignoreCommonProperties      = true
        self.label.fadeOnAsynchronouslyDisplay = false
        self.label.fadeOnHighlight             = false
        self.label.highlightTapAction          = { (containerView :UIView! ,text: NSAttributedString! ,  range :NSRange!,  rect:CGRect!) ->Void in
            self.cell.delegate.cell(self.cell, didClickInLabel: containerView as! YYLabel, textRange: range)
        }
        self.addSubview(self.label)

        self.imageView                         = UIImageView()
        self.imageView.size                    = CGSizeMake(CGFloat(kWBCellTagPlaceHeight), CGFloat(kWBCellTagPlaceHeight))
        self.imageView.hidden                  = true
        self.addSubview(self.imageView)

        self.label.height                      = CGFloat(kWBCellTagPlaceHeight)
        self.button.height                     = CGFloat(kWBCellTagPlaceHeight)
        self.height                            = CGFloat(kWBCellTagPlaceHeight)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setWithLayout(layout :WBStatusLayout) {
        
   
        if layout.tagType == WBStatusTagType.Place {
            
            self.label.height                 = CGFloat(kWBCellTagPlaceHeight)
            self.imageView.hidden             = false
            self.button.hidden                = false

            self.label.left                   = self.imageView.right + 6
            self.label.width                  = (layout.tagTextLayout?.textBoundingRect.size.width)! + 6
            self.label.userInteractionEnabled = false
            self.label.textLayout             = layout.tagTextLayout

            self.width                        = self.label.right
            self.label.width                  = self.width
            self.button.width                 = self.width
            
        }else if layout.tagType == WBStatusTagType.Normal {
            
            self.imageView.hidden             = true
            self.button.hidden                = true

            self.label.left                   = 0
            self.label.width                  = layout.tagTextLayout!.textBoundingRect.size.width + 1
            self.label.userInteractionEnabled = true
            self.label.textLayout             = layout.textLayout
        }
    }

}
