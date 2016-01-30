//
//  WBStatusComposeTextParser.swift
//  weibo-swift
//
//  Created by 马超 on 16/1/22.
//  Copyright © 2016年 马超. All rights reserved.
//

import UIKit

var topicExts: NSArray?
var topicExtImages: NSArray?

class WBStatusComposeTextParser: NSObject ,YYTextParser{

    var font: UIFont!
    var textColor: UIColor!
    var highlightTextColor: UIColor!
    
    override init() {
        self.font               = UIFont.systemFontOfSize(17.0)
        self.textColor          = UIColor(white: 0.2, alpha: 1)
        self.highlightTextColor = UIColor(hexString: "527ead")

        super.init()
    }
    
    func parseText(text: NSMutableAttributedString!, selectedRange: NSRangePointer) -> Bool {
        
        text.color = self.textColor
        
        if topicExts == nil {
           topicExts = [ "[电影]#", "[图书]#", "[音乐]#", "[地点]#", "[股票]#" ]
        }
        
        if topicExtImages == nil {
            
            topicExtImages = [
                WBStatusHelper.imageNamed("timeline_card_small_movie")!,
                WBStatusHelper.imageNamed("timeline_card_small_book")!,
                WBStatusHelper.imageNamed("timeline_card_small_music")!,
                WBStatusHelper.imageNamed("timeline_card_small_location")!,
                WBStatusHelper.imageNamed("timeline_card_small_stock")!]
        }
        
        let topicResults = WBStatusHelper.regexTopic().matchesInString(text.string, options: NSMatchingOptions(), range: text.rangeOfAll())
        var clipLength: Int = 0
        
        for topic: NSTextCheckingResult in topicResults {
            
            if topic.range.location == NSNotFound && topic.range.length <= 1 { continue }
            
            var range = topic.range
            range.location -= clipLength
            print(range)
            ///检查是不是有绑定的
            var containsBindingRange = false
            text.enumerateAttribute(YYTextBindingAttributeName, inRange: range, options: NSAttributedStringEnumerationOptions.LongestEffectiveRangeNotRequired, usingBlock: { (value, rangee,  stop: UnsafeMutablePointer<ObjCBool>) -> Void in
                if value != nil {
                    containsBindingRange = true
                }
            })
            
            if containsBindingRange { continue }
            
            var hasExt = false
            let subText = text.string.substringWithRange(Range(start: text.string.startIndex.advancedBy(range.location), end: text.string.startIndex.advancedBy(range.location + range.length )))
            
            for var i = 0 ; i < topicExts!.count ; i++ {
                let ext = topicExts![i] as! String
                if subText.hasSuffix(ext) && subText.startIndex.distanceTo(subText.endIndex) > ext.startIndex.distanceTo(ext.endIndex) + 1 {
                    
                    let replace = NSMutableAttributedString(string: subText.substringWithRange(Range(start: subText.startIndex.advancedBy(1), end: subText.startIndex.advancedBy(subText.startIndex.distanceTo(subText.endIndex)  - ext.startIndex.distanceTo(ext.endIndex)))))
                    let pic = self._attachmentWithFontSize(Float(self.font!.pointSize), image: topicExtImages![i] as! UIImage, shrink: true)
                    replace.insertAttributedString(pic!, atIndex: 0)
                    
                    replace.font = self.font
                    
                    let backed = YYTextBackedString(string: subText)
                    replace.setTextBackedString(backed, range: NSMakeRange(0, replace.length))
                    
                    text.replaceCharactersInRange(range, withAttributedString: replace)
                    text.setTextBinding(YYTextBinding(deleteConfirm: true), range: NSMakeRange(range.location, replace.length))
                    text.setColor(self.highlightTextColor, range: NSMakeRange(range.location, replace.length))
                    
                    if selectedRange != nil {
                        
                        selectedRange .memory = self._replaceTextInRange(range, withLength: replace.length, selectedRange: selectedRange.memory)

                    }
                    
                    clipLength += range.length - replace.length
                    hasExt = true
                    break;
                    
                }
            }
            
            if (!hasExt) {
                
                text.setColor(self.highlightTextColor, range: range)
                
            }
        }
        

        let atResults = WBStatusHelper.regexAt().matchesInString(text.string, options: NSMatchingOptions(), range: text.rangeOfAll())
        
        for at in atResults {
            if at.range.location == NSNotFound && at.range.length <= 1 { continue }
            
            ///检查是不是有绑定的
            var atcontainsBindingRange = false
            text.enumerateAttribute(YYTextBindingAttributeName, inRange: at.range, options: NSAttributedStringEnumerationOptions.LongestEffectiveRangeNotRequired, usingBlock: { (value, rangee,  stop: UnsafeMutablePointer<ObjCBool>) -> Void in
                if value != nil {
                    atcontainsBindingRange = true
                }
            })
            
            if atcontainsBindingRange { continue }
          
            text.setColor(self.highlightTextColor, range: at.range)
            
        }
        
        let emoticonResults = WBStatusHelper.regexEmoticon().matchesInString(text.string, options: NSMatchingOptions(), range: text.rangeOfAll())
        var emoclipLength: Int = 0
        
        for emo: NSTextCheckingResult in emoticonResults {
            
            if emo.range.location == NSNotFound && emo.range.length <= 1 { continue }
            
            var emorange = emo.range
            emorange.location -= emoclipLength
        
            if text.attribute(YYTextAttachmentAttributeName, atIndex: UInt(emorange.location)) != nil { continue }
            let emoString = text.string.substringWithRange(Range(start: text.string.startIndex.advancedBy(emorange.location), end: text.string.startIndex.advancedBy(emorange.location + emorange.length)))
            let imagePath = WBStatusHelper.emoticonDic()![emoString]
            let image = WBStatusHelper.imageWithPath(imagePath as? NSString)
            if image == nil { continue }
            
            
            ///检查是不是有绑定的
            var emocontainsBindingRange = false
            text.enumerateAttribute(YYTextBindingAttributeName, inRange: emorange, options: NSAttributedStringEnumerationOptions.LongestEffectiveRangeNotRequired, usingBlock: { (value, rangee,  stop: UnsafeMutablePointer<ObjCBool>) -> Void in
                if value != nil {
                    emocontainsBindingRange = true
                }
            })
            
            if emocontainsBindingRange { continue }
            
     
            let emobacked = YYTextBackedString(string: emoString)
            let emoText = NSAttributedString.attachmentStringWithEmojiImage(image!, fontSize: self.font.pointSize)
            emoText.setTextBackedString(emobacked, range: NSMakeRange(0, emoText.length))
            emoText.setTextBinding(YYTextBinding(deleteConfirm: false), range: NSMakeRange(0, emoText.length))
            
            text.replaceCharactersInRange(emorange, withAttributedString: emoText)
            
            if selectedRange != nil {
                
                selectedRange .memory = self._replaceTextInRange(emorange, withLength: emoText.length, selectedRange: selectedRange.memory)
                
            }
            
            emoclipLength += emorange.length - emoText.length
           
        }
        
        
        text.enumerateAttribute(YYTextBindingAttributeName, inRange: text.rangeOfAll(), options: NSAttributedStringEnumerationOptions.LongestEffectiveRangeNotRequired, usingBlock: { (value, rangee,  stop: UnsafeMutablePointer<ObjCBool>) -> Void in
            if value != nil && rangee.length > 1 {
                text.setColor(self.highlightTextColor, range: rangee)
            }
        })
        text.font = self.font
        return true
    }
    
    
    
    func _replaceTextInRange(range: NSRange , withLength length: Int , var selectedRange: NSRange ) -> NSRange {
        
        // no change
        if range.length == length { return selectedRange }

        // right
        if (range.location >= selectedRange.location + selectedRange.length) { return selectedRange }
        // left
        if (selectedRange.location >= range.location + range.length) {
            selectedRange.location = selectedRange.location + length - range.length;
            return selectedRange
        }
        // same
        if (NSEqualRanges(range, selectedRange)) {
            selectedRange.length = length;
            return selectedRange
        }

        // one edge same
        if ((range.location == selectedRange.location && range.length < selectedRange.length) ||
            (range.location + range.length == selectedRange.location + selectedRange.length && range.length < selectedRange.length)) {
                selectedRange.length = selectedRange.length + length - range.length;
                return selectedRange
        }
        selectedRange.location = range.location + length
        selectedRange.length = 0
        return selectedRange
    }
    
    func _attachmentWithFontSize(fontSize :Float ,image :UIImage ,shrink :Bool) -> NSAttributedString?
    {
       
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
}
