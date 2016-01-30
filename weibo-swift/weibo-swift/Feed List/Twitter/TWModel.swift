//
//  TWModel.swift
//  weibo-swift
//
//  Created by 马超 on 16/1/28.
//  Copyright © 2016年 马超. All rights reserved.
//

import UIKit

class TWURL: NSObject,YYModel {
    
    var url: String?   // e.g. "http://t.co/YuvsPou0rj"
    var displayURL: String?  // e.g. "apple.com/tv/compare/"
    var expandedURL: String?  // e.g. "http://www.apple.com/tv/compare/"
    var indices: NSArray?  // Array<NSNumber> from, to
    var range: NSRange?  // range from indices
    var ranges: NSArray?  // Array<NSValue(NSRange)> nil if range is less than or equal to one.
    
  
    class func modelCustomPropertyMapper() -> [NSObject : AnyObject]! {
        
        return [ "screenName" : "screen_name",
            "idStr" : "id_str",
            "displayURL" : "display_url",
            "expandedURL" : "expanded_url"]
    }
    
    class func modelContainerPropertyGenericClass() -> [NSObject : AnyObject]! {
        
        return ["indices" : NSNumber.self ]
    }
    
    func modelCustomTransformFromDictionary(dic: [NSObject : AnyObject]!) -> Bool {
        
        if indices == nil { return true }
        
        let rangeCount = Int(indices!.count) / 2
       
        let rangesArray = NSMutableArray()
        
        for var i = 0 ; i < rangeCount ; i++ {
            
            let from: Int = (indices![i * 2] as! NSNumber).integerValue
            let to: Int = (indices![i * 2 + 1] as! NSNumber).integerValue
            
            let range: NSRange = NSMakeRange(from, to >= from ? (to - from) : 0)
            
            if i == 0 { self.range = range}
            if rangeCount > 1 { rangesArray.addObject(NSValue(range: range))}
        }
        self.ranges = rangesArray
     
        return true
    }
}

class TWUser: NSObject ,YYModel{
    
    var uid: String?
    var uidStr: String?
    var name: String?  // e.g. "Nick Lockwood"
    var screenName: String?  // e.g. "nicklockwood"
    var url: String?
    var desc: String?
    var location: String?
    var createdAt: NSDate?
    

    var listedCount: String?
    var statusesCount: String?
    var favouritesCount: String?
    var friendsCount: String?
    
    // http://pbs.twimg.com/profile_images/558109954561679360/j1f9DiJi_normal.jpeg original
    // http://pbs.twimg.com/profile_images/558109954561679360/j1f9DiJi_reasonably_small.jpeg replaced
    
    var profileImageURL: NSURL?
    var profileImageURLReasonablySmall: NSURL?
    var profileImageURLHttps: NSURL?
    var profileBackgroundImageURL: NSURL?
    var profileBackgroundImageURLHttps: NSURL?
    
    
    var profileBackgroundColor: String?
    var profileTextColor: String?
    var profileSidebarFillColor: String?
    var profileSidebarBorderColor: String?
    var profileLinkColor: String?
    
    var entities: NSDictionary?
    var counts: NSDictionary?
    
    var verified: String?
    var following: String?
    var followRequestSent: String?
    var defaultProfile: String?
    var defaultProfileImage: String?
    var profileUseBackgroundImage: String?
    var isProtected: String?
    var isTranslator: String?
    var notifications: String?
    var geoEnabled: String?
    var contributorsEnabled: String?
    var isTranslationEnabled: String?
    var hasExtendedProfile: String?

    var lang: String?
    var timeZone: String?
    var utcOffset: String?
    

    class func modelCustomPropertyMapper() -> [NSObject : AnyObject]! {
        
        return [
            "isProtected" : "protected",
            "isTranslator" : "is_translator",
            "profileImageURL" : "profile_image_url",
            "createdAt" : "created_at",
            "uid" : "id",
            "defaultProfileImage" : "default_profile_image",
            "listedCount" : "listed_count",
            "profileBackgroundColor" : "profile_background_color",
            "followRequestSent" : "follow_request_sent",
            "desc" : "description",
            "geoEnabled" : "geo_enabled",
            "profileTextColor" : "profile_text_color",
            "statusesCount" : "statuses_count",
            "profileBackgroundTile" : "profile_background_tile",
            "profileUseBackgroundImage" : "profile_use_background_image",
            "uidStr" : "id_str",
            "profileImageURLHttps" : "profile_image_url_https",
            "profileSidebarFillColor" : "profile_sidebar_fill_color",
            "profileSidebarBorderColor" : "profile_sidebar_border_color",
            "contributorsEnabled" : "contributors_enabled",
            "defaultProfile" : "default_profile",
            "screenName" : "screen_name",
            "timeZone" : "time_zone",
            "profileBackgroundImageURL" : "profile_background_image_url",
            "profileBackgroundImageURLHttps" : "profile_background_image_url_https",
            "profileLinkColor" : "profile_link_color",
            "favouritesCount" : "favourites_count",
            "isTranslationEnabled" : "is_translation_enabled",
            "utcOffset" : "utc_offset",
            "friendsCount" : "friends_count",
            "hasExtendedProfile" : "has_extended_profile"
        ]
    }
    
    func modelCustomTransformFromDictionary(dic: [NSObject : AnyObject]!) -> Bool {
        
        if self.profileImageURL != nil {
         
            let url: NSMutableString = NSMutableString(string: self.profileImageURL!.absoluteString)
            let ext = url.pathExtension
            if ext.startIndex.distanceTo(ext.endIndex) > 0 && url.length > ext.startIndex.distanceTo(ext.endIndex) + 2 + 7 {
                let range = NSMakeRange(url.length - ext.startIndex.distanceTo(ext.endIndex) - 1 - 7,7)
                if url.substringWithRange(range) == "_normal" {
                    url.replaceCharactersInRange(range, withString: "_reasonably_small")
                    self.profileImageURLReasonablySmall = NSURL(string: url as String)
                }
            }
        }
        
        return true
    }
}

class TWUserMention: NSObject ,YYModel {
    
    var uid: String?
    var uidStr: String?
    var name: String?  // e.g. "Nick Lockwood"
    var screenName: String? // e.g. "nicklockwood"
    var indices: NSArray?  // Array<NSNumber> from, to
    
    var range: NSRange?  // range from indices
    var ranges: NSArray? // Array<NSValue(NSRange)> nil if range is less than or equal to one.
    var user: TWUser?  // reference
    
    
    class func modelCustomPropertyMapper() -> [NSObject : AnyObject]! {
        
        return [
            "screenName" : "screen_name",
            "uidStr" : "id_str",
            "uid" : "id",
        ]
    }
    
    class func modelContainerPropertyGenericClass() -> [NSObject : AnyObject]! {
        
        return ["indices" : NSNumber.self ]
    }
    
    func modelCustomTransformFromDictionary(dic: [NSObject : AnyObject]!) -> Bool {
        
        if indices == nil { return true }
        
        let rangeCount = Int(indices!.count) / 2
        
        let rangesArray = NSMutableArray()
        
        for var i = 0 ; i < rangeCount ; i++ {
            
            let from: Int = (indices![i * 2] as! NSNumber).integerValue
            let to: Int = (indices![i * 2 + 1] as! NSNumber).integerValue
            
            let range: NSRange = NSMakeRange(from, to >= from ? (to - from) : 0)
            
            if i == 0 { self.range = range}
            if rangeCount > 1 { rangesArray.addObject(NSValue(range: range))}
        }
        self.ranges = rangesArray
        
        return true
    }
}

class TWHashTag: NSObject,YYModel {
    
    var text: String? // e.g. "nicklockwood"
    var indices: NSArray?  // Array<NSNumber> from, to
    
    var range: NSRange?  // range from indices
    var ranges: NSArray?  // Array<NSValue(NSRange)> nil if range is less than or equal to one.
    
    class func modelContainerPropertyGenericClass() -> [NSObject : AnyObject]! {
        
        return ["indices" : NSNumber.self ]
    }
    
    func modelCustomTransformFromDictionary(dic: [NSObject : AnyObject]!) -> Bool {
        
        if indices == nil { return true }
        
        let rangeCount = Int(indices!.count) / 2
        
        let rangesArray = NSMutableArray()
        
        for var i = 0 ; i < rangeCount ; i++ {
            
            let from: Int = (indices![i * 2] as! NSNumber).integerValue
            let to: Int = (indices![i * 2 + 1] as! NSNumber).integerValue
            
            let range: NSRange = NSMakeRange(from, to >= from ? (to - from) : 0)
            
            if i == 0 { self.range = range}
            if rangeCount > 1 { rangesArray.addObject(NSValue(range: range))}
        }
        self.ranges = rangesArray
        
        return true
    }
}

class TWMediaMeta: NSObject,YYModel {
    
    var width: String?
    var height: String?
    var size: CGSize?
    var resize: String? // fit, crop
    var isCrop: Bool?
    var faces: NSArray?  // Array<NSValue(CGRect)>
    var url: NSURL?
    
    
    class func modelContainerPropertyGenericClass() -> [NSObject : AnyObject]! {
        
        return ["faces" : NSValue.self ]
    }
    
    func modelCustomTransformFromDictionary(dic: [NSObject : AnyObject]!) -> Bool {
        
        if width != nil && height != nil {
            
         self.size = CGSizeMake(CGFloat(Float(width!)!), CGFloat(Float(height!)!))
            
        }
      
        self.isCrop = self.resize == "crop"
        
        let faceDics = dic["faces"]
        
        if faceDics != nil && faceDics!.isKindOfClass(NSArray.self) && faceDics!.count > 0 {
            
            let faces = NSMutableArray()
            for facedic in faceDics! as! [AnyObject] {
                if facedic.isKindOfClass(NSDictionary.self) {
                    
                    let x: Int = (facedic as! NSDictionary).integerValueForKey("x", `default`: 0)
                    let y: Int = (facedic as! NSDictionary).integerValueForKey("y", `default`: 0)
                    let w: Int = (facedic as! NSDictionary).integerValueForKey("w", `default`: 0)
                    let h: Int = (facedic as! NSDictionary).integerValueForKey("h", `default`: 0)
                    
                    faces.addObject(NSValue(CGRect: CGRectMake(CGFloat(x), CGFloat(y), CGFloat(w), CGFloat(h))))
                }
            }
            
            self.faces = faces
        }
        
        return true
    }
}

class TWMedia: NSObject,YYModel {
    
    var mid: String?
    var midStr: String?
    var type: String?  // photo/..
    var url: String?  // e.g. "http://t.co/X4kGxbKcBu"
    var displayURL: String?  // e.g. "pic.twitter.com/X4kGxbKcBu"
    var expandedURL: String?   // e.g. "http://twitter.com/edelwax/status/652117831883034624/photo/1"
    var mediaURL: String?  // e.g. "http://pbs.twimg.com/media/CQzJtkbXAAAO2v3.png"

    
    var mediaURLHttps: String? // e.g. "https://pbs.twimg.com/media/CQzJtkbXAAAO2v3.png"
    var indices: NSArray?
    var range: NSRange?
    var ranges: NSArray?

    var mediaThumb: TWMediaMeta?
    var mediaSmall: TWMediaMeta?
    var mediaMedium: TWMediaMeta?
    var mediaLarge: TWMediaMeta?
    var mediaOrig: TWMediaMeta?
    

    class func modelCustomPropertyMapper() -> [NSObject : AnyObject]! {
        
        return [
            "idStr" : "id_str",
            "mediaURLHttps" : "media_url_https",
            "mediaURL" : "media_url",
            "expandedURL" : "expanded_url",
            "displayURL" : "display_url",
            "mid" : "id",
            "midStr" : "id_str",
            
            "mediaThumb" : "sizes.thumb",
            "mediaSmall" : "sizes.small",
            "mediaMedium" : "sizes.medium",
            "mediaLarge" : "sizes.large",
            "mediaOrig" : "sizes.orig"
        ]
    }
    
    func modelCustomTransformFromDictionary(dic: [NSObject : AnyObject]!) -> Bool {
        
        if indices == nil { return true }
        
        let rangeCount = Int(indices!.count) / 2
        
        let rangesArray = NSMutableArray()
        
        for var i = 0 ; i < rangeCount ; i++ {
            
            let from: Int = (indices![i * 2] as! NSNumber).integerValue
            let to: Int = (indices![i * 2 + 1] as! NSNumber).integerValue
            
            let range: NSRange = NSMakeRange(from, to >= from ? (to - from) : 0)
            
            if i == 0 { self.range = range}
            if rangeCount > 1 { rangesArray.addObject(NSValue(range: range))}
        }
        self.ranges = rangesArray
        
        let featureDics: NSDictionary? = dic["features"] as? NSDictionary
        if featureDics != nil && featureDics!.isKindOfClass(NSDictionary.self){
            
            self.mediaThumb!.modelSetWithDictionary(featureDics!["thumb"] as? [NSObject : AnyObject!])
            self.mediaSmall!.modelSetWithDictionary(featureDics!["small"] as? [NSObject : AnyObject!])
            self.mediaMedium!.modelSetWithDictionary(featureDics!["medium"] as? [NSObject : AnyObject!])
            self.mediaLarge!.modelSetWithDictionary(featureDics!["large"] as? [NSObject : AnyObject!])

            
            var url = self.mediaURL?.stringByAppendingString(":thumb")
            self.mediaThumb!.url = url != nil ? NSURL(string: url!) : nil
            
            url = self.mediaURL?.stringByAppendingString(":small")
            self.mediaSmall!.url = url != nil ? NSURL(string: url!) : nil
            
            url = self.mediaURL?.stringByAppendingString(":medium")
            self.mediaMedium!.url = url != nil ? NSURL(string: url!) : nil
            
            url = self.mediaURL?.stringByAppendingString(":large")
            self.mediaLarge!.url = url != nil ? NSURL(string: url!) : nil
            

        }
      

        return true
    }
}

class TWPlace: NSObject,YYModel {
    
    var pid: String?
    var name: String?
    var fullName: String?
    var placeType: String?
    var country: String?
    var countryCode: String?
    var containedWithin: NSArray?
    var boundingBox: NSDictionary?
    var attributes: NSDictionary?
    
    class func modelCustomPropertyMapper() -> [NSObject : AnyObject]! {
        return [
            "fullName" : "full_name",
            "placeType" : "place_type",
            "countryCode" : "country_code",
            "pid" : "id",
            "boundingBox" : "bounding_box",
            "containedWithin" : "contained_within"
        ]
    }

}

class TWCard: NSObject,YYModel {
    
    var users: NSDictionary?  // <NSString(uid), T1User>
    var cardTypeURL: String?
    var name: String?
    var url: String?
    var bindingValues: NSDictionary?

    class func modelCustomPropertyMapper() -> [NSObject : AnyObject]! {
        
        return [ "cardTypeURL" : "card_type_url", "bindingValues" : "binding_values" ]
    }
    
    class func modelContainerPropertyGenericClass() -> [NSObject : AnyObject]! {
        
        return [ "users" : TWUser.self ]
    }
}

class TWTweet: NSObject,YYModel {
    
    var tid: String?
    var tidStr: String?
    
    var user: TWUser?
    var place: TWPlace?
    var card: TWCard?
    var retweetedStatus: TWTweet?
    var quotedStatus: TWTweet?

    var text: String?
    var source: String?
    
    var medias: NSArray?  // Array<T1Media>
    var extendedMedias: NSArray?  // Array<T1Media>
    var userMentions: NSArray?  // Array<T1UserMention>
    var urls: NSArray?   // Array<T1URL>
    var hashTags: NSArray?  // Array<T1HashTag>
    
    var createdAt: NSDate?
    var favorited: String?
    var retweeted: String?
    var isQuoteStatus: String?
    var favoriteCount: String?
    var retweetCount: String?
    var conversationID: String?
    var inReplyToUserId: String?
    
    var contributors: NSArray?
    var inReplyToStatusID: String?
    
    
    var inReplyToStatusIDStr: String?
    var inReplyToUserIDStr: String?
    var inReplyToScreenName: String?
    var lang: String?
    
    var geo: NSDictionary?
    var supplementalLanguage: String?
    var coordinates: NSArray?


    class func modelContainerPropertyGenericClass() -> [NSObject : AnyObject]! {
        
        return [
            "medias" : TWMedia.self,
            "extendedMedias" : TWMedia.self,
            "userMentions" : TWUserMention.self,
            "urls" : TWURL.self,
            "hashTags" : TWHashTag.self
        ]
    }
    
    class func modelCustomPropertyMapper() -> [NSObject : AnyObject]! {
        
        return [
            "isQuoteStatus" : "is_quote_status",
            "favoriteCount" : "favorite_count",
            "conversationID" : "conversation_id",
            "inReplyToScreenName" : "in_reply_to_screen_name",
            "retweetCount" : "retweet_count",
            "tid" : "id",
            "inReplyToUserId" : "in_reply_to_user_id",
            "supplementalLanguage" : "supplemental_language",
            "createdAt" : "created_at",
            "inReplyToStatusIDStr" : "in_reply_to_status_id_str",
            "inReplyToStatusID" : "in_reply_to_status_id",
            "inReplyToUserIDStr" : "in_reply_to_user_id_str",
            "tidStr" : "id_str",
            "retweetedStatus" : "retweeted_status",
            "quotedStatus" : "quoted_status",
            
            "medias" : "emtities.media",
            "extendedMedias" : "extended_entities.media",
            "userMentions" : "entities.userMentions",
            "urls" : "entities.urls",
            "hashTags" : "entities.hashtags"
        ]
    }
}

class TWConversation: NSObject,YYModel {
    
    var targetTweetID: String?
    var participantIDs: NSArray?
    var participantsCount: String?
    var targetCount: String? // 0 if no target items
    
    var rootUserID: String?
    var contextIDs: NSArray?
    var entityIDs: NSArray?
    var tweets: NSArray?  // Array<T1Tweet>
    

    class func modelCustomPropertyMapper() -> [NSObject : AnyObject]! {
        
        return [
            "targetTweetID" : "context.target_tweet_id",
            "participantIDs" : "context.participant_ids",
            "participantsCount" : "context.participants_count",
            "targetCount" : "context.target_count",
            "rootUserID" : "ccontext.root_user_id",
            "contextIDs" : "ids"
        ]
    }
    
    class func modelContainerPropertyGenericClass() -> [NSObject : AnyObject]! {
        
        return [
            "participantIDs" : String.self(),
            "contextIDs" : String.self(),
        ]
    }
}

class TWAPIRespose: NSObject,YYModel {
    
    var moments: NSDictionary?
    var users: NSDictionary? ///< <UID(NSString), T1User>
    var tweets: NSDictionary? ///< <TID(NSString), T1Tweet>
    var timelineItmes: NSArray? /// < Array<T1Tweet/T1Conversation>
    var timeline: NSArray? ///< Array<Dictionary>
    var cursorTop: String?
    var cursorBottom: String?
    var cursorGaps: NSArray?
    
    class func modelContainerPropertyGenericClass() -> [NSObject : AnyObject]! {
        
        return [
            "users" : TWUser.self,
            "tweets" : TWTweet.self,
            "timeline" : NSDictionary.self,
            "hashTags" : TWHashTag.self
        ]
    }
    
    class func modelCustomPropertyMapper() -> [NSObject : AnyObject]! {
        
        return [
            "users" : "twitter_objects.users",
            "tweets" : "twitter_objects.tweets",
            "timeline" : "response.timeline",
            "cursorTop" : "response.cursor.top",
            "cursorBottom" : "response.cursor.bottom",
            "cursorGaps" : "response.cursor.gaps"
        ]
    }
    
    func modelCustomTransformFromDictionary(dic: [NSObject : AnyObject]!) -> Bool {
        
        let timelineItemsArray = NSMutableArray()
        
        if self.timeline?.count > 0 {
            
            for dic in self.timeline! {
                
                let tDic = (dic as! NSDictionary)["tweet"]
                if tDic != nil && tDic!.isKindOfClass(NSDictionary.self) {
                    
                    let tid = (tDic as! NSDictionary)["id"] as? String
                    if tid != nil {
                        
                        let tweet = self.tweets![tid!] as? TWTweet
                        if tweet != nil { timelineItemsArray.addObject(tweet!)}
                    }
                }
            }
        }
        
//        for (NSDictionary *dic in _timeline) {
//            NSDictionary *tDic = dic[@"tweet"];
//            if ([tDic isKindOfClass:[NSDictionary class]]) {
//                NSString *tid = tDic[@"id"];
//                if ([tid isKindOfClass:[NSString class]]) {
//                    T1Tweet *tweet = _tweets[tid];
//                    if (tweet) [timelineItems addObject:tweet];
//                }
//            } else {
//                NSDictionary *cDic = dic[@"conversation"];
//                if ([cDic isKindOfClass:[NSDictionary class]]) {
//                    T1Conversation *conversation = [T1Conversation modelWithDictionary:cDic];
//                    
//                    NSDictionary *entityID = dic[@"entity_id"];
//                    if ([entityID isKindOfClass:[NSDictionary class]]) {
//                        NSArray *ids = entityID[@"ids"];
//                        if ([ids isKindOfClass:[NSArray class]]) {
//                            conversation.entityIDs = ids;
//                        }
//                    }
//                    
//                    NSMutableArray *tweets = [NSMutableArray new];
//                    for (NSString *tid in conversation.contextIDs) {
//                        T1Tweet *tweet = _tweets[tid];
//                        if (tweet) [tweets addObject:tweet];
//                    }
//                    if (tweets.count > 1) {
//                        conversation.tweets = tweets;
//                        [timelineItems addObject:conversation];
//                    }
//                }
//            }
//        }
//        _timelineItmes = timelineItems;
//        
//        for (id item in _timelineItmes) {
//            if ([item isKindOfClass:[T1Tweet class]]) {
//                [self _updateTweetReference:item];
//            } else if ([item isKindOfClass:[T1Conversation class]]) {
//                for (T1Tweet *tweet in ((T1Conversation *)item).tweets) {
//                    [self _updateTweetReference:tweet];
//                }
//            }
//        }
        return true
    }
    
    
    private func  updateTweetReference(tweet: TWTweet?) {
        
        if tweet == nil { return }
        
        var user: TWUser?
        
        if let _ = tweet!.userMentions {
            
            for mention in tweet!.userMentions! as! [TWUserMention] {
                
                user = mention.uidStr != nil ? self.users![mention.uidStr!] as? TWUser : nil
                mention.user = user
            }
        }
        
        if tweet!.retweetedStatus != nil && tweet!.retweetedStatus!.userMentions != nil {
            
            for mention in tweet!.retweetedStatus!.userMentions! as! [TWUserMention] {
                
                user = mention.uidStr != nil ? self.users![mention.uidStr!] as? TWUser : nil
                mention.user = user
            }
        }
      
  
        user = tweet!.user
        user = user?.uidStr != nil ? self.users![user!.uidStr!] as? TWUser : nil
        tweet?.user = user
        
  
        if tweet!.retweetedStatus != nil {
            user = tweet!.retweetedStatus != nil ? tweet!.retweetedStatus!.user : nil
            user = user?.uidStr != nil ? self.users![user!.uidStr!] as? TWUser : nil
            tweet?.retweetedStatus!.user = user
        }
       
        if tweet!.quotedStatus != nil {
            user = tweet!.quotedStatus != nil ? tweet!.quotedStatus!.user : nil
            user = user?.uidStr != nil ? self.users![user!.uidStr!] as? TWUser : nil
            tweet?.quotedStatus!.user = user
        }

   

    }
}
class TWModel: NSObject {

}
