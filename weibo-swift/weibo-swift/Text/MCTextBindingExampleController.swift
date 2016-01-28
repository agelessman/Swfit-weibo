//
//  MCTextBindingExampleController.swift
//  weibo-swift
//
//  Created by 马超 on 15/12/22.
//  Copyright © 2015年 马超. All rights reserved.
//

import UIKit


class EmailBindingParser :NSObject,YYTextParser{
    
    var regex :NSRegularExpression!
    
    override init() {
        
        
        
        let pattern = "[-_a-zA-Z@\\.]+[ ,\\n]"
        do
        {
            try self.regex = NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions.CaseInsensitive)
        }
        catch
        {
            
        }
        
        
        super.init()
    }
    
    func parseText(text :NSMutableAttributedString , selectedRange range :NSRangePointer) -> Bool
    {
        var changed = false
        self.regex.enumerateMatchesInString(text.string, options: NSMatchingOptions.WithoutAnchoringBounds, range: text.rangeOfAll()) { (result :NSTextCheckingResult?, flags :NSMatchingFlags?, stop :UnsafeMutablePointer<ObjCBool>) -> Void in
            
            if result == nil
            {
                return
            }
            
            //匹配到的邮箱的位置
            let range :NSRange = result!.range
            
            if range.location == NSNotFound || range.length < 1
            {
                return
            }
            
            if (text.attribute(YYTextBindingAttributeName, atIndex: range.location, effectiveRange: nil) != nil)
            {
                return
            }
            
            let bindlingRange = NSMakeRange(range.location, range.length - 1)
            let binding = YYTextBinding(deleteConfirm: true)
            text.setTextBinding(binding, range: bindlingRange)
            text.setColor(UIColor.redColor(), range: bindlingRange)
            changed = true
        }
        
        return changed
    }
}

class MCTextBindingExampleController: UIViewController {

    var textView :YYTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.whiteColor()
        if self.respondsToSelector("setAutomaticallyAdjustsScrollViewInsets:")
        {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        
        //MARK:说明。。这个绑定的最好的妙用就是可以绑定符合一定规则的字符串，，当我们在textview因为摸个条件到瑞一个邮箱挥着@一个人的名字的时候，，对这个进行绑定，就可以让用户要么删除整个，要么不删除，，这个功能很强大
        
        
        let text = NSMutableAttributedString(string: "sjobs@apple.com, apple@apple.com, banana@banana.com, pear@pear.com ")
        text.font = UIFont.systemFontOfSize(17)
        text.lineSpacing = 5
        text.color = UIColor.blackColor()
        
        textView = YYTextView()
        textView.attributedText = text
        textView.textParser = EmailBindingParser()
        textView.size = self.view.size
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.Interactive
        textView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0)
        textView.scrollIndicatorInsets = textView.contentInset
        self.view.addSubview(textView)
        textView.becomeFirstResponder()
        
        
    }
    


}
