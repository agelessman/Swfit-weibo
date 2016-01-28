//
//  WBStatusHelper.swift
//  weibo-swift
//
//  Created by 马超 on 15/12/28.
//  Copyright © 2015年 马超. All rights reserved.
//

import UIKit


 var groups : NSMutableArray?

 var manager :YYWebImageManager?

 var formatterYesterday : NSDateFormatter?
 var formatterSameYear : NSDateFormatter?
 var formatterFullDate : NSDateFormatter?

 var regexat :NSRegularExpression?
 var regextopic :NSRegularExpression?
 var regexemoticon :NSRegularExpression?

 var dic:NSMutableDictionary?

 var emBundle :NSBundle?

 var cache :YYMemoryCache?
class WBStatusHelper: NSObject {
  
    //MARK: -------表情组的单利------
    
    
    //MARK: ------- 微博图片资源 bundle--------
    /**
     *   在swift中有很多种单例的写法，可以向下边这样写，也可以像下下边的那么写，不过建议写成下边这样的。
     */
    class func bundle() -> NSBundle
    {
        
        struct Static {
            static let bundle = NSBundle(path: NSBundle.mainBundle().pathForResource("ResourceWeibo", ofType: "bundle")!)!
        }
        
        return  Static.bundle

    }
    
    
    //MARK: ------- 微博表情资源 bundle-------
    class func emoticonBundle() -> NSBundle
    {
        if emBundle == nil {
        emBundle = NSBundle(path: NSBundle.mainBundle().pathForResource("EmoticonWeibo", ofType: "bundle")!)!
        }
        return emBundle!
    }
    
    //MARK: ------- 微博图片 cache --------
    class func imageCache() -> YYMemoryCache
    {
        if cache == nil {
            cache = YYMemoryCache()
             cache!.shouldRemoveAllObjectsOnMemoryWarning = true
             cache!.shouldRemoveAllObjectsWhenEnteringBackground = true
             cache!.name = "WeiboImageCache"
        }
       
        return  cache!
    }
    
    //MARK: ------- 从微博 bundle 里获取图片 (有缓存) -------
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
    
    
    //MARK: ------- 从path创建图片 (有缓存) ---------
    class func imageWithPath(path :NSString?) -> UIImage?
    {
        if path == nil
        {
            return nil
        }
        var image :UIImage? =  imageCache().objectForKey(path!) as? UIImage
        if let _ = image {
            return image
        }
        if path?.pathScale() == 1
        {
            // 查找 @2x @3x 的图片
            let scales :Array<NSNumber> = NSBundle.preferredScales() as! [NSNumber]
            for scale :NSNumber in scales
            {
                image = UIImage(contentsOfFile: path!.stringByAppendingPathScale(CGFloat(scale)))
                if let _ = image
                {
                    break
                }
            }
        }else
        {
            image = UIImage(contentsOfFile: path as! String)
        }
        if let _ = image{
            image = image?.imageByDecoded()
             imageCache().setObject(image, forKey: path)
        }
        return image
    }
    
    
    //MARK: ------- 圆角头像的 manager  --------
    class func avatarImageManager() -> YYWebImageManager
    {
    
        if  manager == nil {
            
            let path = UIApplication.sharedApplication().cachesPath + "/weibo.avatar"
            let cache :YYImageCache = YYImageCache(path: path)
            manager = YYWebImageManager(cache: cache, queue: YYWebImageManager.sharedManager().queue)
            manager!.sharedTransformBlock = { (image :UIImage? , url :NSURL?) -> UIImage  in
             
                if image == nil { return image! }
                return image!.imageByRoundCornerRadius(100)
            }
        }
        
        return  manager!
    }
    
    
    //MARK: ------- 将 date 格式化成微博的友好显示 ---------
    class func stringWithTimelineDate(date :NSDate?) -> String?
    {
        if date == nil { return "" }
        if  formatterYesterday == nil {
             formatterYesterday = NSDateFormatter()
             formatterYesterday!.dateFormat = "昨天 HH:mm"
             formatterYesterday!.locale = NSLocale.currentLocale()
        }
        
        if  formatterSameYear == nil {
             formatterSameYear = NSDateFormatter()
             formatterSameYear!.dateFormat = "M-d"
             formatterSameYear!.locale = NSLocale.currentLocale()
        }
        if  formatterFullDate == nil {
             formatterFullDate = NSDateFormatter()
             formatterFullDate!.dateFormat = "yy-M-dd"
             formatterFullDate!.locale = NSLocale.currentLocale()
        }
        
        
        let now = NSDate()
        let delta :NSTimeInterval = now.timeIntervalSince1970 - date!.timeIntervalSince1970
        if delta < -60 * 10
        {
            return  formatterFullDate!.stringFromDate(date!)
        }else if delta < 60 * 10 {
            return "刚刚"
        }else if delta < 60 * 60 {
            return "\(Int(delta / 60.0))分钟前"
        }else if date!.isToday {
            return "\(Int(delta / 60.0 / 60.0))小时前"
        }else if date!.isYesterday {
            return formatterYesterday!.stringFromDate(date!)
        }else if date!.year == now.year {
            return formatterSameYear!.stringFromDate(date!)
        }else  {
            return formatterFullDate!.stringFromDate(date!)
        }
        
    }
    
    //MARK: ------- 将微博API提供的图片URL转换成可用的实际URL  ---------
    class func defaultURLForImageURL(imageURL :AnyObject?) -> NSURL?
    {
        /*
        微博 API 提供的图片 URL 有时并不能直接用，需要做一些字符串替换：
        http://u1.sinaimg.cn/upload/2014/11/04/common_icon_membership_level6.png //input
        http://u1.sinaimg.cn/upload/2014/11/04/common_icon_membership_level6_default.png //output
        
        http://img.t.sinajs.cn/t6/skin/public/feed_cover/star_003_y.png?version=2015080302 //input
        http://img.t.sinajs.cn/t6/skin/public/feed_cover/star_003_os7.png?version=2015080302 //output
        */
        
        if imageURL == nil { return nil }
        var link :String?
        
        if imageURL!.isKindOfClass(NSURL.self)
        {
            link = (imageURL! as! NSURL).absoluteString
            
        }else if imageURL!.isKindOfClass(NSString.self)
        {
            link = (imageURL! as! String)
        }
        
        if link?.characters.count == 0 {return nil}
        
        if link!.hasSuffix(".png")
        {
            // add "_default"
            if !(link!.hasSuffix("_default.png"))
            {
                let sub = link!.substringToIndex(link!.startIndex.advancedBy(link!.characters.count - 4 ))
                link = sub + "_default.png"
                
            }
        }else
            {
                let range :Range? = link!.rangeOfString("_y.png?version")
               
                if let _ = range
                {
                    let mutable :NSMutableString = NSMutableString(string: link!)
                    mutable.replaceCharactersInRange(NSMakeRange(link!.startIndex.distanceTo(range!.startIndex) + 1, 1), withString: "os7")
                    link = mutable as String
                }
            }
            
    
        return NSURL(string: link!)
    }
    
    
    //MARK: ------- 缩短数量描述，例如 51234 -> 5万  ---------
    class func shortedNumberDesc(number :UInt) -> String?
    {
        if number <= 9999
        {
            let to :String = String(number)
           
            return to
        }
        if number <= 9999999
        {
            return String(number / 10000) + "万"
        }
        return String(number / 10000000) + "千万"
    }
    
    //MARK: ------- At正则 例如 @王思聪  --------
    class func regexAt() -> NSRegularExpression
    {
        if  regexat == nil {
            
            // 微博的 At 只允许 英文数字下划线连字符，和 unicode 4E00~9FA5 范围内的中文字符，这里保持和微博一致。。
            // 目前中文字符范围比这个大
            do {
                try  regexat = NSRegularExpression(pattern: "@[-_a-zA-Z0-9\\u4E00-\\u9FA5]+", options: NSRegularExpressionOptions.CaseInsensitive)
            }catch{}
            
        }
        
        return  regexat!
    }
    
    //MARK: ------- 话题正则 例如 #暖暖环游世界# --------
    class func regexTopic() -> NSRegularExpression
    {
        if  regextopic == nil {
            
            do {
                try  regextopic = NSRegularExpression(pattern: "#[^@#]+?#", options: NSRegularExpressionOptions.CaseInsensitive)
            }catch{}
            
        }
        
        return  regextopic!
    }
    
    //MARK: ------- 表情正则 例如 [偷笑] --------
    class func regexEmoticon() -> NSRegularExpression
    {
        
        if  regexemoticon == nil {
            do {
                try  regexemoticon = NSRegularExpression(pattern: "\\[[^ \\[\\]]+?\\]", options: NSRegularExpressionOptions.AllowCommentsAndWhitespace)
            }catch{}
            
        }
        
        return  regexemoticon!
    }
    
    /// 表情字典 key:[偷笑] value:ImagePath
    class func emoticonDic() -> NSDictionary?
    {

        if  dic == nil {
            
            let emoticonBundlePath = NSBundle.mainBundle().pathForResource("EmoticonWeibo", ofType: "bundle")
             dic =  _emoticonDicFromPath(emoticonBundlePath!)
        }
        
        return  dic
    }
    
    class func _emoticonDicFromPath(path :String) -> NSMutableDictionary?
    {
        let dic = NSMutableDictionary()
        var group : WBEmoticonGroup?
        let jsonPath = path + "/info.json"
        let json = NSData(contentsOfFile: jsonPath)
        
        if let _ = json
        {
            group = WBEmoticonGroup.modelWithJSON(json)
        }
        if group == nil
        {
            let plistPath = path + "/info.plist"
            let plist = NSDictionary(contentsOfFile: plistPath)
//            print(plistPath)
            if  plist?.count > 0 {
                group = WBEmoticonGroup.modelWithJSON(plist!);
            }
        }
        if let _ = group {
            for emoticon :WBEmoticon in group?.emoticons! as! [WBEmoticon]
            {
                if emoticon.png == nil { continue }
                let pngPath = path + "/" + emoticon.png!
                if let _ = emoticon.chs { dic[emoticon.chs!] = pngPath }
                if let _ = emoticon.cht { dic[emoticon.cht!] = pngPath }
            }
        }
      
        do {
        
            let folders = try NSFileManager.defaultManager().contentsOfDirectoryAtPath(path)
 
            for folder :String in folders
            {
              
//                if folder == nil { continue }
                let subDic  = self._emoticonDicFromPath(path + "/" + folder)
            
              
                if subDic != nil {
                
                    var tempDic :[NSObject : AnyObject] = Dictionary()
                    //转换为swift 的字典
                    for key :String in subDic!.allKeys as! [String]
                    {
                        tempDic[key] = subDic![key]
                    }
                    
                   dic.addEntriesFromDictionary(tempDic)
                }
            }
            
        }catch{
        
            
        }
        
        return dic
    }
    
    
    //MARK: ------- 微博表情 Array<WBEmotionGroup> (实际应该做成动态更新的) ---------
    class func emoticonGroups() -> NSArray
    {
        

        if  groups == nil {
        
            let emoticonBundlePath = NSBundle.mainBundle().pathForResource("EmoticonWeibo", ofType: "bundle")
            let emoticonPlistPath = emoticonBundlePath! + "/emoticons.plist"
            let plist = NSDictionary(contentsOfFile: emoticonPlistPath)!
            let packages :NSArray = plist["packages"] as! NSArray
            
            groups = NSMutableArray(array: NSArray.modelArrayWithClass(WBEmoticonGroup.self, json: packages))

            let groupDic = NSMutableDictionary()
            for var i = 0 , max = groups!.count ; i < max ; i++
            {
                //此时的group只有id数据
                let group :WBEmoticonGroup = groups![i]  as! WBEmoticonGroup
                if group.groupID?.characters.count == 0
                {
                    groups!.removeObjectAtIndex(i)
                    i--
                    max--
                    continue
                }
                
                //去根目录查找真是的组
                let path = emoticonBundlePath! + "/" + group.groupID!
                let infoPlistPath = path + "/info.plist"
                let info = NSDictionary(contentsOfFile: infoPlistPath)
                
                //转换全部的组模型
                 group .modelSetWithDictionary(info! as [NSObject : AnyObject])
                if group.emoticons?.count == 0
                {
                    i--
                    max--
                    continue
                }
                groupDic[group.groupID!] = group
                
            }
            
            
            do{
                
             let additionals = try NSFileManager.defaultManager().contentsOfDirectoryAtPath(emoticonBundlePath! + "/additional")
                for path :String in additionals
                {
                    let group :WBEmoticonGroup? = groupDic[path] as? WBEmoticonGroup
                    if group === nil
                    {
                        continue
                    }
                    
                    let infoJSONPath = emoticonBundlePath! + "/additional" + "/\(path)" + "/info.json"
                    let infoJSON = NSData(contentsOfFile: infoJSONPath)
                    let addGroup :WBEmoticonGroup = WBEmoticonGroup.modelWithJSON(infoJSON!)
                    
                    if addGroup.emoticons?.count != 0
                    {
                        for e  in addGroup.emoticons!
                        {
                            let emoticon :WBEmoticon = e as! WBEmoticon
                            emoticon.group = group
                        }
                        
                        let arrayM :NSMutableArray = NSMutableArray(array: (group?.emoticons)!)
                        arrayM.insertObjects(addGroup.emoticons as! [AnyObject], atIndex: 0)
                        group?.emoticons = arrayM;
                    }
                }
                
            }catch{
            
            }
 
        }
        return groups!
    }
    
    
    
    /*
    weibo.app 里面的正则，有兴趣的可以参考下：
    
    HTTP链接 (例如 http://www.weibo.com ):
    ([hH]ttp[s]{0,1})://[a-zA-Z0-9\.\-]+\.([a-zA-Z]{2,4})(:\d+)?(/[a-zA-Z0-9\-~!@#$%^&*+?:_/=<>.',;]*)?
    ([hH]ttp[s]{0,1})://[a-zA-Z0-9\.\-]+\.([a-zA-Z]{2,4})(:\d+)?(/[a-zA-Z0-9\-~!@#$%^&*+?:_/=<>]*)?
    (?i)https?://[a-zA-Z0-9]+(\.[a-zA-Z0-9]+)+([-A-Z0-9a-z_\$\.\+!\*\(\)/,:;@&=\?~#%]*)*
    ^http?://[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)+(\/[\w-. \/\?%@&+=\u4e00-\u9fa5]*)?$
    
    链接 (例如 www.baidu.com/s?wd=test ):
    ^[a-zA-Z0-9]+(\.[a-zA-Z0-9]+)+([-A-Z0-9a-z_\$\.\+!\*\(\)/,:;@&=\?~#%]*)*
    
    邮箱 (例如 sjobs@apple.com ):
    \b([a-zA-Z0-9%_.+\-]{1,32})@([a-zA-Z0-9.\-]+?\.[a-zA-Z]{2,6})\b
    \b([a-zA-Z0-9%_.+\-]+)@([a-zA-Z0-9.\-]+?\.[a-zA-Z]{2,6})\b
    ([a-zA-Z0-9%_.+\-]+)@([a-zA-Z0-9.\-]+?\.[a-zA-Z]{2,6})
    
    电话号码 (例如 18612345678):
    ^[1-9][0-9]{4,11}$
    
    At (例如 @王思聪 ):
    @([\x{4e00}-\x{9fa5}A-Za-z0-9_\-]+)
    
    话题 (例如 #奇葩说# ):
    #([^@]+?)#
    
    表情 (例如 [呵呵] ):
    \[([^ \[]*?)]
    
    匹配单个字符 (中英文数字下划线连字符)
    [\x{4e00}-\x{9fa5}A-Za-z0-9_\-]
    
    匹配回复 (例如 回复@王思聪: ):
    \x{56de}\x{590d}@([\x{4e00}-\x{9fa5}A-Za-z0-9_\-]+)(\x{0020}\x{7684}\x{8d5e})?:
    
    */

}
