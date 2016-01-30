//
//  WBStatusToolbarView.swift
//  weibo-swift
//
//  Created by 马超 on 16/1/11.
//  Copyright © 2016年 马超. All rights reserved.
//

import UIKit

class WBStatusToolbarView: UIView {

     let likeImage = WBStatusHelper.imageNamed("timeline_icon_like")
     let unlikeImage = WBStatusHelper.imageNamed("timeline_icon_unlike")
    
     var repostButton :UIButton!
     var commentButton :UIButton!
     var likeButton :UIButton!
    
    var repostImageView :UIImageView!
    var commentImageView :UIImageView!
    var likeImageView :UIImageView!
    
    var repostLabel :YYLabel!
    var commentLabel :YYLabel!
    var likeLabel :YYLabel!
    
    var line1 :CAGradientLayer = CAGradientLayer()
    var line2 :CAGradientLayer = CAGradientLayer()
    
    var topLine :CALayer!
    var bottomLine :CALayer!
    
    var cell :WBStatusCell!
    
    override init(var frame: CGRect) {
        
        if (frame.size.width == 0 && frame.size.height == 0) {
            frame.size.width = kScreenWidth
            frame.size.height = CGFloat(kWBCellToolbarHeight)
        }
        
        super.init(frame: frame)
        self.exclusiveTouch = true
        
        self.repostButton = UIButton(type: UIButtonType.Custom)
        self.repostButton.exclusiveTouch = true
        self.repostButton.size = CGSizeMake(CGFloatPixelRound(self.width / 3.0), self.height)
        self.repostButton.setBackgroundImage(UIImage(color: kWBCellHighlightColor), forState: UIControlState.Highlighted)
        self.addSubview(self.repostButton)
        
        self.commentButton = UIButton(type: UIButtonType.Custom)
        self.commentButton.exclusiveTouch = true
        self.commentButton.size = CGSizeMake(CGFloatPixelRound(self.width / 3.0), self.height)
        self.commentButton.left = CGFloatPixelRound(self.width / 3.0);
        self.commentButton.setBackgroundImage(UIImage(color: kWBCellHighlightColor), forState: UIControlState.Highlighted)
        self.addSubview(self.commentButton)
        
        self.likeButton = UIButton(type: UIButtonType.Custom)
        self.likeButton.exclusiveTouch = true
        self.likeButton.size = CGSizeMake(CGFloatPixelRound(self.width / 3.0), self.height)
        self.likeButton.left = CGFloatPixelRound(self.width / 3.0 * 2.0);
        self.likeButton.setBackgroundImage(UIImage(color: kWBCellHighlightColor), forState: UIControlState.Highlighted)
        self.addSubview(self.likeButton)
        
        self.repostImageView = UIImageView(image: WBStatusHelper.imageNamed("timeline_icon_retweet"))
        self.repostImageView.centerY = self.height / 2
        self.repostButton.addSubview(self.repostImageView)
        
        self.commentImageView = UIImageView(image: WBStatusHelper.imageNamed("timeline_icon_comment"))
        self.commentImageView.centerY = self.height / 2
        self.commentButton.addSubview(self.commentImageView)
        
        self.likeImageView = UIImageView(image: WBStatusHelper.imageNamed("timeline_icon_unlike"))
        self.likeImageView.centerY = self.height / 2
        self.likeButton.addSubview(self.likeImageView)
        
        self.repostLabel = YYLabel()
        self.commentLabel = YYLabel()
        self.likeLabel = YYLabel()
        self.initLabel(self.repostLabel, superView: self.repostButton)
        self.initLabel(self.commentLabel, superView: self.commentButton)
        self.initLabel(self.likeLabel, superView: self.likeButton)

        self.initVerticalLineLayer(self.line1, left: self.repostButton.right)
        self.initVerticalLineLayer(self.line2, left: self.commentButton.right)
    
     
        self.topLine = CALayer()
        self.topLine.size = CGSizeMake(self.width, CGFloatFromPixel(1))
        self.topLine.backgroundColor = kWBCellLineColor.CGColor
        self.layer.addSublayer(self.topLine)
        
        self.bottomLine = CALayer()
        self.bottomLine.size = self.topLine.size
        self.bottomLine.bottom = self.height
        self.bottomLine.backgroundColor = UIColor(hexString: "e8e8e8").CGColor
        self.layer.addSublayer(self.bottomLine)
        
        
        //转发事件
        self.repostButton.addBlockForControlEvents(UIControlEvents.TouchUpInside) { (sender) -> Void in
            self.cell.delegate.cellDidClickRepost(self.cell)
        }
        //评论事件
        self.commentButton.addBlockForControlEvents(UIControlEvents.TouchUpInside) { (sender) -> Void in
            self.cell.delegate.cellDidClickComment(self.cell)
        }
        //点赞事件
        self.likeButton.addBlockForControlEvents(UIControlEvents.TouchUpInside) { (sender) -> Void in
            self.cell.delegate.cellDidClickLike(self.cell)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initLabel( label :YYLabel , superView : UIButton) {
        label.userInteractionEnabled = false
        label.height = self.height
        label.textVerticalAlignment = YYTextVerticalAlignment.Center
        label.displaysAsynchronously = true
        label.ignoreCommonProperties = true
        label.fadeOnAsynchronouslyDisplay = false
        label.fadeOnHighlight = false
        superView.addSubview(label)
    }
    
    func initVerticalLineLayer( layer : CAGradientLayer , left : CGFloat) {
        
        let dark = UIColor(white: 0, alpha: 0.2)
        let clear = UIColor(white: 0, alpha: 0)
        let colors :Array<AnyObject> = [clear.CGColor as AnyObject ,dark.CGColor as AnyObject ,clear.CGColor as AnyObject  ]
        let locations = [0.2,0.5,0.8]
        
       
        layer.colors = colors
        layer.locations = locations
        layer.startPoint = CGPointMake(0, 0)
        layer.endPoint = CGPointMake(0, 1)
        layer.size = CGSizeMake(CGFloatFromPixel(1), self.height)
        layer.left = left
        self.layer.addSublayer(layer)
    }
    
    
    func setWithLayout(layout :WBStatusLayout) {
        
        //调节宽度
        self.repostLabel.width = CGFloat(layout.toolbarRepostTextWidth!)
        self.commentLabel.width = CGFloat(layout.toolbarCommentTextWidth!)
        self.likeLabel.width = CGFloat(layout.toolbarLikeTextWidth!)
        
        //调节显示内容
        self.repostLabel.textLayout = layout.toolbarRepostTextLayout;
        self.commentLabel.textLayout = layout.toolbarCommentTextLayout;
        self.likeLabel.textLayout = layout.toolbarLikeTextLayout;
        
        //调整图片显示
        self.adjustImage(self.repostImageView, label: self.repostLabel, inButton: self.repostButton)
        self.adjustImage(self.commentImageView, label: self.commentLabel, inButton: self.commentButton)
        self.adjustImage(self.likeImageView, label: self.likeLabel, inButton: self.likeButton)
        
        //调整zan 
        self.likeImageView.image = Int(layout.status!.attitudesStatus!) != 0 ? self.likeImage : self.unlikeImage
        
    }
    
    func adjustImage(image :UIImageView , label :YYLabel , inButton button :UIButton) {
        
        let imageWidth = image.bounds.size.width
        let labelWidth = label.width
        let paddingMid = 5
        let paddingSide = (button.width - imageWidth - labelWidth - CGFloat(paddingMid)) / 2.0
        image.centerX = CGFloatPixelRound(paddingSide + imageWidth / 2)
        label.right = CGFloatPixelRound(button.width - paddingSide)
    }
    
    func setLiked(liked :Bool , withAnimation animation :Bool) {
        
        let layout = self.cell.statusView.layout
        if Int(layout.status!.attitudesStatus!) == 1 { if liked { return} }
        else { if !liked {return}}
        
        let image = liked ? self.likeImage : self.unlikeImage
        var newCount = Int(layout.status!.attitudesCount!)!
        newCount = liked ? newCount + 1 : newCount - 1
        if newCount < 0 { newCount = 0 }
        if liked && newCount < 1 { newCount = 1 }
        let newCountDesc = newCount > 0 ? WBStatusHelper.shortedNumberDesc(UInt(newCount)) : "赞"
        
        let font = UIFont.systemFontOfSize(CGFloat(kWBCellToolbarFontSize))
        
        let container = YYTextContainer(size: CGSizeMake(kScreenWidth, CGFloat(kWBCellToolbarHeight)))
            container.maximumNumberOfRows = 1
        let likeText = NSMutableAttributedString(string: newCountDesc!)
        likeText.font = font
        likeText.color = liked ? kWBCellToolbarTitleHighlightColor : kWBCellToolbarTitleColor
        
        let textLayout = YYTextLayout(container: container, text: likeText)
        

        layout.status!.attitudesStatus = liked ? "1" : "0";
        layout.status!.attitudesCount = String(newCount);
        layout.toolbarLikeTextLayout = textLayout;
        
        
        if (!animation) {
            self.likeImageView.image = image
            self.likeLabel.width = CGFloatPixelRound(textLayout.textBoundingRect.size.width)
            self.likeLabel.textLayout = layout.toolbarLikeTextLayout
            self.adjustImage(self.likeImageView, label: self.likeLabel, inButton: self.likeButton)
            return;
        }
        
        UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: { () -> Void in
            self.likeImageView.layer.transformScale = 1.7
            }) { (finished) -> Void in
                self.likeImageView.image = image
                self.likeLabel.width = CGFloatPixelRound(textLayout.textBoundingRect.size.width)
                self.likeLabel.textLayout = layout.toolbarLikeTextLayout
                self.adjustImage(self.likeImageView, label: self.likeLabel, inButton: self.likeButton)
                
                UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: { () -> Void in
                    self.likeImageView.layer.transformScale = 0.9
                    }) { (finished) -> Void in
                        UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: { () -> Void in
                            self.likeImageView.layer.transformScale = 1
                            }) { (finished) -> Void in
                        }
                }
        }
    }
 
    
}
