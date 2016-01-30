//
//  TWHelper.swift
//  weibo-swift
//
//  Created by 马超 on 16/1/28.
//  Copyright © 2016年 马超. All rights reserved.
//

import UIKit

class TWHelper: NSObject {

    
    //MARK: ------- 图片资源 bundle--------
    class func bundle() -> NSBundle
    {
        
        struct Static {
            static let bundle = NSBundle(path: NSBundle.mainBundle().pathForResource("ResourceTwitter", ofType: "bundle")!)!
        }
    
        return  Static.bundle
    }
    
    
    //MARK: ------- 图片 cache --------
    class func imageCache() -> YYMemoryCache
    {
        struct Static {

            static let twCache = YYMemoryCache()
            
        }
       
        Static.twCache.shouldRemoveAllObjectsOnMemoryWarning = false
        Static.twCache.shouldRemoveAllObjectsWhenEnteringBackground = false
        Static.twCache.name = "TwitterImageCache"
        
        return  Static.twCache
    }
    
    
    //MARK: ------- 从 bundle 里获取图片 (有缓存) -------
    class func imageNamed(name :NSString?) -> UIImage?
    {
        if name == nil
        {
            return nil
        }
        
        var image :UIImage? =  imageCache().objectForKey(name!) as? UIImage
        if let _ = image {
            return image
        }
        
        var ext  = name?.pathExtension
        if ext?.characters.count == 0
        {
            ext = "png"
        }
        let path =  bundle().pathForScaledResource(name! as String, ofType: ext)
        
        if path == nil
        {
            return nil
        }
        
        image = UIImage(contentsOfFile: path)
        
        //自动处理图片加压问题，系统自带的imageNamed是直接就解压图片的
        image = image?.imageByDecoded()
        if image == nil
        {
            return nil
        }
        
        imageCache().setObject(image, forKey: name)
        return image
    }
    
    
}

/// 格式化数据相关
extension TWHelper {
    
    //MARK: ------- 将 date 格式化成微博的友好显示 ---------
    class func stringWithTimelineDate(date :NSDate?) -> String?
    {
        if date == nil { return "" }
        
        struct Static {
            
            static let formatterFullDate = NSDateFormatter()
            
        }
        
        Static.formatterFullDate.dateFormat = "M/d/yy"
        Static.formatterFullDate.locale = NSLocale.currentLocale()
        
        
        let now = NSDate()
        let delta :NSTimeInterval = now.timeIntervalSince1970 - date!.timeIntervalSince1970
        if delta < -60 * 10
        {
            return  Static.formatterFullDate.stringFromDate(date!)
        }else if delta < 60  {
            return "\(Int(delta))s"
        }else if delta < 60 * 60 {
            return "\(Int(delta / 60.0))m"
        }else if delta < 60 * 60 * 24 {
            return "\(Int(delta / 60.0 / 60.0))h"
        }else if delta < 60 * 60 * 24 * 7 {
            return "\(Int(delta / 60.0 / 60.0 / 24))d"
        }else  {
            return  Static.formatterFullDate.stringFromDate(date!)
        }
        
    }

    
    //MARK: ------- 缩短数量描述，  ---------
    class func shortedNumberDesc(number :Int) -> String
    {
        if number <= 999
        {
            let to :String = String(number)
            
            return to
        }
        if number <= 9999
        {
            return String(format: "%d,%3.3d", Int(number / 1000),Int(number % 1000))
        }
        
        if number <= 1000 * 1000
        {
            return String(format: "%.1fK", Float(number) / 1000.0)
        }
        
        if number <= 1000 * 1000 * 1000
        {
            return String(format: "%.1fM", Float(number) / 1000.0 / 1000.0)
        }
        return String(format: "%.1fB", Float(number) / 1000.0 / 1000.0 / 1000.0)
    }

}
