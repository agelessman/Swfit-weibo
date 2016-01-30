//
//  WBPictureMetadata.swift
//  weibo-swift
//
//  Created by 马超 on 16/1/10.
//  Copyright © 2016年 马超. All rights reserved.
//

import UIKit

/**
 一个图片的元数据
 */
class WBPictureMetadata :NSObject,YYModel{
    
    var url :NSURL? //< Full image url
    var width :String?  ///< pixel width
    var height :String?  ///< pixel height
    var type :String? ///< "WEBP" "JPEG" "GIF"
    var cutType:Int?  ///< Default:1
    var badgeType :WBPictureBadgeType?
    
    class func modelCustomPropertyMapper() -> [NSObject : AnyObject]! {
        return ["cutType" : "cut_type"]
    }
    
    func modelCustomTransformFromDictionary(dic: [NSObject : AnyObject]!) -> Bool {
        
        if self.type == "GIF"
        {
            badgeType = WBPictureBadgeType.WBPictureBadgeTypeGIF
        }else
        {
            if (self.width != nil && Int(self.width!)! > 0)  && (self.height != nil && Int(self.height!)! > 0) {
            
                if Int(self.height!)! / Int(self.width!)! > 3 {
                    badgeType = WBPictureBadgeType.WBPictureBadgeTypeLong
                }else{
                    badgeType = WBPictureBadgeType.WBPictureBadgeTypeNone
                }
            }else{
            badgeType = WBPictureBadgeType.WBPictureBadgeTypeNone
            }
       
            
        }
        
        return true
    }
}
