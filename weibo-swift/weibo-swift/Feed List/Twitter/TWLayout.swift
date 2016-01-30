//
//  TWLayout.swift
//  weibo-swift
//
//  Created by 马超 on 16/1/29.
//  Copyright © 2016年 马超. All rights reserved.
//

import UIKit



// 宽高
let kTWCellPadding: CGFloat = 12
let kTWCellInnerPadding: CGFloat = 6
let kTWCellExtendedPadding: CGFloat = 30
let kTWAvatarSize: CGFloat = 48
let kTWImagePadding: CGFloat = 4
let kTWConversationSplitHeight: CGFloat = 25
let kTWContentLeft: CGFloat = kTWCellPadding + kTWAvatarSize + kTWCellInnerPadding
let kTWContentWidth: CGFloat = kScreenWidth - 2 * kTWCellPadding - kTWAvatarSize - kTWCellInnerPadding
let kTWQuoteContentWidth: CGFloat = kTWContentWidth - 2 * kTWCellPadding
let kTWActionsHeight: CGFloat = 6
let kTWTextContainerInset: CGFloat = 4



let kTWUserNameFontSize: CGFloat = 14
let kTWUserNameSubFontSize: CGFloat = 12
let kTWTextFontSize: CGFloat = 14
let kTWActionFontSize: CGFloat = 12




// 颜色
let kTWUserNameColor = UIColor(hexString: "292F33")
let kTWUserNameSubColor = UIColor(hexString: "8899A6")
let kTWCellBGHighlightColor = UIColor(white: 0.000, alpha: 0.041)
let kTWTextColor = UIColor(hexString: "292F33")


let kTWTextHighlightedColor = UIColor(hexString: "1A91DA")
let kTWTextActionsColor = UIColor(hexString: "8899A6")
let kTWTextHighlightedBackgroundColor = UIColor(hexString: "ebeef0")
let kTWTextActionRetweetColor = UIColor(hexString: "19CF86")
let kTWTextActionFavoriteColor = UIColor(hexString: "FAB81E")






 class TWLayout: NSObject {

    var setTweet: TWTweet?
    var tweet: TWTweet? {
        
        set {
            self.setTweet = newValue
            self.layout()
        }
        
        get{

            return self.setTweet
        }
    }
     var conversation: TWConversation?
    
    
    var height: CGFloat       = 0
    var paddingTop: CGFloat   = 0
    var textTop: CGFloat      = 0
    var textHeight: CGFloat   = 0
    var imagesTop: CGFloat    = 0
    var imagesHeight: CGFloat = 0
    var quoteTop: CGFloat     = 0
    var quoteHeight: CGFloat  = 0
    
    
    var showTopLine                = false
    var isConversationSplit        = false
    var showConversationTopJoin    = false
    var showConversationBottomJoin = false
    
    var socialTextLayout: YYTextLayout!
    var nameTextLayout: YYTextLayout!
    var dateTextLayout: YYTextLayout!
    var textLayout: YYTextLayout!
    var quotedNameTextLayout: YYTextLayout!
    var quotedTextLayout: YYTextLayout!
    var retweetCountTextLayout: YYTextLayout!
    var favoriteCountTextLayout: YYTextLayout!
    
    var images: NSArray?
    var displayedTweet: TWTweet {
    get {
        return self.tweet!.retweetedStatus != nil ? self.tweet!.retweetedStatus! : self.tweet!
    }
    }
    
     func layout(){
        
        self.reset()
        
        if self.tweet == nil {
            
            if let _ = self.conversation {
                
                self.isConversationSplit = true
                self.height = kTWConversationSplitHeight
                return
            }else {
                return
            }
        }
        
        if let _ = self.conversation {
            var isTop = false
            var isBottom = false
            
            if let _ = self.tweet?.tidStr {
                var index = 0
                if self.conversation!.contextIDs != nil {
                    
                    index = self.conversation!.contextIDs!.indexOfObject(self.tweet!.tidStr!)
                }
                if index == 0 {
                    isTop = true
                }else if index + 1 == self.conversation!.contextIDs!.count {
                    isBottom = true
                }
            }
            
            if isTop {
                self.showTopLine = true
                self.showConversationBottomJoin = true
            }else if isBottom {
                self.showConversationTopJoin = true
            }else{
                self.showConversationTopJoin = true
                self.showConversationBottomJoin = true
            }
        }else{
            
            self.showTopLine = true
        }
        
        let tw = self.displayedTweet
        
        //计算日期
        let nameSubFont = UIFont.systemFontOfSize(kTWUserNameSubFontSize)
        let dateText = NSMutableAttributedString(string: TWHelper.stringWithTimelineDate(tw.createdAt!)!)
        if let _ = tw.card {
            let iconImage = TWHelper.imageNamed("ic_tweet_attr_summary_default")
            let icon = NSAttributedString.attachmentStringWithContent(iconImage, contentMode: UIViewContentMode.Center, attachmentSize: iconImage!.size, alignToFont: nameSubFont, alignment: YYTextVerticalAlignment.Center)
            dateText.insertString(" ", atIndex: 0)
            dateText.insertAttributedString(icon, atIndex: 0)
        }
 
        dateText.font = nameSubFont
        dateText.color = kTWUserNameSubColor
        dateText.alignment = NSTextAlignment.Right
        
        self.dateTextLayout = YYTextLayout(containerSize: CGSizeMake(kTWContentWidth, kTWUserNameSubFontSize * 2), text: dateText)
        
        //计算名字
        let nameFont = UIFont.systemFontOfSize(kTWUserNameFontSize)
        let nameText = NSMutableAttributedString(string: tw.user!.name != nil ? tw.user!.name! : "" )
        nameText.font = nameFont
        nameText.color = kTWUserNameColor
        
        if tw.user!.screenName != nil {
            
            let screenNameText = NSMutableAttributedString(string: tw.user!.screenName!)
            screenNameText.insertString(" @", atIndex: 0)
            screenNameText.font = nameSubFont
            screenNameText.color = kTWUserNameSubColor
            nameText.appendAttributedString(screenNameText)
        }
        nameText.lineBreakMode = NSLineBreakMode.ByCharWrapping
        
       let nameContainer = YYTextContainer(size: CGSizeMake(kTWContentWidth - self.dateTextLayout.textBoundingRect.size.width - 5, kTWUserNameFontSize * 2))
        nameContainer.maximumNumberOfRows = 1
        self.nameTextLayout = YYTextLayout(container: nameContainer, text: nameText)
  
        //头部
        var socialString: String?
        if self.tweet!.retweetedStatus != nil {
            
            if self.tweet!.user!.name != nil {
                
                socialString = self.tweet!.user!.name! + "  Retweeted"
            }
        }else if tw.inReplyToScreenName != nil {
            socialString = "in reply to  " + tw.inReplyToScreenName!
        }
     
        if let _ = socialString {
            
            let socialText = NSMutableAttributedString(string: socialString!)
            socialText.font = nameSubFont
            socialText.color = kTWUserNameSubColor
            socialText.lineBreakMode = NSLineBreakMode.ByCharWrapping
            let socialContainer = YYTextContainer(size: CGSizeMake(kTWContentWidth, kTWUserNameFontSize * 2))
            socialContainer.maximumNumberOfRows = 1
            self.socialTextLayout = YYTextLayout(container: socialContainer, text: socialText)
        }
        
        
        
        
        
        
        self.height = 40
    }
    
    
    func reset()
    {
        self.height = 0
        self.paddingTop = 0
        self.textTop = 0
        self.textHeight = 0
        self.imagesTop = 0
        self.imagesHeight = 0
        self.quoteTop = 0
        self.quoteHeight = 0
        
        self.showTopLine = false
        self.isConversationSplit = false
        self.showConversationTopJoin = false
        self.showConversationBottomJoin = false
        self.socialTextLayout = nil
        self.nameTextLayout = nil
        self.dateTextLayout = nil
        self.textLayout = nil
        self.quotedNameTextLayout = nil
        self.quotedTextLayout = nil
        self.retweetCountTextLayout = nil
        self.favoriteCountTextLayout = nil
        self.images = nil
    }

}
