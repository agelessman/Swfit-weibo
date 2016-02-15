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
        
        self.replyButton.addBlockForControlEvents(UIControlEvents.TouchUpInside) { (sender) -> Void in
            
            if let _ = self.cell.delegate {
                
                self.cell.delegate!.cellDidClickReply(self.cell)
                
            }
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
   
   
        self.retweetButton.addBlockForControlEvents(UIControlEvents.TouchUpInside) { (sender) -> Void in
            
            if let _ = self.cell.delegate {
                
                self.cell.delegate!.cellDidClickRetweet(self.cell)
                
            }
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
        
        self.favoriteButton.addBlockForControlEvents(UIControlEvents.TouchUpInside) { (sender) -> Void in
            
            if let _ = self.cell.delegate {
                
                self.cell.delegate!.cellDidClickFavorite(self.cell)
                
            }
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
        
        self.followButton.addBlockForControlEvents(UIControlEvents.TouchUpInside) { (sender) -> Void in
            
            if let _ = self.cell.delegate {
                
                self.cell.delegate!.cellDidClickFollow(self.cell)
                
            }
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
    
    
    func updateRetweetWithAnimation() {
        
        let layout = self.cell.layout
        let tw = layout.displayedTweet
        if tw.retweeted == "1" {
            
            self.retweetImageView.image = TWHelper.imageNamed("icn_tweet_action_inline_retweet_on_white")
            
        }else {
            
            self.retweetImageView.image = TWHelper.imageNamed("icn_tweet_action_inline_retweet_off")
            
        }

        UIView.animateWithDuration(0.1, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            
            self.retweetImageView.layer.transformScale = 1.5
            
            }) { (finish) -> Void in
             
                UIView.animateWithDuration(0.1, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                    
                    self.retweetImageView.layer.transformScale = 1.0
                    
                    }) { (finish) -> Void in
                       
                        
                }
                
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
   
    }
    
    
    func updateFollowWithAnimation() {
        
        let layout = self.cell.layout
        let tw = layout.displayedTweet
        
        if tw.user?.following == "1" {
            self.followButton.setImage(TWHelper.imageNamed("icn_tweet_action_inline_follow_on_ipad_experiment"), forState: UIControlState.Normal)
            
        }else {
            
            self.followButton.setImage(TWHelper.imageNamed("icn_tweet_action_inline_follow_off_ipad_experiment"), forState: UIControlState.Normal)
            
        }

    }
    
    func updateFavouriteWithAnimation() {
        
        let layout = self.cell.layout
        let tw = layout.displayedTweet
        if tw.favorited == "1" {
            
            let img = TWHelper.imageNamed("fav02c-sheet")
            let contentRects = NSMutableArray()
            let durations = NSMutableArray()
            
            for var j = 0 ; j < 12 ; j++ {
                
                for var i = 0 ; i < 8 ; i++ {
                    
                    //swift 强调对象的初始化，在使用cgrect的时候，不能直接用 var rect: CGRect!
                    var rect: CGRect = CGRect()
                    rect.size = CGSizeMake(img!.size.width / 8, img!.size.height / 12)
                    rect.origin.x = img!.size.width / 8 * CGFloat(i)
                    rect.origin.y = img!.size.height / 12 * CGFloat(j)
                    contentRects.addObject(NSValue(CGRect: rect))
                    durations.addObject(NSNumber(double: 1.0 / 60.0))
                }
            }
            
            let sprite = YYSpriteSheetImage(spriteSheetImage: img, contentRects: contentRects as [AnyObject], frameDurations: durations as [AnyObject], loopCount: 1)
            self.favoriteImageView.image = sprite
            
        }else {
            
            self.favoriteImageView.image = TWHelper.imageNamed("icn_tweet_action_inline_favorite_off")
            UIView.animateWithDuration(0.1, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                
                self.favoriteImageView.layer.transformScale = 1.5
                
                }) { (finish) -> Void in
                    
                    UIView.animateWithDuration(0.1, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                        
                        self.favoriteImageView.layer.transformScale = 1.0
                        
                        }) { (finish) -> Void in
                            
                            
                    }
                    
            }
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
   
        
       
    }

}
