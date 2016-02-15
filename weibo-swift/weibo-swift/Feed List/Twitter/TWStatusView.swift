//
//  TWStatusView.swift
//  weibo-swift
//
//  Created by 马超 on 16/1/30.
//  Copyright © 2016年 马超. All rights reserved.
//

import UIKit

class TWStatusView: YYControl {

    var tempCell: TWeetCell?
    var cell: TWeetCell! {
    
        set{
        
            self.tempCell = newValue
            self.inlineActionsView.cell = newValue
            self.mediaView.cell = newValue
            self.quoteView.cell = newValue
        }
        get{

            return self.tempCell!
        }
    }
    
    
    func setWithLayout(layout: TWLayout) {
        
        self.height = layout.height
        self.topLine.hidden = !layout.showTopLine
        
        if layout.isConversationSplit {
            
            self.conversationTopJoin.hidden = false
            self.conversationTopJoin.top = 3
            self.conversationTopJoin.height = self.height - 6
            
            self.avatarView.hidden = true
            self.nameLabel.hidden = true
            self.dateLabel.hidden = true
            self.socialLabel.hidden = true
            self.socialIconView.hidden = true
            self.inlineActionsView.hidden = true
            
            return
        }else {
            
            if self.avatarView.hidden {
                self.avatarView.hidden = false
                self.nameLabel.hidden = false
                self.dateLabel.hidden = false
                self.socialLabel.hidden = false
                self.socialIconView.hidden = false
                self.inlineActionsView.hidden = false
            }
        }


        let tw = layout.displayedTweet
        
        self.avatarView.top = layout.paddingTop
        self.avatarView.layer.setImageWithURL(tw.user?.profileImageURLReasonablySmall, options: YYWebImageOptions.SetImageWithFadeAnimation)
        
        if layout.socialTextLayout != nil {
            
            self.socialLabel.hidden = false
            self.socialIconView.hidden = false
            self.socialLabel.textLayout = layout.socialTextLayout
            
            if layout.tweet?.retweetedStatus != nil {
                
                self.socialIconView.hidden = false
                self.socialIconView.image = TWHelper.imageNamed("icn_social_proof_conversation_default")
                
            }else if layout.tweet?.inReplyToScreenName != nil {
                
                self.socialIconView.hidden = false
                self.socialIconView.image = TWHelper.imageNamed("icn_activity_rt_tweet")
                
            }else{
                
                self.socialIconView.image = nil
                
            }
        }else {
            
            
            self.socialLabel.hidden = true
            self.socialIconView.hidden = true
        }

        
        self.nameLabel.centerY = layout.paddingTop + kTWTextFontSize / 2
        self.nameLabel.textLayout = layout.nameTextLayout
        
        self.dateLabel.centerY = self.nameLabel.centerY
        self.dateLabel.textLayout = layout.dateTextLayout

        if layout.textLayout != nil {
            
            self.textLabel.hidden = false
            self.textLabel.top = layout.textTop
            self.textLabel.height = layout.textHeight
            self.textLabel.textLayout = layout.textLayout
            
        }else{
            
            self.textLabel.hidden = true
        }
        
        self.conversationTopJoin.hidden = !layout.showConversationTopJoin
        self.conversationBottomJoin.hidden = !layout.showConversationBottomJoin
        if (layout.showConversationTopJoin) {
            self.conversationTopJoin.top = -5
            self.conversationTopJoin.height = self.avatarView.top - self.conversationTopJoin.top - 3
        }
        
        if (layout.showConversationBottomJoin) {
            self.conversationBottomJoin.top = self.avatarView.bottom + 3
            self.conversationBottomJoin.height = self.height - self.conversationBottomJoin.top + 5
        }

        
        self.inlineActionsView.centerY = self.height - 19
        self.inlineActionsView.setWithLayout(layout)

        if layout.images?.count > 0 {
            
            self.mediaView.hidden = false
            self.mediaView.top = layout.imagesTop
            self.mediaView.height = layout.imagesHeight
            self.mediaView.setWithMedias(layout.images!)
            
        }else {
            
            self.mediaView.hidden = true
            self.mediaView.setWithMedias(nil)
            
        }

        
        if (layout.quoteHeight > 0) {
            self.quoteView.hidden = false
            self.quoteView.top = layout.quoteTop
            self.quoteView.height = layout.quoteHeight
            self.quoteView.setWithLayout(layout)
        } else {
            self.quoteView.hidden = true
        }
        
    }

    override init(frame: CGRect) {
        
        self.topLine                = UIView()
        self.socialIconView         = UIImageView()
        self.socialLabel            = YYLabel()
        self.avatarView             = YYControl()
        self.conversationTopJoin    = UIView()
        self.conversationBottomJoin = UIView()
        self.nameLabel              = YYLabel()
        self.dateLabel              = YYLabel()
        self.textLabel              = YYLabel()
        self.inlineActionsView      = TWStatusInlineActionsView()
        self.mediaView              = TWStatusMediaView()
        self.quoteView              = TWStatusQuoteView()
        self.topLine                = UIView()
        
        super.init(frame: frame)
        
        self.width                                         = kScreenWidth
        self.backgroundColor                               = UIColor.whiteColor()
        self.exclusiveTouch                                = true
        self.clipsToBounds                                 = true


        self.topLine.width                                 = kScreenWidth
        self.topLine.height                                = CGFloatFromPixel(1)
        self.topLine.backgroundColor                       = UIColor(white: 0.823, alpha: 1.000)
        self.addSubview(self.topLine)


        self.socialLabel.textVerticalAlignment             = YYTextVerticalAlignment.Center
        self.socialLabel.displaysAsynchronously            = true
        self.socialLabel.ignoreCommonProperties            = true
        self.socialLabel.fadeOnHighlight                   = false
        self.socialLabel.fadeOnAsynchronouslyDisplay       = false
        self.socialLabel.size                              = CGSizeMake(kTWContentWidth, kTWUserNameSubFontSize * 2)
        self.socialLabel.left                              = kTWContentLeft
        self.socialLabel.centerY                           = kTWCellPadding + kTWUserNameSubFontSize / 2
        self.socialLabel.userInteractionEnabled            = false
        self.addSubview(self.socialLabel)

        self.socialIconView.size                           = CGSizeMake(16, 16)
        self.socialIconView.centerY                        = self.socialLabel.centerY - 1
        self.socialIconView.right                          = kTWCellPadding + kTWAvatarSize
        self.socialIconView.contentMode                    = UIViewContentMode.ScaleAspectFit
        self.socialIconView.userInteractionEnabled         = false
        self.addSubview(self.socialIconView)


        self.avatarView.clipsToBounds                      = true
        self.avatarView.layer.cornerRadius                 = 4
        self.avatarView.layer.borderWidth                  = CGFloatFromPixel(1)
        self.avatarView.layer.borderColor                  = UIColor(white: 0.000, alpha: 0.118).CGColor
        self.avatarView.backgroundColor                    = UIColor(white: 0.908, alpha: 1.000)
        self.avatarView.contentMode                        = UIViewContentMode.ScaleAspectFill
        self.avatarView.left                               = kTWCellPadding
        self.avatarView.size                               = CGSizeMake(kTWAvatarSize, kTWAvatarSize)
        self.avatarView.exclusiveTouch                     = true
        self.addSubview(self.avatarView)


        self.conversationTopJoin.userInteractionEnabled    = false
        self.conversationTopJoin.hidden                    = true
        self.conversationTopJoin.width                     = 3
        self.conversationTopJoin.backgroundColor           = UIColor(hexString: "e1e8ed")
        self.conversationTopJoin.clipsToBounds             = true
        self.conversationTopJoin.layer.cornerRadius        = self.conversationTopJoin.width / 2
        self.conversationTopJoin.centerX                   = self.avatarView.centerX
        self.addSubview(self.conversationTopJoin)


        self.conversationBottomJoin.userInteractionEnabled = false
        self.conversationBottomJoin.hidden                 = true
        self.conversationBottomJoin.width                  = 3
        self.conversationBottomJoin.backgroundColor        = self.conversationBottomJoin.backgroundColor
        self.conversationBottomJoin.clipsToBounds          = true
        self.conversationBottomJoin.layer.cornerRadius     = self.conversationTopJoin.width / 2
        self.conversationBottomJoin.centerX                = self.avatarView.centerX
        self.addSubview(self.conversationBottomJoin)



        self.nameLabel.textVerticalAlignment               = YYTextVerticalAlignment.Center
        self.nameLabel.displaysAsynchronously              = true
        self.nameLabel.ignoreCommonProperties              = true
        self.nameLabel.fadeOnHighlight                     = false
        self.nameLabel.fadeOnAsynchronouslyDisplay         = false
        self.nameLabel.left                                = kTWContentLeft
        self.nameLabel.width                               = kTWContentWidth
        self.nameLabel.height                              = kTWUserNameFontSize * 2
        self.nameLabel.userInteractionEnabled              = false
        self.nameLabel.exclusiveTouch                      = true
       self.addSubview(self.nameLabel)


        self.dateLabel.textVerticalAlignment               = YYTextVerticalAlignment.Center
        self.dateLabel.displaysAsynchronously              = true
        self.dateLabel.ignoreCommonProperties              = true
        self.dateLabel.fadeOnHighlight                     = false
        self.dateLabel.fadeOnAsynchronouslyDisplay         = false
        self.dateLabel.frame                               = self.nameLabel.frame
        self.dateLabel.userInteractionEnabled              = false
        self.addSubview(self.dateLabel)


        self.textLabel.textVerticalAlignment               = YYTextVerticalAlignment.Center
        self.textLabel.displaysAsynchronously              = true
        self.textLabel.ignoreCommonProperties              = true
        self.textLabel.fadeOnHighlight                     = false
        self.textLabel.fadeOnAsynchronouslyDisplay         = false
        self.textLabel.left                                = kTWContentLeft
        self.textLabel.width                               = kTWContentWidth
        self.textLabel.width                               += kTWTextContainerInset * 2
        self.textLabel.left                                -= kTWTextContainerInset

        self.textLabel.highlightTapAction                  = { (containerView: UIView! , text: NSAttributedString! , range: NSRange! , rect: CGRect!) ->Void  in

            if let _ = self.cell.delegate {
                
                self.cell.delegate!.cell(self.cell, didClickInLabel: self.textLabel, textRange: range)
                
            }
        }
   
        self.addSubview(self.textLabel)
        
        
        self.inlineActionsView.left = kTWContentLeft
        self.addSubview(self.inlineActionsView)
        
        
        self.mediaView.left = kTWContentLeft
        self.addSubview(self.mediaView)
        
        self.quoteView.left = kTWContentLeft
        self.addSubview(self.quoteView)
        
        
        self.topLine.width = kScreenWidth;
        self.topLine.height = CGFloatFromPixel(1)
        self.topLine.backgroundColor = UIColor(white: 0.823, alpha: 1.000)
        self.addSubview(self.topLine)
        
        
        
        //设置自身的点击事件。
        self.touchBlock = { (view :YYControl,  state :YYGestureRecognizerState, touches :NSSet , even :UIEvent ) -> Void in
        
            if state == YYGestureRecognizerState.Began {
                
                self.backgroundColor = kTWCellBGHighlightColor
                
            }else if state != YYGestureRecognizerState.Moved {
                
                self.backgroundColor = UIColor.clearColor()
                
            }
            
            if state == YYGestureRecognizerState.Ended {
                
                let touch = touches.anyObject()! as! UITouch
                let p = touch.locationInView(self)
                if CGRectContainsPoint(self.bounds, p) {
                    
                    if let _ = self.cell.delegate {
                        
                        self.cell.delegate!.cell(self.cell, didClickContentWithLongPress: false)
                    }
                    
                }
                
            }
            
        }
        
        //设置头像的点击
        self.avatarView.touchBlock = { (view :YYControl,  state :YYGestureRecognizerState, touches :NSSet , even :UIEvent ) -> Void in
            
            if state == YYGestureRecognizerState.Began {
                
                self.avatarView.alpha = 0.7
                
            }else if state != YYGestureRecognizerState.Moved {
                
                self.avatarView.alpha = 1.0
                
            }
            
            if state == YYGestureRecognizerState.Ended {
                
                let touch = touches.anyObject()! as! UITouch
                let p = touch.locationInView(self)
                if CGRectContainsPoint(self.bounds, p) {
                    
                    if let _ = self.cell.delegate {
                        
                        self.cell.delegate!.cell(self.cell, didClickAvatarWithLongPress: false)
                    }
                    
                }
                
            }
            
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var topLine: UIView
    private var socialIconView: UIImageView
    private var socialLabel: YYLabel
    private var avatarView: YYControl
    private var conversationTopJoin: UIView
    private var conversationBottomJoin: UIView
    private var nameLabel: YYLabel
    private var dateLabel: YYLabel
    private var textLabel: YYLabel
    var inlineActionsView: TWStatusInlineActionsView
    var mediaView: TWStatusMediaView
    var quoteView: TWStatusQuoteView
    
}
