//
//  WBModel.swift
//  weibo-swift
//
//  Created by 马超 on 15/12/28.
//  Copyright © 2015年 马超. All rights reserved.
//

import UIKit

/// 认证方式
enum WBUserVerifyType{
    
    case WBUserVerifyTypeNone //没有认证
    case WBUserVerifyTypeStandard  //个人认证，黄V
    case WBUserVerifyTypeOrganization //官方认证，蓝V
    case WBUserVerifyTypeClub //达人认证，红星
    
}

/// 图片标记
enum WBPictureBadgeType{
    
    case WBPictureBadgeTypeNone //正常图片
    case WBPictureBadgeTypeLong //长图
    case WBPictureBadgeTypeGIF //GIF
    
}

//表情类型
enum WBEmoticonType {
    case WBEmoticonTypeImage ///< 图片表情
    case WBEmoticonTypeEmoji ///< Emoji表情
}



/**
 图片
 */
class WBPicture :NSObject,YYModel{

    var picID :String?
    var objectID :String?
    var photoTag :Int?
    var keepSize :String? ///< YES:固定为方形 NO:原始宽高比
    var thumbnail :WBPictureMetadata?  ///< w:180
    var bmiddle :WBPictureMetadata?  ///< w:360 (列表中的缩略图)
    var middlePlus :WBPictureMetadata?   ///< w:480
    var large :WBPictureMetadata?       ///< w:720 (放大查看)
    var largest :WBPictureMetadata?  ///<       (查看原图)
    var original :WBPictureMetadata?    ///<
    var badgeType :WBPictureBadgeType?

    
    class func modelCustomPropertyMapper() -> [NSObject : AnyObject]! {
        return ["picID" : "pic_id",
            "keepSize" : "keep_size",
            "photoTag" : "photo_tag",
            "objectID" : "object_id",
            "middlePlus" : "middleplus"]
    }
    
     func modelCustomTransformFromDictionary(dic: [NSObject : AnyObject]!) -> Bool {

        if let _ = bmiddle
        {
            let meta :WBPictureMetadata = bmiddle!
            badgeType = meta.badgeType
            
        }else
        {
            if let _ = largest
            {
                let meta :WBPictureMetadata = largest!
                badgeType = meta.badgeType!
            }else
            {
                let meta :WBPictureMetadata = original!
                badgeType = meta.badgeType!
            }
        }
        
        return true
    }
}


/**
 链接
 */
class WBURL :NSObject,YYModel {
    
    var result :Bool?
    var shortURL :String?  ///< 短域名 (原文)
    var oriURL :String?  ///< 原始链接
    var urlTitle:String?  ///< 显示文本，例如"网页链接"，可能需要裁剪(24)
    var url_type_pic :NSString? ///< 链接类型的图片URL
    var urlType :Int32?  ///< 0:一般链接 36地点 39视频/图片
    var log :String?
    var actionLog :NSDictionary?
    var pageID :String?  ///< 对应着 WBPageInfo
    var storageType :String?  //如果是图片，则会有下面这些，可以直接点开看
    var picIds :NSArray?  /// Array<NSString>
    var picInfos :NSDictionary?  /// Dic<NSString,WBPicItem>
    var pics :NSArray?   ///< Array<WBPicItem>
    
    class func modelCustomPropertyMapper() -> [NSObject : AnyObject]! {
        
        return ["oriURL" : "ori_url",
            "urlTitle" : "url_title",
            "urlType" : "url_type",
            "shortURL" : "short_url",
            "actionLog" : "actionlog",
            "pageID" : "page_id",
            "storageType" : "storage_type",
            "picIds" : "pic_ids",
            "picInfos" : "pic_infos"];
        
    }
    
    class func modelContainerPropertyGenericClass() -> [NSObject : AnyObject]! {
        
        return ["picIds" : NSString.self,
            "picInfos" : WBPicture.self];
    }
    
     func modelCustomTransformFromDictionary(dic: [NSObject : AnyObject]!) -> Bool {
        
         // 自动 model-mapper 不能完成的，这里可以进行额外处理
        pics = nil
        if picIds?.count > 0
        {
            let pic = NSMutableArray()
            for picid  in picIds!
            {
                let pi = picid as! NSString
                let p :WBPicture? = picInfos![pi] as? WBPicture
                if let _ = p
                {
                    pic.addObject(p!)
                }
            }
            pics = pic
        }
        return true
    }
}


/**
 话题
 */
class WBTopic :NSObject,YYModel {
    
    var topicTitle :String?  ///< 话题标题
    var topicURL :String?   ///< 话题链接 sinaweibo://
    
    class func modelCustomPropertyMapper() -> [NSObject : AnyObject]! {
        
        return ["topicTitle" : "topic_title",
            "topicURL" : "topic_url"];
    }
}

/**
 标签
 */
class WBTag :NSObject {
    
    var tagName :String?  ///< 标签名字，例如"上海·上海文庙"
    var tagScheme :String?   ///< 链接 sinaweibo://...
    var tagType :Int32?  ///< 1 地点 2其他
    var tagHidden :Int32?
    var urlTypePic :NSURL?  ///< 需要加 _default
    
    class func modelCustomPropertyMapper() -> [NSObject : AnyObject]! {
        
        return ["tagHidden" : "tag_hidden",
            "tagName" : "tag_name",
            "tagScheme" : "tag_scheme",
            "tagType" : "tag_type",
            "urlTypePic" : "url_type_pic"];
    }
}

/**
 按钮
 */
class WBButtonLink :NSObject {
    
    var pic :NSURL?  ///< 按钮图片URL (需要加_default)
    var name :String?   ///< 按钮文本，例如"点评"
    var type :String?
    var params :NSDictionary?
}


/**
 卡片 (样式有多种，最常见的是下方这样)
 -----------------------------
 title
 pic     title        button
 tips
 -----------------------------
 */
class WBPageInfo :NSObject,YYModel {
    
    var pageTitle :String?  ///< 页面标题，例如"上海·上海文庙"
    var pageID :String?
    var pageDesc :String?   ///< 页面描述，例如"上海市黄浦区文庙路215号"
    var content1 :String?
    var content2 :String?
    var content3 :String?
    var content4 :String?
    var tips :String?   ///< 提示，例如"4222条微博"
    var objectType :String?  ///< 类型，例如"place" "video"
    var objectID :String?
    var scheme :String?   ///< 真实链接，例如 http://v.qq.com/xxx
    var buttons :NSArray?   ///< Array<WBButtonLink>
    var isAsyn :Int32?
    var type :Int32?
    var pageURL :String?  ///< 链接 sinaweibo://...
    var pagePic :NSURL?   ///< 图片URL，不需要加(_default) 通常是左侧的方形图片
    var typeIcon :NSURL?  ///< Badge 图片URL，不需要加(_default) 通常放在最左上角角落里
    var actStatus :Int32?
    var actionlog :NSDictionary?
    var mediaInfo :NSDictionary?
    
    class func modelCustomPropertyMapper() -> [NSObject : AnyObject]! {
        
        return ["pageTitle" : "page_title",
            "pageID" : "page_id",
            "pageDesc" : "page_desc",
            "objectType" : "object_type",
            "objectID" : "object_id",
            "isAsyn" : "is_asyn",
            "pageURL" : "page_url",
            "pagePic" : "page_pic",
            "actStatus" : "act_status",
            "mediaInfo" : "media_info",
            "typeIcon" : "type_icon"];
    }
    
    class func modelContainerPropertyGenericClass() -> [NSObject : AnyObject]! {
        
         return ["buttons" : WBButtonLink.self];
        
    }
}


/**
 微博标题
 */
class  WBStatusTitle  :NSObject ,YYModel{
    var baseColor :Int32?
    var text :String?   ///< 文本，例如"仅自己可见"
    var iconURL :String?   ///< 图标URL，需要加Default
    class func modelCustomPropertyMapper() -> [NSObject : AnyObject]! {
        
        return ["baseColor" : "base_color",
            "iconURL" : "icon_url"];
    }
}
/**
 用户
 */
class WBUser :NSObject ,YYModel {
    var userID :String?   ///< id (int)
    var idString :String?  ///< id (string)
    var gender :Int32?   /// 0:none 1:男 2:女
    var genderString :String?  /// "m":男 "f":女 "n"未知
    var desc :String?   ///< 个人简介
    var domain :String?   ///< 个性域名
    
    var name :String?  ///< 昵称
    var screenName :String?  ///< 友好昵称
    var remark :String?   ///< 备注
    
    var followers_count :Int32?  ///< 粉丝数
    var friendsCount :Int32? ///< 关注数
    var biFollowersCount :Int32?  ///< 好友数 (双向关注)
    var favouritesCount :Int32?    ///< 收藏数
    var statusesCount :Int32?  ///< 微博数
    var topicsCount :Int32?  ///< 话题数
    var blockedCount :Int32?   ///< 屏蔽数
    var pagefriendsCount :Int32?
    var followMe :Bool?
    var following :Bool?
    
    var province :String?  ///< 省
    var city :String?    ///< 市
    var url :String?   ///< 博客地址
    
    var profileImageURL :NSURL?   ///< 头像 50x50 (FeedList)
    var avatarLarge :NSURL?   ///< 头像 180*180
    var avatarHD :NSURL?   ///< 头像 原图
    var coverImage :NSURL?  ///< 封面图 920x300
    var coverImagePhone :NSURL?
    
    var profileURL :String?
    var type :Int32?
    var ptype :Int32?
    var mbtype :Int32?
    var urank :Int32?  ///< 微博等级 (LV)
    var uclass :Int32?
    var ulevel :Int32?
    var mbrank :String?  ///< 会员等级 (橙名 VIP)
    var star :Int32?
    var level :Int32?
    var createdAt :NSDate?  ///< 注册时间
    var allowAllActMsg :Bool?
    var allowAllComment :Bool?
    var geoEnabled :Bool?
    var onlineStatus :Int32?
    var location :String?   ///< 所在地
    var icons :NSArray?
    var weihao :String?
    var badgeTop :String?
    var blockWord :Int32?
    var blockApp :Int32?
    var hasAbilityTag :Int32?
    var creditScore :Int32?  ///< 信用积分
    var badge :NSDictionary?  ///< 勋章
    var lang :String?
    var userAbility :Int32?
    var extend :NSDictionary?
    var verified :String!  ///< 微博认证 (大V)
    var verifiedType :String?
    var verifiedLevel :String?
    var verifiedState :Int32?
    var verifiedContactEmail :String?
    var verifiedContactMobile :String?
    var verifiedTrade :String?
    var verifiedContactName :String?
    var verifiedSource :String?
    var verifiedSourceURL :String?
    var verifiedReason :String?  ///< 微博认证描述
    var verifiedReasonURL :String?
    var verifiedReasonModified :String?
    var userVerifyType :WBUserVerifyType?
    
    class func modelCustomPropertyMapper() -> [NSObject : AnyObject]! {
        
        return ["userID" : "id",
            "idString" : "idstr",
            "genderString" : "gender",
            "biFollowersCount" : "bi_followers_count",
            "profileImageURL" : "profile_image_url",
            "uclass" : "class",
            "verifiedContactEmail" : "verified_contact_email",
            "statusesCount" : "statuses_count",
            "geoEnabled" : "geo_enabled",
            "topicsCount" : "topics_count",
            "blockedCount" : "blocked_count",
            "followMe" : "follow_me",
            "coverImagePhone" : "cover_image_phone",
            "desc" : "description",
            "followersCount" : "followers_count",
            "verifiedContactMobile" : "verified_contact_mobile",
            "avatarLarge" : "avatar_large",
            "verifiedTrade" : "verified_trade",
            "profileURL" : "profile_url",
            "coverImage" : "cover_image",
            "onlineStatus"  : "online_status",
            "badgeTop" : "badge_top",
            "verifiedContactName" : "verified_contact_name",
            "screenName" : "screen_name",
            "verifiedSourceURL" : "verified_source_url",
            "pagefriendsCount" : "pagefriends_count",
            "verifiedReason" : "verified_reason",
            "friendsCount" : "friends_count",
            "blockApp" : "block_app",
            "hasAbilityTag" : "has_ability_tag",
            "avatarHD" : "avatar_hd",
            "creditScore" : "credit_score",
            "createdAt" : "created_at",
            "blockWord" : "block_word",
            "allowAllActMsg" : "allow_all_act_msg",
            "verifiedState" : "verified_state",
            "verifiedReasonModified" : "verified_reason_modified",
            "allowAllComment" : "allow_all_comment",
            "verifiedLevel" : "verified_level",
            "verifiedReasonURL" : "verified_reason_url",
            "favouritesCount" : "favourites_count",
            "verifiedType" : "verified_type",
            "verifiedSource" : "verified_source",
            "userAbility" : "user_ability"]
    
    }
    
     func modelCustomTransformFromDictionary(dic: [NSObject : AnyObject]!) -> Bool {
        
        gender = 0
        if genderString == "m"
        {
            gender = 1
        }else if genderString == "f"
        {
            gender = 2
        }
        
        if verified == "1"
        {
            userVerifyType = WBUserVerifyType.WBUserVerifyTypeStandard
        }else if verifiedType == "220"
        {
            userVerifyType = WBUserVerifyType.WBUserVerifyTypeClub
        }else if verifiedType == "-1" && verifiedLevel == "3"
        {
            userVerifyType = WBUserVerifyType.WBUserVerifyTypeOrganization
        }else
        {
            userVerifyType = WBUserVerifyType.WBUserVerifyTypeNone
        }
        
        return true
    }
}
/**
 微博
 */
class WBStatus :NSObject {
    
    var statusID :UInt64?  ///< id (number)
    var idstr :String?    ///< id (string)
    var mid :String?
    var rid :String?
    var createdAt :NSDate?   ///< 发布时间
    
    var user :WBUser?
    var userType :String?
    
    var title :WBStatusTitle?  ///< 标题栏 (通常为nil)
    var pic_bg :NSString?  ///< 微博VIP背景图，需要替换 "os7"
    var text :String?  ///< 正文
    var thumbnailPic :NSURL?  ///< 缩略图
    var bmiddlePic :NSURL?   ///< 中图
    var originalPic :NSURL?  ///< 大图
    
    var retweetedStatus :WBStatus?  ///转发微博
    var picIds :NSArray? /// Array<NSString>
    var picInfos :NSDictionary?  /// Dic<NSString,WBPicture>
    var pics :NSArray?   ///< Array<WBPicItem>
    var urlStruct :NSArray?  ///< Array<WBURL>
    var topicStruct :NSArray?  ///< Array<WBTopic>
    var tagStruct :NSArray?  ///< Array<WBTag>
    var pageInfo :WBPageInfo?
    
    var favorited :Bool?  ///< 是否收藏
    var truncated :Bool?   ///< 是否截断
    var repostsCount :String?  ///< 转发数
    var commentsCount :String?  ///< 评论数
    var attitudesCount :String?  ///< 赞数
    var attitudesStatus :String?  ///< 是否已赞 0:没有
    var recomState :Int32?
    
    var inReplyToScreenName :String?
    var inReplyToStatusId :String?
    var inReplyToUserId :String?
    
    var source :String?  ///< 来自 XXX
    var sourceType :Int32?
    var sourceAllowClick :String?  ///< 来源是否允许点击
    
    var geo :NSDictionary?
    var annotations :NSArray?  ///< 地理位置
    var bizFeature :Int32?
    var mlevel :Int32?
    var mblogid :String?
    var mblogTypeName :String?
    var scheme :String?
    var visible :NSDictionary?
    var darwinTags :NSArray?
    
    class func modelCustomPropertyMapper() -> [NSObject : AnyObject]! {
        
        return ["statusID" : "id",
            "createdAt" : "created_at",
            "attitudesStatus" : "attitudes_status",
            "inReplyToScreenName" : "in_reply_to_screen_name",
            "sourceType" : "source_type",
            "commentsCount" : "comments_count",
            "thumbnailPic" : "thumbnail_pic",
            "recomState" : "recom_state",
            "sourceAllowClick" : "source_allowclick",
            "bizFeature" : "biz_feature",
            "retweetedStatus" : "retweeted_status",
            "mblogTypeName" : "mblogtypename",
            "urlStruct" : "url_struct",
            "topicStruct" : "topic_struct",
            "tagStruct" : "tag_struct",
            "pageInfo" : "page_info",
            "bmiddlePic" : "bmiddle_pic",
            "inReplyToStatusId" : "in_reply_to_status_id",
            "picIds" : "pic_ids",
            "repostsCount" : "reposts_count",
            "attitudesCount" : "attitudes_count",
            "darwinTags" : "darwin_tags",
            "userType" : "userType",
            "picInfos" : "pic_infos",
            "inReplyToUserId" : "in_reply_to_user_id",
            "originalPic" : "original_pic"]
        
    }
   
    class func modelContainerPropertyGenericClass() -> [NSObject : AnyObject]! {
        
        return ["picIds" : NSString.self ,
            "picInfos" : WBPicture.self ,
            "urlStruct" : WBURL.self ,
            "topicStruct" : WBTopic.self ,
            "tagStruct" : WBTag.self]
        
    }
    
     func modelCustomTransformFromDictionary(dic: [NSObject : AnyObject]!) -> Bool {
        
        // 自动 model-mapper 不能完成的，这里可以进行额外处理
        pics = nil
        if picIds?.count > 0
        {
            let pic = NSMutableArray()
            for picid  in picIds!
            {
                let pi = picid as! NSString
                let p :WBPicture? = picInfos![pi] as? WBPicture
                if let _ = p
                {
                    pic.addObject(p!)
                }
            }
            pics = pic
        }
        
        if let _ = retweetedStatus
        {
            if retweetedStatus!.urlStruct?.count == 0
            {
                retweetedStatus?.urlStruct = urlStruct
            }
            
            if retweetedStatus?.pageInfo != nil
            {
                retweetedStatus?.pageInfo = pageInfo
            }
        }
        return true
    }
}


/**
 一次API请求的数据
 */
class WBTimelineItem :NSObject ,YYModel{
    
    var ad :NSArray?
    var advertises :NSArray?
    var gsid :String?
    var interval :Int32?
    var uveBlank :Int32?
    var hasUnread :Int32?
    var totalNumber :Int32?
    var sinceID :String?
    var maxID :String?
    var previousCursor :String?
    var nextCursor :String?
    var statuses :NSArray?
    
    class func modelCustomPropertyMapper() -> [NSObject : AnyObject]! {
        
        return ["hasVisible" : "hasvisible",
            "previousCursor" : "previous_cursor",
            "uveBlank" : "uve_blank",
            "hasUnread" : "has_unread",
            "totalNumber" : "total_number",
            "maxID" : "max_id",
            "sinceID" : "since_id",
            "nextCursor" : "next_cursor"]
    }
    
    class func modelContainerPropertyGenericClass() -> [NSObject : AnyObject]! {
        
        return ["statuses" : WBStatus.self];
    }
}


class WBEmoticonGroup :NSObject,YYModel {
    var groupID :String?  ///< 例如 com.sina.default
    var version :UInt?
    var nameCN :String? ///< 例如 浪小花
    var nameEN :String?
    var nameTW :String?
    var displayOnly :UInt?
    var groupType :UInt?
    var emoticons :NSArray? ///< Array<WBEmoticon>
    
    class func modelCustomPropertyMapper() -> [NSObject : AnyObject]! {
        
        return ["groupID" : "id",
            "nameCN" : "group_name_cn",
            "nameEN" : "group_name_en",
            "nameTW" : "group_name_tw",
            "displayOnly" : "display_only",
            "groupType" : "group_type"];
    }
    
    class func modelContainerPropertyGenericClass() -> [NSObject : AnyObject]! {
        
        return ["emoticons" : WBEmoticon.self];
    }
    
    func modelCustomTransformFromDictionary(dic: [NSObject : AnyObject]!) -> Bool {
        
        self.emoticons?.enumerateObjectsUsingBlock({ (emotion, idx, stop :UnsafeMutablePointer<ObjCBool>) -> Void in
            let emo = emotion as! WBEmoticon
            emo.group = self
        })
        
        return true
    }
}

class WBEmoticon :NSObject,YYModel {
    var chs :String?  ///< 例如 [吃惊]
    var cht :String?  ///< 例如 [吃驚]
    var gif :String?  ///< 例如 d_chijing.gif
    var png :String? ///< 例如 d_chijing.png
    var code :String?   ///< 例如 0x1f60d
    var type :String?
    var emo_type :WBEmoticonType?
    var group :WBEmoticonGroup?
    
    class func modelPropertyBlacklist() -> [AnyObject]! {
        return ["group"];
    }
    func modelCustomTransformFromDictionary(dic: [NSObject : AnyObject]!) -> Bool {
        
        if self.type == "1" {
            self.emo_type = WBEmoticonType.WBEmoticonTypeEmoji
        }else{
            self.emo_type = WBEmoticonType.WBEmoticonTypeImage
        }
        
        return true
    }
}
class WBModel: NSObject {

}



