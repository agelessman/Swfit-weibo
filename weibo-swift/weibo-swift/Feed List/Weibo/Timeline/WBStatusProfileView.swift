//
//  WBStatusProfileView.swift
//  weibo-swift
//
//  Created by 马超 on 16/1/9.
//  Copyright © 2016年 马超. All rights reserved.
//

import UIKit

class WBStatusProfileView: UIView {

    var avatarView :UIImageView!
    var avatarBadgeView :UIImageView!
    var nameLabel :YYLabel!
    var sourceLabel :YYLabel!
    var backgroundImageView :UIImageView!
    var arrowButton :UIButton!
    var followButton :UIButton!
    var verifyType :WBUserVerifyType!

    var cell :WBStatusCell!
    var _trackingTouch :Bool = false
    
    override init(var frame: CGRect) {
        
        if (frame.size.width == 0 && frame.size.height == 0) {
            frame.size.width = kScreenWidth
            frame.size.height = CGFloat(kWBCellTitleHeight)
        }
        
        super.init(frame: frame)
        self.exclusiveTouch = true
        
        //头像
        avatarView = UIImageView()
        avatarView.size = CGSizeMake(40, 40)
        avatarView.origin = CGPointMake(CGFloat(kWBCellPadding), CGFloat(kWBCellPadding + 3))
        avatarView.contentMode = UIViewContentMode.ScaleAspectFill
        self.addSubview(avatarView)
        
        //添加蒙版
        let avatarBorder = CALayer()
        avatarBorder.frame = avatarView.bounds
        avatarBorder.borderWidth = CGFloatFromPixel(1)
        avatarBorder.borderColor = UIColor(white: 0.000, alpha: 0.090).CGColor
        avatarBorder.cornerRadius = avatarView.height / 2
        avatarBorder.shouldRasterize = true
        avatarBorder.rasterizationScale = YYScreenScale()
        avatarView.layer.addSublayer(avatarBorder)
        
        //添加徽章
        avatarBadgeView = UIImageView()
//        avatarBadgeView.backgroundColor = UIColor.redColor()
        avatarBadgeView.size = CGSizeMake(14, 14)
        avatarBadgeView.center = CGPointMake(avatarView.right - 6, avatarView.bottom - 6)
        avatarBadgeView.contentMode = UIViewContentMode.ScaleAspectFill
        self.addSubview(avatarBadgeView)
        
        //姓名
        nameLabel = YYLabel()
        nameLabel.size = CGSizeMake(CGFloat(kWBCellNameWidth), 24)
        nameLabel.left = avatarView.right + CGFloat(kWBCellNamePaddingLeft)
        nameLabel.centerY = 27
        nameLabel.displaysAsynchronously = true
        nameLabel.ignoreCommonProperties = true //这个属性是yykit中专有属性，当为真的时候，对label用layout布局，为假时，响应其他属性
        nameLabel.fadeOnAsynchronouslyDisplay = false
        nameLabel.fadeOnHighlight = false
        nameLabel.lineBreakMode = NSLineBreakMode.ByClipping
        nameLabel.textVerticalAlignment = YYTextVerticalAlignment.Center
        self.addSubview(nameLabel)
        
        //时间和来源
        sourceLabel = YYLabel()
        sourceLabel.frame = nameLabel.frame
        sourceLabel.centerY = 47
        sourceLabel.displaysAsynchronously = true
        sourceLabel.ignoreCommonProperties = true //这个属性是yykit中专有属性，当为真的时候，对label用layout布局，为假时，响应其他属性
        sourceLabel.fadeOnAsynchronouslyDisplay = false
        sourceLabel.fadeOnHighlight = false
        sourceLabel.highlightTapAction = { (containerView :UIView! ,text: NSAttributedString! ,  range :NSRange!,  rect:CGRect!) ->Void in
           self.cell.delegate.cell(self.cell, didClickInLabel: containerView as! YYLabel, textRange: range)
        }
        self.addSubview(sourceLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setWithVerifyType(verifyType :WBUserVerifyType) {
        self.verifyType = verifyType
        switch verifyType {
        case .WBUserVerifyTypeStandard :
            avatarBadgeView.hidden = false
            avatarBadgeView.image = WBStatusHelper.imageNamed("avatar_vip")

        case .WBUserVerifyTypeClub :
            avatarBadgeView.hidden = false
            avatarBadgeView.image = WBStatusHelper.imageNamed("avatar_grassroot")
        default :
            avatarBadgeView.hidden = true
       }
    }
    
    //只有点击头像和姓名的时候跳转
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        _trackingTouch = false
        let t :UITouch = touches.first!
        var p :CGPoint = t.locationInView(avatarView)
        if (CGRectContainsPoint(avatarView.bounds, p)) {
            _trackingTouch = true
        }
        p = t.locationInView(nameLabel);
        if (CGRectContainsPoint(nameLabel.bounds, p) && nameLabel.textLayout.textBoundingRect.size.width > p.x) {
            _trackingTouch = true;
        }
        if (!_trackingTouch) {
            super.touchesBegan(touches, withEvent: event)
           
        }
    }
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if (!_trackingTouch) {
            super.touchesEnded(touches, withEvent: event)
            
        }else
        {
            self.cell.delegate.cell(self.cell, didClickUser: self.cell.statusView.layout.status!.user!)
        }
    }
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        if (!_trackingTouch) {
            super.touchesCancelled(touches, withEvent: event)
            
        }
    }
}
