//
//  WBStatusView.swift
//  weibo-swift
//
//  Created by 马超 on 16/1/11.
//  Copyright © 2016年 马超. All rights reserved.
//

import UIKit
let tempImageView = UIImageView()

let topLineBG = UIImage(size: CGSizeMake(1, 3)) { (context :CGContextRef!) -> Void in
    CGContextSetFillColorWithColor(context, UIColor.blackColor().CGColor)
    CGContextSetShadowWithColor(context, CGSizeMake(0, 0), 0.8, UIColor(white: 0.000, alpha: 0.002).CGColor)
    CGContextAddRect(context, CGRectMake(-2, 3, 4, 4))
    CGContextFillPath(context)
}


let bottomLineBG = UIImage(size: CGSizeMake(1, 3)) { (context :CGContextRef!) -> Void in
    CGContextSetFillColorWithColor(context, UIColor.blackColor().CGColor);
    CGContextSetShadowWithColor(context, CGSizeMake(0, 0.4), 2, UIColor(white: 0.000, alpha: 0.008).CGColor);
    CGContextAddRect(context, CGRectMake(-2, -2, 4, 2));
    CGContextFillPath(context);
}


class WBStatusView: UIView {

   
    static let a  = 3
    
    var cell :WBStatusCell!

    var contentView :UIView!              // 容器
    var titleView :WBStatusTitleView?     // 标题栏
    var profileView :WBStatusProfileView! // 用户资料
    var textLabel :YYLabel!               // 文本
    var picViews :NSArray?                // 图片 Array<UIImageView>
    var retweetBackgroundView :UIView?    //转发容器
    var retweetTextLabel :YYLabel?        // 转发文本
    var cardView :WBStatusCardView?       // 卡片
    var tagView :WBStatusTagView?         // 下方Tag
    var toolbarView :WBStatusToolbarView! // 工具栏
    var vipBackgroundView :UIImageView?   // VIP 自定义背景
    var menuButton :UIButton?             // 菜单按钮
    var followButton :UIButton?           // 关注按钮
    
    var _touchRetweetView = false
    
    
    func initLabel(var label :YYLabel , superView : UIView) {
        label                             = YYLabel()
        label.left                        = CGFloat(kWBCellPadding)
        label.width                       = CGFloat(kWBCellContentWidth)
        label.textVerticalAlignment       = YYTextVerticalAlignment.Top
        label.displaysAsynchronously      = true
        label.ignoreCommonProperties      = true
        label.fadeOnAsynchronouslyDisplay = false
        label.fadeOnHighlight             = false
        superView.addSubview(label)
    }
    
    
    override init(var frame: CGRect) {
        
        if (frame.size.width == 0 && frame.size.height == 0) {
            frame.size.width = kScreenWidth
            frame.size.height = CGFloat(1)
        }
        
        super.init(frame: frame)
        self.exclusiveTouch = true
        
       
        self.contentView                    = UIView()
        self.contentView.width              = kScreenWidth
        self.contentView.height             = 1
        self.contentView.backgroundColor    = UIColor.whiteColor()

        let topLine                         = UIImageView(image: topLineBG)
        topLine.width                       = self.contentView.width
        topLine.bottom                      = 0
        topLine.autoresizingMask            = [UIViewAutoresizing.FlexibleWidth,UIViewAutoresizing.FlexibleBottomMargin]
        self.contentView.addSubview(topLine)

        let bottomLine                      = UIImageView(image: bottomLineBG)
        bottomLine.width                    = self.contentView.width
        bottomLine.top                      = self.contentView.height
        bottomLine.autoresizingMask         = [UIViewAutoresizing.FlexibleWidth,UIViewAutoresizing.FlexibleBottomMargin]
        self.contentView.addSubview(bottomLine)

        self.addSubview(self.contentView)

        self.titleView                      = WBStatusTitleView()
        self.titleView?.hidden              = true
        self.contentView.addSubview(self.titleView!)

        self.profileView                    = WBStatusProfileView()
        self.contentView.addSubview(self.profileView)

        self.vipBackgroundView              = UIImageView()
//        self.vipBackgroundView?.backgroundColor = UIColor.redColor()
        self.vipBackgroundView!.size        = CGSizeMake(kScreenWidth, 14.0)
        self.vipBackgroundView?.top         = -2
        self.vipBackgroundView?.contentMode = UIViewContentMode.TopRight
        self.contentView.addSubview(self.vipBackgroundView!)


        self.menuButton                             = UIButton()
        self.menuButton?.size                       = CGSizeMake(30, 30)
        self.menuButton?.setImage(WBStatusHelper.imageNamed("timeline_icon_more"), forState: UIControlState.Normal)
        self.menuButton?.setImage(WBStatusHelper.imageNamed("timeline_icon_more_highlighted"), forState: UIControlState.Highlighted)
        self.menuButton?.centerX                    = self.width - 20
        self.menuButton?.centerY                    = 18
        self.menuButton?.addBlockForControlEvents(UIControlEvents.TouchUpInside, block: { (sender) -> Void in
            self.cell.delegate.cellDidClickMenu(self.cell)
        })
        self.contentView.addSubview(self.menuButton!)


        self.retweetBackgroundView                  = UIView()
        self.retweetBackgroundView?.backgroundColor = kWBCellInnerViewColor
        self.retweetBackgroundView?.width           = kScreenWidth
        self.contentView.addSubview(self.retweetBackgroundView!)


        textLabel                             = YYLabel()
        textLabel.left                        = CGFloat(kWBCellPadding)
        textLabel.width                       = CGFloat(kWBCellContentWidth)
        textLabel.textVerticalAlignment       = YYTextVerticalAlignment.Top
        textLabel.displaysAsynchronously      = true
        textLabel.ignoreCommonProperties      = true
        textLabel.fadeOnAsynchronouslyDisplay = false
        textLabel.fadeOnHighlight             = false
        self.contentView!.addSubview(textLabel)

        self.textLabel.highlightTapAction           = { (containerView :UIView! ,text: NSAttributedString! ,  range :NSRange!,  rect:CGRect!) ->Void in
            self.cell.delegate.cell(self.cell, didClickInLabel: containerView as! YYLabel, textRange: range)
        }

        retweetTextLabel                               = YYLabel()
        retweetTextLabel! .left                        = CGFloat(kWBCellPadding)
        retweetTextLabel! .width                       = CGFloat(kWBCellContentWidth)
        retweetTextLabel! .textVerticalAlignment       = YYTextVerticalAlignment.Top
        retweetTextLabel! .displaysAsynchronously      = true
        textLabel.ignoreCommonProperties      = true
        retweetTextLabel! .fadeOnAsynchronouslyDisplay = false
        retweetTextLabel! .fadeOnHighlight             = false
        self.contentView!.addSubview(retweetTextLabel! )
       
        self.retweetTextLabel!.highlightTapAction   = { (containerView :UIView! ,text: NSAttributedString! ,  range :NSRange!,  rect:CGRect!) ->Void in
            self.cell.delegate.cell(self.cell, didClickInLabel: containerView as! YYLabel, textRange: range)
        }
        
        
        let picViewsArray = NSMutableArray()
        for var i :Int = 0 ; i < 9 ; i++ {
            let imageView             = YYControl()
            imageView.size            = CGSizeMake(100, 100)
            imageView.hidden          = true
            imageView.clipsToBounds   = true
            imageView.tag = i
            imageView.backgroundColor = kWBCellHighlightColor
            imageView.exclusiveTouch  = true
            imageView.touchBlock = { (view :YYControl,  state :YYGestureRecognizerState, touches :NSSet , even :UIEvent) -> Void in
                
                if state == YYGestureRecognizerState.Ended {
                    let touch = touches.anyObject()
                    let p = touch!.locationInView(view)
                    if (CGRectContainsPoint(view.bounds, p)) {
                        
                        self.cell.delegate.cell(self.cell, didClickImageAtIndex: view.tag)
                    }
                }
            }
            let badge                    = UIImageView()
            badge.userInteractionEnabled = false
            badge.contentMode            = UIViewContentMode.ScaleAspectFit
            badge.size                   = CGSizeMake(56 / 2, 36 / 2)
            badge.autoresizingMask       = [UIViewAutoresizing.FlexibleTopMargin , UIViewAutoresizing.FlexibleLeftMargin]
            badge.right                  = imageView.width
            badge.bottom                 = imageView.height
            badge.hidden                 = true
            imageView.addSubview(badge)

            picViewsArray.addObject(imageView)
            self.contentView.addSubview(imageView)
        }
        
        self.picViews         = picViewsArray

        self.cardView         = WBStatusCardView()
        self.cardView?.hidden = true
        self.contentView.addSubview(self.cardView!)

        self.tagView          = WBStatusTagView()
        self.tagView?.hidden  = true
        self.tagView?.left    = CGFloat(kWBCellPadding)
        self.contentView.addSubview(self.tagView!)

        self.toolbarView      = WBStatusToolbarView()
        self.contentView.addSubview(self.toolbarView!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
    
    var layout :WBStatusLayout!
    
    func setWithLayout(newValue :WBStatusLayout) {
        
        self.layout             = newValue
        self.height             = CGFloat(newValue.height!)
        self.contentView.top    = CGFloat(newValue.marginTop!)
        self.contentView.height = CGFloat(layout.height! - layout.marginTop! - layout.marginBottom!)
        
        
        
        var top :CGFloat = 0
        if newValue.titleHeight! > 0 {
            self.titleView?.hidden                = false
            self.titleView?.height                = CGFloat(newValue.titleHeight!)
            self.titleView!.titleLabel.textLayout = newValue.titleTextLayout!
            top                                   = CGFloat(newValue.titleHeight!)
        }else {
            self.titleView?.hidden = true
        }
      
        //圆角头像
        self.profileView.avatarView.setImageWithURL(newValue.status!.user!.avatarLarge!, placeholder: nil, options: YYWebImageOptions.AllowBackgroundTask, manager: WBStatusHelper.avatarImageManager(), progress: nil, transform: nil, completion: nil)
        self.profileView.nameLabel.textLayout   = newValue.nameTextLayout
        self.profileView.sourceLabel.textLayout = newValue.sourceTextLayout
                    if newValue.status!.user!.userVerifyType != nil {
                       self.profileView.setWithVerifyType(newValue.status!.user!.userVerifyType!)
                       }
        
        self.profileView.height                 = CGFloat(newValue.profileHeight!)
        self.profileView.top                    = top
        
        top += CGFloat(newValue.profileHeight!)
        
        
        let picBg = WBStatusHelper.defaultURLForImageURL(newValue.status!.pic_bg)
       
       
//        if let _ = picBg {
            self.vipBackgroundView!.setImageWithURL(picBg, placeholder: nil, options: YYWebImageOptions.AllowBackgroundTask, completion: { (var image, url, from, stage, error) -> Void in
                if ((image) != nil) {
                    image = UIImage(CGImage: image.CGImage!, scale: 2.0, orientation: image.imageOrientation)
                    self.vipBackgroundView!.image = image;
                }
            })
//        }
        
        self.textLabel.top        = top
        self.textLabel.height     = CGFloat(newValue.textHeight!)
        self.textLabel.textLayout = newValue.textLayout!
        
        top += CGFloat(newValue.textHeight!)
        
        self.retweetBackgroundView?.hidden = true
        self.retweetTextLabel?.hidden      = true
        self.cardView?.hidden              = true
        
        if newValue.picHeight == 0 && newValue.retweetPicHeight == 0 {
            self._hideImageViews()
        }
        
        //优先级是 转发->图片->卡片
        if newValue.retweetHeight > 0 {
            self.retweetBackgroundView!.top    = top
            self.retweetBackgroundView!.height = CGFloat(newValue.retweetHeight!)
            self.retweetBackgroundView!.hidden = false
            
            self.retweetTextLabel!.top         = top
            self.retweetTextLabel!.height      = CGFloat(newValue.retweetTextHeight!)
            self.retweetTextLabel!.textLayout  = newValue.retweetTextLayout!
            self.retweetTextLabel!.hidden      = false
            
            //转发中带有图片
            if newValue.retweetPicHeight > 0 {
               
                self._setImageViewWithTop(self.retweetTextLabel!.bottom, isRetweet: true)
            }else {
                self._hideImageViews()
                if newValue.retweetCardHeight > 0 {
                    self.cardView!.top    = self.retweetTextLabel!.bottom
                    self.cardView!.hidden = false
                    self.cardView?.setWithLayout(newValue, isRetweet: true)
                }
            }
        }else if newValue.picHeight > 0 {
            self._setImageViewWithTop(top, isRetweet: false)
        } else if newValue.cardHeight > 0 {
            self.cardView!.top    = top
            self.cardView!.hidden = false
            self.cardView?.setWithLayout(newValue, isRetweet: false)
        }
        
        if newValue.tagHeight > 0 {
            self.tagView!.hidden  = false
            self.tagView!.setWithLayout(newValue)
            self.tagView!.centerY = self.contentView.height - CGFloat(kWBCellToolbarHeight) - CGFloat(newValue.tagHeight! / 2)
        } else {
            self.tagView!.hidden = true;
        }
        
        self.toolbarView!.bottom = self.contentView.height;
        self.toolbarView?.setWithLayout(newValue)
        
    }
    func _hideImageViews() {
        
        for imageView :YYControl in self.picViews! as! [YYControl] {
            
            imageView.hidden = true
        }
    }
    
    func _setImageViewWithTop(imageTop :CGFloat , isRetweet :Bool) {
        let picSize :CGSize = isRetweet ? self.layout.retweetPicSize! : self.layout.picSize!
        let pics :NSArray   = isRetweet ? self.layout.status!.retweetedStatus!.pics! : self.layout.status!.pics!
        let picsCount       = pics.count
        
        for var i = 0 ; i < 9 ; i++ {
            let imageView :YYControl = self.picViews![i] as! YYControl
            if i >= picsCount {
                imageView.layer.cancelCurrentImageRequest()
                imageView.hidden = true
            }else {
             
                var origin = CGPointZero
                switch picsCount {
                case 1 :
                    origin.x = CGFloat(kWBCellPadding)
                    origin.y = imageTop;
                case 4 :
                    origin.x = CGFloat(kWBCellPadding) + CGFloat(i % 2) * (picSize.width + CGFloat(kWBCellPaddingPic))
                    origin.y = imageTop + (CGFloat)(i / 2) * (picSize.height + CGFloat(kWBCellPaddingPic))
                default :
                    origin.x = CGFloat(kWBCellPadding) + CGFloat(i % 3) * (picSize.width + CGFloat(kWBCellPaddingPic))
                    origin.y = imageTop + (CGFloat)(i / 3) * (picSize.height + CGFloat(kWBCellPaddingPic))
                }
                
                imageView.frame  = CGRectMake(origin.x, origin.y, picSize.width, picSize.height)
                imageView.hidden = false
                imageView.layer.removeAnimationForKey("contents")
                
                let pic = pics[i] as! WBPicture
                let badge = imageView.subviews.first!
                if pic.largest?.badgeType != nil {
                    switch pic.largest!.badgeType!
                    {
                    case WBPictureBadgeType.WBPictureBadgeTypeNone :
                        if badge.layer.contents != nil {
                            badge.layer.contents = nil
                            badge.hidden = true
                        }
                    case WBPictureBadgeType.WBPictureBadgeTypeLong :
                        badge.layer.contents = WBStatusHelper.imageNamed("timeline_image_longimage")?.CGImage
                        badge.hidden = false
                    case WBPictureBadgeType.WBPictureBadgeTypeGIF :
                        badge.layer.contents = WBStatusHelper.imageNamed("timeline_image_gif")?.CGImage
                        badge.hidden = false
                    }
                }
           
                let tempUrl :NSURL!
               
                if pic.bmiddle?.type == "WEBP" {
                    tempUrl = pic.largest?.url
                  
                }else {
                    tempUrl = pic.bmiddle?.url
                }

                imageView.layer.setImageWithURL(tempUrl, placeholder: nil, options: YYWebImageOptions.AllowBackgroundTask, completion: { (image, url, from, stage, error) -> Void in
                    
                    
                    if image != nil && stage == YYWebImageStage.Finished {
                       
                        let width  = Int(pic.largest!.width!)
                        let height = Int(pic.largest!.height!)
                        let scale  = CGFloat(height! / width!) / (imageView.height / imageView.width)
                        if scale < 0.99 || isnan(scale) { // 宽图把左右两边裁掉
                            imageView.contentMode        = UIViewContentMode.ScaleAspectFill
                            imageView.layer.contentsRect = CGRectMake(0, 0, 1, 1)
                        }else {
                            imageView.contentMode        = UIViewContentMode.ScaleToFill;
                            imageView.layer.contentsRect = CGRectMake(0, 0, 1, CGFloat(width!) / CGFloat(height!));
                        }
                        imageView.image = image
                        if from != YYWebImageFromType.MemoryCacheFast {
                            let transition = CATransition()
                            transition.duration = 0.15
                            transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
                            transition.type = kCATransitionFade
                            imageView.layer.addAnimation(transition, forKey: "contents")
                        }
                    }
                })
                
            }
        }
    }
 
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        let touch = touches.first!
        let p = touch.locationInView(self.retweetBackgroundView)
        let insideRetweet = CGRectContainsPoint(self.retweetBackgroundView!.bounds ,p)
        
        if self.retweetBackgroundView?.hidden == false && insideRetweet {
            
            self.retweetBackgroundView!.performSelector("setBackgroundColor:", withObject: kWBCellHighlightColor, afterDelay: 0.15)
            self._touchRetweetView = true
        }else {

            self.contentView!.performSelector("setBackgroundColor:", withObject: kWBCellHighlightColor, afterDelay: 0.15)
            self._touchRetweetView = false
        }

    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.touchesRestoreBackgroundColor()
        if self._touchRetweetView {
            self.cell.delegate.cellDidClickRetweet(self.cell)
        }else {
            self.cell.delegate.cellDidClick(self.cell)
        }
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        
        self.touchesRestoreBackgroundColor()
    }
    
    func touchesRestoreBackgroundColor() {
        NSObject.cancelPreviousPerformRequestsWithTarget(self.retweetBackgroundView!, selector: "setBackgroundColor:", object: kWBCellHighlightColor)
         NSObject.cancelPreviousPerformRequestsWithTarget(self.contentView!, selector: "setBackgroundColor:", object: kWBCellHighlightColor)
        self.contentView.backgroundColor = UIColor.whiteColor()
        self.retweetBackgroundView!.backgroundColor = kWBCellInnerViewColor
    }

}
