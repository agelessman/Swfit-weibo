//
//  WBStatusLayout.swift
//  weibo-swift
//
//  Created by 马超 on 16/1/6.
//  Copyright © 2016年 马超. All rights reserved.
//

import UIKit

// 宽高
let kWBCellTopMargin = 8   // cell 顶部灰色留白
let kWBCellTitleHeight = 36   // cell 标题高度 (例如"仅自己可见")
let kWBCellPadding = 12   // cell 内边距
let kWBCellPaddingText = 10   // cell 文本与其他元素间留白
let kWBCellPaddingPic = 4   // cell 多张图片中间留白
let kWBCellProfileHeight = 56   // cell 名片高度
let kWBCellCardHeight = 70   // cell card 视图高度
let kWBCellNamePaddingLeft = 14   // cell 名字和 avatar 之间留白
let kWBCellContentWidth = Int(kScreenWidth) - 2 * kWBCellPadding   // cell 内容宽度
let kWBCellNameWidth = Int(kScreenWidth) - 110   // cell 名字最宽限制


let kWBCellTagPadding = 8         // tag 上下留白
let kWBCellTagNormalHeight = 16   // 一般 tag 高度
let kWBCellTagPlaceHeight = 24    // 地理位置 tag 高度

let kWBCellToolbarHeight = 35     // cell 下方工具栏高度
let kWBCellToolbarBottomMargin = 2 // cell 下方灰色留白


// 字体 应该做成动态的，这里只是 Demo，临时写死了。
let kWBCellNameFontSize = 16      // 名字字体大小
let kWBCellSourceFontSize = 12    // 来源字体大小
let kWBCellTextFontSize = 17      // 文本字体大小
let kWBCellTextFontRetweetSize = 16 // 转发字体大小
let kWBCellCardTitleFontSize = 16 // 卡片标题文本字体大小
let kWBCellCardDescFontSize = 12 // 卡片描述文本字体大小
let kWBCellTitlebarFontSize = 14 // 标题栏字体大小
let kWBCellToolbarFontSize = 14 // 工具栏字体大小

// 颜色
let kWBCellNameNormalColor = UIColor(hexString: "333333")// 名字颜色
let kWBCellNameOrangeColor = UIColor(hexString: "f26220") // 橙名颜色 (VIP)
let kWBCellTimeNormalColor = UIColor(hexString: "828282") // 时间颜色
let kWBCellTimeOrangeColor = UIColor(hexString: "f28824") // 橙色时间 (最新刷出)


let kWBCellTextNormalColor = UIColor(hexString: "333333") // 一般文本色
let kWBCellTextSubTitleColor = UIColor(hexString: "5d5d5d") // 次要文本色
let kWBCellTextHighlightColor = UIColor(hexString: "527ead") // Link 文本色
let kWBCellTextHighlightBackgroundColor = UIColor(hexString: "bfdffe") // Link 点击背景色
let kWBCellToolbarTitleColor = UIColor(hexString: "929292") // 工具栏文本色
let kWBCellToolbarTitleHighlightColor = UIColor(hexString: "df422d") // 工具栏文本高亮色

let kWBCellBackgroundColor = UIColor(hexString: "f2f2f2")    // Cell背景灰色
let kWBCellHighlightColor = UIColor(hexString: "f0f0f0")     // Cell高亮时灰色
let kWBCellInnerViewColor = UIColor(hexString: "f7f7f7")   // Cell内部卡片灰色
let kWBCellInnerViewHighlightColor  = UIColor(hexString: "f0f0f0") // Cell内部卡片高亮时灰色
let kWBCellLineColor = UIColor(white: 0.000, alpha: 0.09) //线条颜色


let kWBLinkHrefName = "href" //NSString
let kWBLinkURLName = "url" //WBURL
let kWBLinkTagName = "tag" //WBTag
let kWBLinkTopicName = "topic" //WBTopic
let kWBLinkAtName = "at" //NSString


/// 风格
enum WBLayoutStyle{
    
    case Timeline ///< 时间线 (目前只支持这一种)
    case Detail ///< 详情页
}

/// 卡片类型 (这里随便写的，只适配了微博中常见的类型)
enum WBStatusCardType{
    
    case None ///< 没卡片
    case Normal ///< 一般卡片布局
    case Video ///< 视频
}

/// 最下方Tag类型，也是随便写的，微博可能有更多类型同时存在等情况
enum WBStatusTagType{
    
    case None ///< 没Tag
    case Normal ///< 文本
    case Place ///< 地点
}





/**
 微博的文本中，某些嵌入的图片需要从网上下载，这里简单做个封装
 */

class WBTextImageViewAttachment :YYTextAttachment {
    
    var imageURL :NSURL?
    var size :CGSize?
    var _imageView :UIImageView?
    
    override var content :AnyObject? {
        
        set {
          _imageView = newValue as? UIImageView
        }
        get {
        
            /// UIImageView 只能在主线程访问
            if (pthread_main_np() == 0) {return nil};
            if ((_imageView) != nil) {return _imageView};
            
            /// 第一次获取时 (应该是在文本渲染完成，需要添加附件视图时)，初始化图片视图，并下载图片
            /// 这里改成 YYAnimatedImageView 就能支持 GIF/APNG/WebP 动画了
            _imageView = UIImageView();
            _imageView!.size = size!;
            _imageView?.setImageWithURL(imageURL, placeholder: nil)
            return _imageView;
            
        }
    }
 
}


var hrefRegex :NSRegularExpression?
var textRegex :NSRegularExpression?
class WBStatusLayout: NSObject {


  
    
    // 以下是数据
    var status :WBStatus?
    var style :WBLayoutStyle?
    
    //以下是布局结果
    
    // 顶部留白
    var marginTop :Float?
    
    // 标题栏
    var titleHeight :Float?  //标题栏高度，0为没标题栏
    var titleTextLayout :YYTextLayout?  // 标题栏
    
    // 个人资料
    var profileHeight :Float? //个人资料高度(包括留白)
    var nameTextLayout :YYTextLayout? // 名字
    var sourceTextLayout :YYTextLayout?  //时间/来源
    
    // 文本
    var textHeight :Float?//文本高度(包括下方留白)
    var textLayout :YYTextLayout? //文本
    
    // 图片
    var picHeight :Float? //图片高度，0为没图片
    var picSize :CGSize?
    
    // 转发
    var retweetHeight :Float? //转发高度，0为没转发
    var retweetTextHeight :Float?
    var retweetTextLayout :YYTextLayout? //被转发文本
    var retweetPicHeight :Float?
    var retweetPicSize :CGSize?
    var retweetCardHeight :Float?
    var retweetCardType :WBStatusCardType?
    var retweetCardTextLayout :YYTextLayout?  //被转发文本
    var retweetCardTextRect :CGRect?
    
    // 卡片
    var cardHeight :Float? //卡片高度，0为没卡片
    var cardType :WBStatusCardType?
    var cardTextLayout :YYTextLayout? //卡片文本
    var cardTextRect :CGRect?
    
    // Tag
    var tagHeight :Float? //Tip高度，0为没tip
    var tagType :WBStatusTagType?
    var tagTextLayout :YYTextLayout? //最下方tag
    
    // 工具栏
    var toolbarHeight :Float?  // 工具栏
    var toolbarRepostTextLayout :YYTextLayout?
    var toolbarCommentTextLayout :YYTextLayout?
    var toolbarLikeTextLayout :YYTextLayout?
    var toolbarRepostTextWidth :Float?
    var toolbarCommentTextWidth :Float?
    var toolbarLikeTextWidth :Float?
    
    // 下边留白
    var marginBottom :Float?  //下边留白
    
    // 总高度
    var height :Float?
    
    //初始化
    convenience init(status :WBStatus , style :WBLayoutStyle) {
        self.init()
        self.status = status
        self.style = style
        self.layout()
    }
    
    //MARK: 更新显示时间
     func updateDate() {
        self._layoutSource()
    }
    
    //MARK:< 计算布局
     func layout()
    {
        self._layout()
    }
    
    
    func _layout()
    {
        marginTop = Float(kWBCellTopMargin)
        titleHeight = 0
        profileHeight = 0
        textHeight = 0
        retweetHeight = 0
        retweetTextHeight = 0
        retweetPicHeight = 0
        retweetCardHeight = 0
        picHeight = 0
        cardHeight = 0
        toolbarHeight = Float(kWBCellToolbarHeight)
        marginBottom = Float(kWBCellToolbarBottomMargin)
        
        self._layoutTitle()
        self._layoutProfile()
        self._layoutRetweet()
        if retweetHeight == 0 {
            self._layoutPics()
            if picHeight == 0 {
                self._layoutCard()
            }
        }
        
        self._layoutText()
        self._layoutTag()
        self._layoutToolbar()
        
        // 计算高度
        height = 0;
        height! += marginTop!
        height! += titleHeight!
        height! += profileHeight!
        height! += textHeight!
        
        if retweetHeight > 0 { height! += retweetHeight! }
        else if picHeight > 0 { height! += picHeight! }
        else if cardHeight > 0 { height! += cardHeight! }
        
        if tagHeight > 0 { height! += tagHeight! }
        else {
            if picHeight > 0 || cardHeight > 0 { height! += Float(kWBCellPadding) }
        }
        height! += toolbarHeight!;
        height! += marginBottom!;
    }
    
    
    //MARK:计算标题的布局
    func _layoutTitle()
    {
        titleHeight = 0
        let title :WBStatusTitle? = self.status?.title
        if title?.text == nil { return }
        let text = NSMutableAttributedString(string: title!.text!)
        if let _ = title!.iconURL
        {
            let icon = self._attachmentWithFontSize(Float(kWBCellTitlebarFontSize), imageURL: (title?.iconURL!)!, shrink: false) 
            if let _ = icon
            {
                text.insertAttributedString(icon!, atIndex: 0)
            }
        }
        
        text.color = kWBCellToolbarTitleColor
        text.font = UIFont.systemFontOfSize(CGFloat(kWBCellTitlebarFontSize))
        
        let container = YYTextContainer(size: CGSizeMake(kScreenWidth - 100.0, CGFloat(kWBCellTitleHeight)))
        titleTextLayout = YYTextLayout(container: container, text: text)
        titleHeight = Float(kWBCellTitleHeight)
    }
    
    
    //MARK:计算名字和来源的布局
    func _layoutProfile()
    {
        self._layoutName()
        self._layoutSource()
        self.profileHeight = Float(kWBCellProfileHeight)
    }
    
    //MARK:计算名字的布局
    func _layoutName()
    {
        let user = (status?.user)!
//        print(user.followers_count)
        var nameStr :String = ""
        if let _ = user.remark {
            if (user.remark! as NSString).length > 0
            {
                nameStr = user.remark!
            }
        }
        
        if nameStr == "" {
            if let _ = user.screenName {
                if (user.screenName! as NSString).length > 0
                {
                    nameStr = user.screenName!
                }
            }
        }
        
        if nameStr == "" {
           nameStr = user.name!
        }
        
     
        
        if  nameStr == ""
        {
            nameTextLayout = nil
            return
        }
        
        let nameText = NSMutableAttributedString(string: nameStr)
        
        //蓝V
        if user.userVerifyType == WBUserVerifyType.WBUserVerifyTypeOrganization
        {
            let blueVImage :UIImage = WBStatusHelper.imageNamed("avatar_enterprise_vip")!
            let blueVText : NSAttributedString = self._attachmentWithFontSize(Float(kWBCellNameFontSize), image: blueVImage, shrink: false)!
            nameText.appendString(" ")
            nameText.appendAttributedString(blueVText)
        }
        
        //vip
        if user.mbrank != nil {
            if Int(user.mbrank!) > 0
            {
                
                var yelllowVImage = WBStatusHelper.imageNamed("common_icon_membership_level" + user.mbrank!)
                if yelllowVImage == nil { yelllowVImage = WBStatusHelper.imageNamed("common_icon_membership")}
                let vipText : NSAttributedString = self._attachmentWithFontSize(Float(kWBCellNameFontSize), image: yelllowVImage!, shrink: false)!
                nameText.appendString(" ")
                nameText.appendAttributedString(vipText)
            }
        }
        
    
        nameText.font = UIFont.systemFontOfSize(CGFloat(kWBCellNameFontSize))
        if user.mbrank != nil && Int(user.mbrank!) > 0 {
            nameText.color = kWBCellNameOrangeColor
        }else{
            nameText.color = kWBCellNameNormalColor
        }
       
        nameText.lineBreakMode = NSLineBreakMode.ByCharWrapping
        
        let container = YYTextContainer(size: CGSizeMake(CGFloat(kWBCellNameWidth), 999.0))
        container.maximumNumberOfRows = 1
        nameTextLayout = YYTextLayout(container: container, text: nameText)
        
    }
    
    //MARK:计算时间和来源
    func _layoutSource()
    {
        let sourceText = NSMutableAttributedString()

        let createTime = WBStatusHelper.stringWithTimelineDate(status?.createdAt)
        //时间
        if let _ = createTime {
            let timeText = NSMutableAttributedString(string: createTime!)
            timeText.appendString(" ")
            timeText.font = UIFont.systemFontOfSize(CGFloat(kWBCellSourceFontSize))
            timeText.color = kWBCellTimeNormalColor
            sourceText.appendAttributedString(timeText)
        }
        // 来自 XXX
        if let _ = status?.source {
            // <a href="sinaweibo://customweibosource" rel="nofollow">iPhone 5siPhone 5s</a>
            
            if hrefRegex == nil || textRegex == nil {
                do {
                    try hrefRegex = NSRegularExpression(pattern: "(?<=href=\").+(?=\" )", options: NSRegularExpressionOptions.AllowCommentsAndWhitespace)
                    try textRegex = NSRegularExpression(pattern: "(?<=>).+(?=<)", options: NSRegularExpressionOptions.AllowCommentsAndWhitespace)
                }catch{}
            }
            
          
            var href :String?
            var text :String?
            let hrefResult = hrefRegex!.firstMatchInString(status!.source!, options: NSMatchingOptions.init(rawValue: 0), range: NSMakeRange(0, status!.source!.startIndex.distanceTo(status!.source!.endIndex)))
            let textResult = textRegex!.firstMatchInString(status!.source!, options: NSMatchingOptions.init(rawValue: 0), range: NSMakeRange(0, status!.source!.startIndex.distanceTo(status!.source!.endIndex)))
            if hrefResult != nil && textResult != nil && hrefResult?.range.location != NSNotFound && textResult?.range.location != NSNotFound
            {
                let hreRange = Range(start: status!.source!.startIndex.advancedBy(hrefResult!.range.location), end: status!.source!.startIndex.advancedBy(hrefResult!.range.location + hrefResult!.range.length))
                let textRange = Range(start: status!.source!.startIndex.advancedBy(textResult!.range.location), end: status!.source!.startIndex.advancedBy(textResult!.range.location + textResult!.range.length))
                href = status!.source!.substringWithRange(hreRange)
                text = status!.source!.substringWithRange(textRange)
            }
            if href != nil && text != nil
            {
                let from = NSMutableAttributedString()
                from.appendString("来自 \(text!)")
                from.font = UIFont.systemFontOfSize(CGFloat(kWBCellSourceFontSize))
                from.color = kWBCellTimeNormalColor
                
                if  status!.sourceAllowClick != nil && Int(status!.sourceAllowClick!) > 0
                {
                    let range = NSMakeRange(3, text!.startIndex.distanceTo(text!.endIndex))
                    from.setColor(kWBCellTextHighlightColor, range: range)
                    let backed = YYTextBackedString(string: href)
                    from.setTextBackedString(backed, range: range)
                    
                    let border = YYTextBorder()
                    border.insets = UIEdgeInsetsMake(-2, 0, -2, 0);
                    border.fillColor = kWBCellTextHighlightBackgroundColor;
                    border.cornerRadius = 3;
                    
                    let highlight = YYTextHighlight()
                    if let _ = href
                    {
                        highlight.userInfo = [kWBLinkHrefName : href!]
                    }
                    highlight.setBackgroundBorder(border)
                    from.setTextHighlight(highlight, range: range)
                }
                
                sourceText.appendAttributedString(from)
            }
            
        }
        
        if sourceText.length == 0 { sourceTextLayout = nil }
        else{
        
            let container = YYTextContainer(size: CGSizeMake(CGFloat(kWBCellNameWidth), 9999))
            container.maximumNumberOfRows = 1
            sourceTextLayout = YYTextLayout(container: container, text: sourceText)
        }
        
    }

    //MARK: 计算微博正文
    func _layoutText() {
        
        textHeight = 0;
        textLayout = nil;
        
        let text = self._textWithStatus(status, isRetweet: false, fontSize: CGFloat(kWBCellTextFontSize), textColor: kWBCellTextNormalColor)
        if text.length == 0 { return }
        
        let modifier = WBTextLinePositionModifier()
        modifier.font = UIFont(name: "Heiti SC", size: CGFloat(kWBCellTextFontSize))
        modifier.paddingTop = CGFloat(kWBCellPaddingText)
        modifier.paddingBottom = CGFloat(kWBCellPaddingText)
        
        let container = YYTextContainer()
        container.size = CGSizeMake(CGFloat(kWBCellContentWidth), CGFloat(MAXFLOAT))
        container.linePositionModifier = modifier
        
        textLayout = YYTextLayout(container: container, text: text)
        if textLayout == nil { return }
        
        textHeight = Float(modifier.heightForLineCount((textLayout?.lines.count)!))
    }
    
    //MARK:计算转发微博
    func _layoutRetweet()
    {
        retweetHeight = 0
        self._layoutRetweetedText()
        self._layoutRetweetPics()
        if retweetPicHeight == 0 { self._layoutRetweetCard() }
        retweetHeight = retweetTextHeight
        if retweetPicHeight > 0 {
            retweetHeight = retweetPicHeight! + retweetHeight!
            retweetHeight = Float(kWBCellPadding) + retweetHeight!
        }else if retweetCardHeight > 0 {
            retweetHeight = retweetCardHeight! + retweetHeight!
            retweetHeight = Float(kWBCellPadding) + retweetHeight!
        }
    }
    
    func _layoutRetweetedText() {
        
        retweetHeight = 0;
        retweetTextLayout = nil;
        
        let text = self._textWithStatus(status!.retweetedStatus, isRetweet: true, fontSize: CGFloat(kWBCellTextFontRetweetSize), textColor: kWBCellTextSubTitleColor)
        if text.length == 0 { return }
        
        let modifier = WBTextLinePositionModifier()
        modifier.font = UIFont(name: "Heiti SC", size: CGFloat(kWBCellTextFontRetweetSize))
        modifier.paddingTop = CGFloat(kWBCellPaddingText)
        modifier.paddingBottom = CGFloat(kWBCellPaddingText)
        
        let container = YYTextContainer()
        container.size = CGSizeMake(CGFloat(kWBCellContentWidth), CGFloat(MAXFLOAT))
        container.linePositionModifier = modifier
        
        retweetTextLayout = YYTextLayout(container: container, text: text)
        if retweetTextLayout == nil { return }
        
        retweetTextHeight = Float(modifier.heightForLineCount((retweetTextLayout?.lines.count)!))
    }
    
    func _layoutPics() {
        self._layoutPicsWithStatus(status!, isRetweet: false)
    }
    
    func _layoutRetweetPics() {
        self._layoutPicsWithStatus(status!.retweetedStatus, isRetweet: true)
    }
    //MARK: 计算图片的布局
    func _layoutPicsWithStatus(status :WBStatus? , isRetweet :Bool) {
        
        if status == nil { return }
        if status!.pics == nil { return }
        if isRetweet {
            retweetPicSize = CGSizeZero
            retweetPicHeight = 0
        }else {
            picSize = CGSizeZero
            picHeight = 0
        }
        if status!.pics?.count == 0 { return }
        
        var pic_Size :CGSize = CGSizeZero
        var pic_Height :CGFloat = 0
        
        var len1_3 = CGFloat((kWBCellContentWidth + kWBCellPaddingPic) / 3 - kWBCellPaddingPic)
        len1_3 = CGFloatPixelRound(len1_3)
      
        switch status!.pics!.count  {
        case 1 :
            let pic :WBPicture = status!.pics!.firstObject as! WBPicture
            let bmiddle :WBPictureMetadata = pic.bmiddle!
            
            //方形
            if pic.keepSize == "1" || Int(bmiddle.width!)! < 1 || Int(bmiddle.height!)! < 1 {
                var maxLen = CGFloat(kWBCellContentWidth) / 2.0
                maxLen = CGFloatPixelRound(maxLen)
                pic_Size = CGSizeMake(maxLen, maxLen)
                pic_Height = maxLen
            }else{
                let maxLen = len1_3 * 2 + CGFloat(kWBCellPaddingPic)
                if bmiddle.width < bmiddle.height {
                    pic_Size.width = CGFloat(Int(bmiddle.width!)!) / CGFloat(Int(bmiddle.height!)!) * maxLen;
                    pic_Size.height = maxLen;
                }else{
                    pic_Size.height = CGFloat(Int(bmiddle.width!)!) / CGFloat(Int(bmiddle.height!)!) * maxLen;
                    pic_Size.width = maxLen;
                }
                pic_Size = CGSizePixelRound(pic_Size);
                pic_Height = pic_Size.height;
            }
        case 2,3 :
            pic_Size = CGSizeMake(len1_3, len1_3);
            pic_Height = len1_3;
        case 4,5,6 :
            pic_Size = CGSizeMake(len1_3, len1_3);
            pic_Height = len1_3 * 2 + CGFloat(kWBCellPaddingPic);
        default :
            pic_Size = CGSizeMake(len1_3, len1_3);
            pic_Height = len1_3 * 3 + CGFloat(kWBCellPaddingPic * 2);
        }
        
        if (isRetweet) {
            retweetPicSize = pic_Size;
            retweetPicHeight = Float(pic_Height);
        } else {
            picSize = pic_Size;
            picHeight = Float(pic_Height);
        }
        
    }
    
    func _layoutCard() {
        self._layoutCardWithStatus(status!, isRetweet: false)
    }
    func _layoutRetweetCard() {
        self._layoutCardWithStatus(status!.retweetedStatus, isRetweet: true)
    }
    
    //MARK: 计算card布局
    func  _layoutCardWithStatus(status :WBStatus? , isRetweet :Bool) {
        if status == nil { return }
        //初始化
        if isRetweet {
            retweetCardType = WBStatusCardType.None
            retweetCardHeight = 0
            retweetCardTextLayout = nil
            retweetCardTextRect = CGRectZero
        } else {
            cardType = WBStatusCardType.None
            cardHeight = 0
            cardTextLayout = nil
            cardTextRect = CGRectZero
        }
        let pageInfo = status!.pageInfo
        if pageInfo == nil { return }
        
        var card_Type = WBStatusCardType.None
        var card_Height :CGFloat = 0
        var card_TextLayout :YYTextLayout?
        var text_Rect = CGRectZero
        
        if pageInfo!.type == 11 && pageInfo?.objectType == "video" {// 视频，一个大图片，上面播放按钮
            
            if let _ = pageInfo!.pagePic {
                card_Type = WBStatusCardType.Video
                card_Height = CGFloat(2 * kWBCellContentWidth - kWBCellPaddingPic) / 3.0
            }
        }else{
            let hasImage = pageInfo!.pagePic != nil
            let hasBadge = pageInfo!.typeIcon != nil
            let button =  pageInfo!.buttons?.firstObject as? WBButtonLink
            let hasButton = button?.pic != nil && button?.name != nil
            
            /*
            badge: 25,25 左上角 (42)
            image: 70,70 方形
            100, 70 矩形
            btn:  60,70
            
            lineheight 20
            padding 10
            */
            
            text_Rect.size.height = 70
            if hasImage {
                if hasBadge {
                    text_Rect.origin.x = 100
                } else {
                    text_Rect.origin.x = 70
                }
            } else {
                if hasBadge {
                    text_Rect.origin.x = 42
                }
            }
            text_Rect.origin.x += 10 //padding
            text_Rect.size.width = CGFloat(kWBCellContentWidth) - text_Rect.origin.x
            if hasButton { text_Rect.size.width -= 60 }
            text_Rect.size.width -= 10 //padding
            
            let text = NSMutableAttributedString()
            if pageInfo!.pageTitle != nil {
                let title = NSMutableAttributedString(string: pageInfo!.pageTitle!)
                title.font = UIFont.systemFontOfSize(CGFloat(kWBCellCardTitleFontSize))
                title.color = kWBCellNameNormalColor
                text.appendAttributedString(title)
            }
            if let _ = pageInfo!.pageDesc {
                if text.length > 0 { text.appendString("\n")}
                let desc = NSMutableAttributedString(string: pageInfo!.pageDesc!)
                desc.font = UIFont.systemFontOfSize(CGFloat(kWBCellCardDescFontSize))
                desc.color = kWBCellNameNormalColor
                text.appendAttributedString(desc)
            }else if let _ = pageInfo!.content2 {
                if text.length > 0 { text.appendString("\n")}
                let content2 = NSMutableAttributedString(string: pageInfo!.content2!)
                content2.font = UIFont.systemFontOfSize(CGFloat(kWBCellCardDescFontSize))
                content2.color = kWBCellTextSubTitleColor
                text.appendAttributedString(content2)
            }else if let _ = pageInfo!.content3 {
                if text.length > 0 { text.appendString("\n")}
                let content3 = NSMutableAttributedString(string: pageInfo!.content3!)
                content3.font = UIFont.systemFontOfSize(CGFloat(kWBCellCardDescFontSize))
                content3.color = kWBCellTextSubTitleColor
                text.appendAttributedString(content3)
            }
            
            if let _ = pageInfo!.tips {
                if text.length > 0 { text.appendString("\n")}
                let tips = NSMutableAttributedString(string: pageInfo!.tips!)
                tips.font = UIFont.systemFontOfSize(CGFloat(kWBCellCardDescFontSize))
                tips.color = kWBCellTextSubTitleColor
                text.appendAttributedString(tips)
            }
            
            if text.length > 0 {
                text.maximumLineHeight = 20
                text.minimumLineHeight = 20
                text.lineBreakMode = NSLineBreakMode.ByTruncatingTail
                
                let container = YYTextContainer(size: text_Rect.size)
                container.maximumNumberOfRows = 3
                card_TextLayout = YYTextLayout(container: container, text: text)
            }
            
            if card_TextLayout != nil {
                card_Type = WBStatusCardType.Normal;
                card_Height = 70;
            }
            
            if isRetweet {
                retweetCardType = card_Type
                retweetCardHeight = Float(card_Height)
                retweetCardTextLayout = card_TextLayout
                retweetCardTextRect = text_Rect
            } else {
                cardType = card_Type
                cardHeight = Float(card_Height)
                cardTextLayout = card_TextLayout
                cardTextRect = text_Rect
            }
        }
    }
    
    //MARK: 计算tag布局
    func _layoutTag() {
        tagType = WBStatusTagType.None
        tagHeight = 0
        let tag :WBTag? = status?.tagStruct?.firstObject as? WBTag
        if tag == nil { return }
        let text = NSMutableAttributedString(string: tag!.tagName!)
        if tag!.tagType == 1 {
            tagType = WBStatusTagType.Place
            tagHeight = 40
            text.color = UIColor(white: 0.217, alpha: 1.000)
        }else{
            tagType = WBStatusTagType.Normal
            tagHeight = 32
            if tag!.urlTypePic != nil {
                let pic = self._attachmentWithFontSize(Float(kWBCellCardDescFontSize), imageURL: tag!.urlTypePic!.absoluteString, shrink: true)
                text.insertAttributedString(pic!, atIndex: 0)
            }
            
            // 高亮状态的背景
            let highlightBorder = YYTextBorder()
            highlightBorder.insets = UIEdgeInsetsMake(-2, 0, -2, 0)
            highlightBorder.cornerRadius = 2
            highlightBorder.fillColor = kWBCellTextHighlightBackgroundColor
            
            text.setColor(kWBCellTextHighlightColor, range: text.rangeOfAll())

            // 高亮状态
            let highlight = YYTextHighlight()
            highlight.setBackgroundBorder(highlightBorder)

            // 数据信息，用于稍后用户点击
            highlight.userInfo = [kWBLinkTagName : tag!]
            text.setTextHighlight(highlight, range: text.rangeOfAll())
        }
        text.font = UIFont.systemFontOfSize(CGFloat(kWBCellCardDescFontSize))
        let container = YYTextContainer(size: CGSizeMake(9999, 9999))
        tagTextLayout = YYTextLayout(container: container, text: text)
        if tagTextLayout == nil {
            tagType = WBStatusTagType.None
            tagHeight = 0
        }
        
    }
    
    //MARK: 计算tool的布局
    func _layoutToolbar() {
        // should be localized
        let font = UIFont.systemFontOfSize(CGFloat(kWBCellToolbarFontSize))
        let container = YYTextContainer(size: CGSizeMake(CGFloat(kScreenWidth), CGFloat(kWBCellToolbarHeight)))
        container.maximumNumberOfRows = 1
        
        let repostText = NSMutableAttributedString(string: UInt(status!.repostsCount!)! <= 0 ? "转发" : WBStatusHelper.shortedNumberDesc(UInt(status!.repostsCount!)!)!)
        repostText.font = font
        repostText.color = kWBCellToolbarTitleColor
        toolbarRepostTextLayout = YYTextLayout(container: container, text: repostText)
        toolbarRepostTextWidth = Float(CGFloatPixelRound(CGFloat(toolbarRepostTextLayout!.textBoundingRect.size.width)))
        
        let commentText = NSMutableAttributedString(string: UInt(status!.commentsCount!)! <= 0 ? "评论" : WBStatusHelper.shortedNumberDesc(UInt(status!.commentsCount!)!)!)
        commentText.font = font
        commentText.color = kWBCellToolbarTitleColor
        toolbarCommentTextLayout = YYTextLayout(container: container, text: commentText)
        toolbarCommentTextWidth = Float(CGFloatPixelRound(CGFloat(toolbarCommentTextLayout!.textBoundingRect.size.width)))
        
        let likeText = NSMutableAttributedString(string: UInt(status!.attitudesCount!)! <= 0 ? "赞" : WBStatusHelper.shortedNumberDesc(UInt(status!.attitudesCount!)!)!)
        likeText.font = font
        likeText.color = status!.attitudesStatus != "0" ? kWBCellToolbarTitleHighlightColor : kWBCellToolbarTitleColor
        toolbarLikeTextLayout = YYTextLayout(container: container, text: likeText)
        toolbarLikeTextWidth = Float(CGFloatPixelRound(CGFloat(toolbarLikeTextLayout!.textBoundingRect.size.width)))
    }
    //MARK: 私有函数
    
    func _textWithStatus(status :WBStatus? , isRetweet :Bool , fontSize :CGFloat , textColor :UIColor) -> NSMutableAttributedString
    {
        if status == nil { return NSMutableAttributedString() }
        if status!.text == nil { return NSMutableAttributedString()}
        
        //拼接@
        let string :NSMutableString = NSMutableString(string: status!.text!)
        if isRetweet {
            var name = status!.user?.name
            if name == nil { name = status!.user?.screenName}
            if let _ = name {
               let insert = "@\(name!):"
                string.insertString(insert, atIndex: 0)
            }
        }
        
        //字体
        let font = UIFont.systemFontOfSize(fontSize)
        // 高亮状态的背景
        let highlightBorder = YYTextBorder()
        highlightBorder.insets = UIEdgeInsetsMake(-2, 0, -2, 0)
        highlightBorder.cornerRadius = 3
        highlightBorder.fillColor = kWBCellTextHighlightBackgroundColor
        
        let text = NSMutableAttributedString(string: string as String)
        text.font = font
        text.color = textColor
        
        if status!.urlStruct?.count > 0 {
            for wburl :WBURL in status!.urlStruct as! [WBURL]
            {
                if wburl.shortURL == nil { continue }
                if wburl.urlTitle == nil { continue }
                
                var urlTitle :NSString = wburl.urlTitle!
                if urlTitle.length > 27  {
                    urlTitle = urlTitle.substringToIndex(27).stringByAppendingString(YYTextTruncationToken)
                }
                var searchRange = Range(start: text.string.startIndex, end:text.string.endIndex)
                
                repeat {
                    let range = text.string.rangeOfString(wburl.shortURL!, options: NSStringCompareOptions.LiteralSearch, range: searchRange , locale: nil)
                    if range == nil { break }
                    
                    //当匹配到最后的一个链接的情况下
                    if text.string.startIndex.distanceTo(range!.startIndex) + range!.startIndex.distanceTo(range!.endIndex) == text.string.startIndex.distanceTo(text.string.endIndex) {
                        
                        //如果存在page，把最后的链接替换成卡片
                        if status!.pageInfo?.pageID != nil && wburl.pageID != nil && status!.pageInfo?.pageID == wburl.pageID {
                            if (!isRetweet && status!.retweetedStatus == nil) || isRetweet {
                                
                                if status!.pics?.count == 0 {
                                    text.replaceCharactersInRange(NSMakeRange(range!.startIndex.distanceTo(text.string.startIndex), range!.startIndex.distanceTo(range!.endIndex)), withString: "")
                                    
                                    break // cut the tail, show with card
                                }
                            }
                            
                            
                        }
                        
                    }
                    
                    if text.attribute(YYTextHighlightAttributeName, atIndex: UInt(text.string.startIndex.distanceTo(range!.startIndex))) == nil {
                        // 替换的内容
                        let replace :NSMutableAttributedString = NSMutableAttributedString(string: urlTitle as String)
                        if wburl.url_type_pic != nil {
                            // 链接头部有个图片附件 (要从网络获取)
                            let picURL = WBStatusHelper.defaultURLForImageURL(wburl.url_type_pic)
                            let image = YYImageCache.sharedCache().getImageForKey(picURL?.absoluteString)
                            let pic :NSAttributedString = ((image != nil && wburl.pics?.count == 0 ) ? self._attachmentWithFontSize(Float(fontSize), image: image, shrink: true) : self._attachmentWithFontSize(Float(fontSize), imageURL: wburl.url_type_pic! as String, shrink: true))!
                            replace.insertAttributedString(pic, atIndex: 0)
                            
                        }
                        replace.font = font
                        replace.color = kWBCellTextHighlightColor
                        
                        // 高亮状态
                        let highlight = YYTextHighlight()
                        highlight.setBackgroundBorder(highlightBorder)
                        
                        // 数据信息，用于稍后用户点击
                        highlight.userInfo = [kWBLinkURLName : wburl]
                        replace.setTextHighlight(highlight, range: NSMakeRange(0, replace.length))
                        
                        // 替换
                        text.replaceCharactersInRange(NSMakeRange(text.string.startIndex.distanceTo(range!.startIndex), range!.startIndex.distanceTo(range!.endIndex)), withAttributedString: replace)
                        
                        //调整搜索范围
                        searchRange.startIndex = text.string.startIndex.advancedBy((replace.length > 0 ? replace.length : 1))
                        
                        if (text.string.startIndex.distanceTo(searchRange.startIndex) + 1 >= text.length) {break};
                        //好像不变得
                        searchRange.endIndex = searchRange.startIndex.advancedBy(text.length - text.string.startIndex.distanceTo(searchRange.startIndex))
                        
                    }else{
                        //调整搜索范围
                        searchRange.startIndex = text.string.startIndex.advancedBy(searchRange.startIndex.distanceTo(searchRange.endIndex) > 0 ? searchRange.startIndex.distanceTo(searchRange.endIndex) : 1)
                        
                        if (text.string.startIndex.distanceTo(searchRange.startIndex) + 1 >= text.length) {break};
                        //好像不变得
                        searchRange.endIndex = searchRange.startIndex.advancedBy(text.length - text.string.startIndex.distanceTo(searchRange.startIndex))
                    }
                    
                }while(true)
            }
        }
        
        
        if status!.topicStruct?.count > 0 {
        
            // 根据 topicStruct 中每个 Topic.topicTitle 来匹配文本，标记为话题
            for topic :WBTopic in status!.topicStruct as! [WBTopic]
            {
                if topic.topicTitle == nil { continue }
                
                let topicTitle = "#\(topic.topicTitle!)#"
                var searchRange = Range(start: text.string.startIndex, end:text.string.endIndex)
                
                repeat {
                    let range = text.string.rangeOfString(topicTitle, options: NSStringCompareOptions.LiteralSearch, range: searchRange , locale: nil)
                    if range == nil { break }
                    
                    if text.attribute(YYTextHighlightAttributeName, atIndex: UInt(text.string.startIndex.distanceTo(range!.startIndex))) == nil {
                        
                        text.setColor(kWBCellTextHighlightColor, range: NSMakeRange(text.string.startIndex.distanceTo(range!.startIndex), range!.startIndex.distanceTo(range!.endIndex)))
                        // 高亮状态
                        let highlight = YYTextHighlight()
                        highlight.setBackgroundBorder(highlightBorder)
                        
                        // 数据信息，用于稍后用户点击
                        highlight.userInfo = [kWBLinkTopicName : topic]
                        
                        text.setTextHighlight(highlight, range: NSMakeRange(text.string.startIndex.distanceTo(range!.startIndex), range!.startIndex.distanceTo(range!.endIndex)))
                    }
                    
                    //调整搜索范围
                    searchRange.startIndex = text.string.startIndex.advancedBy(searchRange.startIndex.distanceTo(searchRange.endIndex) > 0 ? searchRange.startIndex.distanceTo(searchRange.endIndex) : 1)
                    
                    if (text.string.startIndex.distanceTo(searchRange.startIndex) + 1 >= text.length) {break};
                    //好像不变得
                    searchRange.endIndex = searchRange.startIndex.advancedBy(text.length - text.string.startIndex.distanceTo(searchRange.startIndex))
                    
                    
                }while(true)
            }
        }
        

        // 匹配 @用户名
      
        
        let atResults = WBStatusHelper.regexAt().matchesInString(text.string, options: NSMatchingOptions(), range: text.rangeOfAll())
        for at :NSTextCheckingResult in atResults as [NSTextCheckingResult]
        {
            if at.range.location == NSNotFound && at.range.length <= 1 { continue }
            if text.attribute(YYTextHighlightAttributeName, atIndex: UInt(at.range.location)) == nil {
                
                 text.setColor(kWBCellTextHighlightColor, range: at.range)
                // 高亮状态
                let highlight = YYTextHighlight()
                highlight.setBackgroundBorder(highlightBorder)
                
                // 数据信息，用于稍后用户点击
                highlight.userInfo = [kWBLinkAtName : text.string.substringWithRange(Range(start: text.string.startIndex.advancedBy(at.range.location + 1), end: text.string.startIndex.advancedBy(at.range.length  + at.range.location)))]
                text.setTextHighlight(highlight, range: at.range)
            }
        }
        
        
        // 匹配 [表情]
        let emoticonResults = WBStatusHelper.regexEmoticon().matchesInString(text.string, options: NSMatchingOptions.Anchored, range: text.rangeOfAll())
        
        //处理间隙
        var emoClipLength :Int = 0
        for emo :NSTextCheckingResult in emoticonResults as [NSTextCheckingResult]
        {
            if emo.range.location == NSNotFound && emo.range.length <= 1 { continue }
            var range = emo.range
            range.location -= emoClipLength
            if text.attribute(YYTextHighlightAttributeName, atIndex: UInt(range.location)) != nil { continue}
            if text.attribute(YYTextAttachmentAttributeName, atIndex: UInt(range.location)) != nil { continue}
            let emoString = text.string.substringWithRange(Range(start: text.string.startIndex.advancedBy(range.location), end: text.string.startIndex.advancedBy(range.location + range.length)))
            let imagePath = WBStatusHelper.emoticonDic()![emoString]
            let image = WBStatusHelper.imageWithPath(imagePath! as? NSString )
            if image == nil { continue}
       
            let emoText = NSAttributedString.attachmentStringWithEmojiImage(image!, fontSize: fontSize)
            text.replaceCharactersInRange(range, withAttributedString: emoText)
            emoClipLength += range.length - 1
        }
    
        return text
    }
    
    func _attachmentWithFontSize(fontSize :Float ,image :UIImage ,shrink :Bool) -> NSAttributedString?
    {
        /*
        微博 URL 嵌入的图片，比临近的字体要小一圈。。
        这里模拟一下 Heiti SC 字体，然后把图片缩小一下。
        */
        let ascent :Float = fontSize * 0.86
        let descent :Float = fontSize * 0.14
        let bounding :CGRect = CGRect(x: CGFloat(0), y: CGFloat(-0.14 * fontSize), width: CGFloat(fontSize), height: CGFloat(fontSize))
        var contentInsets :UIEdgeInsets = UIEdgeInsetsMake(CGFloat(ascent - Float(bounding.size.height + bounding.origin.y)), 0, CGFloat(descent + Float(bounding.origin.y)), 0)
        
        //重新设置字形的边框
        let delegate = YYTextRunDelegate()
        delegate.ascent = CGFloat(ascent)
        delegate.descent = CGFloat(descent)
        delegate.width = bounding.size.width
        
        let attachment = YYTextAttachment()
        attachment.contentMode = UIViewContentMode.ScaleAspectFit
        attachment.contentInsets = contentInsets
        attachment.content = image
        
        
        if shrink
        {
            // 缩小~
            let scale :CGFloat = 1.0 / 10.0
            contentInsets.top += CGFloat(fontSize) * scale
            contentInsets.bottom += CGFloat(fontSize) * scale
            contentInsets.left += CGFloat(fontSize) * scale
            contentInsets.right += CGFloat(fontSize) * scale
            
            
            contentInsets = UIEdgeInsetPixelFloor(contentInsets);
            attachment.contentInsets = contentInsets
            
        }
        
   
        
        let atr = NSMutableAttributedString(string: YYTextAttachmentToken)
        atr.setTextAttachment(attachment, range: NSMakeRange(0, atr.length))
        let ctDelegate = delegate.CTRunDelegate()
        atr.setRunDelegate(ctDelegate, range: NSMakeRange(0, atr.length))
        
        return atr
    }
    
    func _attachmentWithFontSize(fontSize :Float ,imageURL :String ,shrink :Bool) -> NSAttributedString?
    {
        /*
        微博 URL 嵌入的图片，比临近的字体要小一圈。。
        这里模拟一下 Heiti SC 字体，然后把图片缩小一下。
        */
        let ascent :Float = fontSize * 0.86
        let descent :Float = fontSize * 0.14
        let bounding :CGRect = CGRect(x: CGFloat(0), y: CGFloat(-0.14 * fontSize), width: CGFloat(fontSize), height: CGFloat(fontSize))
        var contentInsets :UIEdgeInsets = UIEdgeInsetsMake(CGFloat(ascent - Float(bounding.size.height + bounding.origin.y)), 0, CGFloat(descent + Float(bounding.origin.y)), 0)
        var size :CGSize = CGSizeMake(CGFloat(fontSize), CGFloat(fontSize))
        
        if shrink
        {
            // 缩小~
            let scale :CGFloat = 1.0 / 10.0
            contentInsets.top += CGFloat(fontSize) * scale
            contentInsets.bottom += CGFloat(fontSize) * scale
            contentInsets.left += CGFloat(fontSize) * scale
            contentInsets.right += CGFloat(fontSize) * scale
            

            contentInsets = UIEdgeInsetPixelFloor(contentInsets);
            size = CGSizeMake(CGFloat(fontSize) - CGFloat(fontSize) * scale * 2, CGFloat(fontSize) - CGFloat(fontSize) * scale * 2);
            size = CGSizePixelRound(size);
            
        }
        
        //重新设置字形的边框
        let delegate = YYTextRunDelegate()
        delegate.ascent = CGFloat(ascent)
        delegate.descent = CGFloat(descent)
        delegate.width = bounding.size.width
        
        let attachment = WBTextImageViewAttachment()
        attachment.contentMode = UIViewContentMode.ScaleAspectFit
        attachment.contentInsets = contentInsets
        attachment.size = size
        attachment.imageURL = WBStatusHelper.defaultURLForImageURL(imageURL)
        
        let atr = NSMutableAttributedString(string: YYTextAttachmentToken)
        atr.setTextAttachment(attachment, range: NSMakeRange(0, atr.length))
        let ctDelegate = delegate.CTRunDelegate()
        atr.setRunDelegate(ctDelegate, range: NSMakeRange(0, atr.length))
        
        return atr
    }
    /*
    
    用户信息  status.user
    文本      status.text
    图片      status.pics
    转发      status.retweetedStatus
    文本       status.retweetedStatus.user + status.retweetedStatus.text
    图片       status.retweetedStatus.pics
    卡片       status.retweetedStatus.pageInfo
    卡片      status.pageInfo
    Tip       status.tagStruct
    
    1.根据 urlStruct 中每个 URL.shortURL 来匹配文本，将其替换为图标+友好描述
    2.根据 topicStruct 中每个 Topic.topicTitle 来匹配文本，标记为话题
    2.匹配 @用户名
    4.匹配 [表情]
    
    一条里，图片|转发|卡片不能同时存在，优先级是 转发->图片->卡片
    如果不是转发，则显示Tip
    
    
    文本
    文本 图片/卡片
    文本 Tip
    文本 图片/卡片 Tip
    
    文本 转发[文本]  /Tip
    文本 转发[文本 图片] /Tip
    文本 转发[文本 卡片] /Tip
    
    话题                                 #爸爸去哪儿#
    电影 timeline_card_small_movie       #冰雪奇缘[电影]#
    图书 timeline_card_small_book        #纸牌屋[图书]#
    音乐 timeline_card_small_music       #Let It Go[音乐]#
    地点 timeline_card_small_location    #理想国际大厦[地点]#
    股票 timeline_icon_stock             #腾讯控股 kh00700[股票]#
    */

}
