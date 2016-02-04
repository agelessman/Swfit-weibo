//
//  TWStatusInlineActionsView.swift
//  weibo-swift
//
//  Created by 马超 on 16/2/4.
//  Copyright © 2016年 马超. All rights reserved.
//

import UIKit

class TWStatusInlineActionsView: UIView {

    var replyButton: UIButton!
    var retweetButton: UIButton!
    var favoriteButton: UIButton!
    var followButton: UIButton!
    
    var retweetImageView: UIImageView!
    var retweetLabel: YYLabel!
    
    var favoriteImageView: YYAnimatedImageView!
    var favoriteLabel: YYLabel!
    
    var cell: TWeetCell!
    

    override init(frame: CGRect) {
        
        
        super.init(frame: frame)
        
        self.width = kTWContentWidth
        self.height = 32
        
        
        self.replyButton = UIButton()
        self.replyButton.size = CGSizeMake(32, 32)
        self.replyButton.centerY = self.height / 2
        self.replyButton.centerX = 6
        self.replyButton.adjustsImageWhenHighlighted = false
        self.replyButton.exclusiveTouch = true
        self.replyButton.setImage(TWHelper.imageNamed("icn_tweet_action_inline_reply_off"), forState: UIControlState.Normal)

        self.replyButton.addBlockForControlEvents([UIControlEvents.TouchDown,UIControlEvents.TouchDragEnter]) { (sender ) -> Void in
            
            (sender as! UIButton).alpha = 0.6
        }
        
        self.replyButton.addBlockForControlEvents([UIControlEvents.TouchUpInside,UIControlEvents.TouchUpOutside,UIControlEvents.TouchCancel,UIControlEvents.TouchDragExit]) { (sender ) -> Void in
            
            (sender as! UIButton).alpha = 1.0
        }
  
        self.addSubview(self.replyButton)
        
        
        self.retweetButton = UIButton()
        self.addSubview(self.retweetButton)
        
        self.retweetImageView = UIImageView()
        self.addSubview(self.retweetImageView)
        
        self.retweetLabel = YYLabel()
        self.addSubview(self.retweetLabel)
        
 
        
        self.retweetButton.size = CGSizeMake(32, 32)
        self.retweetButton.centerY = self.height / 2
        self.retweetButton.left = kTWContentWidth * 0.28 + self.replyButton.left;
        
        self.retweetImageView.size = CGSizeMake(32, 32)
        self.retweetImageView.contentMode = UIViewContentMode.Center
        self.retweetImageView.center = self.retweetButton.center
        self.retweetImageView.image = TWHelper.imageNamed("icn_tweet_action_inline_retweet_off")
        
        self.retweetLabel.height = self.retweetButton.height;
        self.retweetLabel.left = self.retweetImageView.right - 3;
        self.retweetLabel.userInteractionEnabled = false
        self.retweetButton.exclusiveTouch = true
        
        self.retweetButton.addBlockForControlEvents([UIControlEvents.TouchDown,UIControlEvents.TouchDragEnter]) { (sender ) -> Void in
            
            self.retweetImageView.alpha = 0.6
            self.retweetLabel.alpha = 0.6
        }
        
        self.retweetButton.addBlockForControlEvents([UIControlEvents.TouchUpInside,UIControlEvents.TouchUpOutside,UIControlEvents.TouchCancel,UIControlEvents.TouchDragExit]) { (sender ) -> Void in
            
            self.retweetImageView.alpha = 1
            self.retweetLabel.alpha = 1
        }
   
   
        self.favoriteButton = UIButton()
        self.addSubview(self.favoriteButton)
        
        self.favoriteImageView = YYAnimatedImageView()
        self.addSubview(self.favoriteImageView)
        
        self.favoriteLabel = YYLabel()
        self.addSubview(self.favoriteLabel)

        
        self.retweetButton.size = CGSizeMake(32, 32)
        self.retweetButton.centerY = self.height / 2
        self.retweetButton.left = kTWContentWidth * 0.28 + self.replyButton.left;
        
        self.retweetImageView.size = CGSizeMake(32, 32)
        self.retweetImageView.contentMode = UIViewContentMode.Center
        self.retweetImageView.center = self.retweetButton.center
        self.retweetImageView.image = TWHelper.imageNamed("icn_tweet_action_inline_retweet_off")
        
        self.retweetLabel.height = self.retweetButton.height;
        self.retweetLabel.left = self.retweetImageView.right - 3;
        self.retweetLabel.userInteractionEnabled = false
        self.retweetLabel.exclusiveTouch = true
        
        self.retweetButton.addBlockForControlEvents([UIControlEvents.TouchDown,UIControlEvents.TouchDragEnter]) { (sender ) -> Void in
            
            self.retweetImageView.alpha = 0.6
            self.retweetLabel.alpha = 0.6
        }
        
        self.retweetButton.addBlockForControlEvents([UIControlEvents.TouchUpInside,UIControlEvents.TouchUpOutside,UIControlEvents.TouchCancel,UIControlEvents.TouchDragExit]) { (sender ) -> Void in
            
            self.retweetImageView.alpha = 1
            self.retweetLabel.alpha = 1
        }
        
        self.favoriteButton.size = CGSizeMake(32, 32)
        self.favoriteButton.centerY = self.height / 2
        self.favoriteButton.left = kTWContentWidth * 0.28 + self.retweetButton.left;
        
        self.favoriteImageView.size = CGSizeMake(32, 32)
        self.favoriteImageView.contentMode = UIViewContentMode.Center
        self.favoriteImageView.center = self.favoriteButton.center
        self.favoriteImageView.image = TWHelper.imageNamed("icn_tweet_action_inline_favorite_off")
        
        self.favoriteLabel.height = self.favoriteButton.height;
        self.favoriteLabel.left = self.favoriteImageView.right - 4;
        self.favoriteLabel.userInteractionEnabled = false
        self.favoriteLabel.exclusiveTouch = true
        
        self.favoriteButton.addBlockForControlEvents([UIControlEvents.TouchDown,UIControlEvents.TouchDragEnter]) { (sender ) -> Void in
            
            self.favoriteImageView.alpha = 0.6
            self.favoriteLabel.alpha = 0.6
        }
        
        self.favoriteButton.addBlockForControlEvents([UIControlEvents.TouchUpInside,UIControlEvents.TouchUpOutside,UIControlEvents.TouchCancel,UIControlEvents.TouchDragExit]) { (sender ) -> Void in
            
            self.favoriteImageView.alpha = 1
            self.favoriteLabel.alpha = 1
        }

        self.followButton = UIButton()
        self.followButton.size = CGSizeMake(32, 32)
        self.followButton.centerY = self.height / 2
        self.followButton.right = self.width - 3
        self.followButton.adjustsImageWhenHighlighted = false
        self.followButton.exclusiveTouch = true
        self.followButton.setImage(TWHelper.imageNamed("icn_tweet_action_inline_follow_off_ipad_experiment"), forState: UIControlState.Normal)
        
        self.followButton.addBlockForControlEvents([UIControlEvents.TouchDown,UIControlEvents.TouchDragEnter]) { (sender ) -> Void in
            
            (sender as! UIButton).alpha = 0.6
        }
        
        self.followButton.addBlockForControlEvents([UIControlEvents.TouchUpInside,UIControlEvents.TouchUpOutside,UIControlEvents.TouchCancel,UIControlEvents.TouchDragExit]) { (sender ) -> Void in
            
            (sender as! UIButton).alpha = 1.0
        }
        
        self.addSubview(self.followButton)
        
       
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setWithLayout(layout: TWLayout) {
        
        let tw = layout.displayedTweet
        
        if tw.retweeted == "1" {
            
            self.retweetImageView.image = TWHelper.imageNamed("icn_tweet_action_inline_retweet_on_white")
            
        }else {
            
            self.retweetImageView.image = TWHelper.imageNamed("icn_tweet_action_inline_retweet_off")
            
        }
        
        if tw.favorited == "1" {
            
            self.favoriteImageView.image = TWHelper.imageNamed("icn_tweet_action_inline_favorite_on_white")
            
        }else {
            
            self.favoriteImageView.image = TWHelper.imageNamed("icn_tweet_action_inline_favorite_off")
            
        }
    
        if layout.retweetCountTextLayout != nil {
            
            self.retweetLabel.hidden = false
            self.retweetLabel.width = layout.retweetCountTextLayout!.textBoundingSize.width + 5
            self.retweetLabel.textLayout = layout.retweetCountTextLayout!
            self.retweetButton.width = self.retweetLabel.right - self.retweetButton.left
            
        }else {
            
            self.retweetLabel.hidden = true
            self.retweetButton.width = self.retweetButton.height
            
        }

        
        if layout.favoriteCountTextLayout != nil {
            
            self.favoriteLabel.hidden = false
            self.favoriteLabel.width = layout.favoriteCountTextLayout!.textBoundingSize.width + 5
            self.favoriteLabel.textLayout = layout.favoriteCountTextLayout!
            self.favoriteButton.width = self.favoriteLabel.right - self.favoriteButton.left
            
        }else {
            
            self.favoriteLabel.hidden = true
            self.favoriteButton.width = self.favoriteButton.height
            
        }
      
        if tw.user!.following == "1" {
            
            self.followButton.hidden = true
            
        }else {
            
            self.followButton.hidden = false
            self.followButton.setImage(TWHelper.imageNamed("icn_tweet_action_inline_follow_off_ipad_experiment"), forState: UIControlState.Normal)
            
        }
 
    }

}
