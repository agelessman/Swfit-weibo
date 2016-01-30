//
//  MCTextTagExampleController.swift
//  weibo-swift
//
//  Created by 马超 on 15/12/22.
//  Copyright © 2015年 马超. All rights reserved.
//

import UIKit

class MCTextTagExampleController: UIViewController,YYTextViewDelegate {

    var textView :YYTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.whiteColor()
        if self.respondsToSelector("setAutomaticallyAdjustsScrollViewInsets:")
        {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        let text :NSMutableAttributedString = NSMutableAttributedString()
        
        let tags :Array<String> = ["◉red", "◉orange", "◉yellow", "◉green", "◉blue", "◉purple", "◉gray"]
        
        let tagStrokeColors :Array = [
            UIColor(hexString: "fa3f39"),
            UIColor(hexString: "f48f25"),
            UIColor(hexString: "f1c02c"),
            UIColor(hexString: "54bc2e"),
            UIColor(hexString: "29a9ee"),
            UIColor(hexString: "c171d8"),
            UIColor(hexString: "818e91")
        ]
        
        let tagFillColors :Array = [
            UIColor(hexString: "fb6560"),
            UIColor(hexString: "f6a550"),
            UIColor(hexString: "f3cc56"),
            UIColor(hexString: "76c957"),
            UIColor(hexString: "53baf1"),
            UIColor(hexString: "cd8ddf"),
            UIColor(hexString: "a4a4a7")
        ]
        
        let font :UIFont = UIFont.systemFontOfSize(16.0)
        
        for var i = 0 ; i < tags.count ; i++
        {
            let tag :String = tags[i]
            let tagStrokeColor :UIColor = tagStrokeColors[i]
            let tagFillColor :UIColor = tagFillColors[i]
            
            let tagText :NSMutableAttributedString = NSMutableAttributedString(string: tag)
            tagText.insertString("     ", atIndex: 0)
            tagText.appendString("     ")
            tagText.font = font
            tagText.color = UIColor.whiteColor()
            tagText.setTextBinding(YYTextBinding(deleteConfirm: false), range: tagText.rangeOfAll())
            
            let border :YYTextBorder = YYTextBorder()
            border.strokeWidth = 1.5
            border.strokeColor = tagStrokeColor
            border.fillColor = tagFillColor
            border.cornerRadius = 100
            border.insets = UIEdgeInsets(top: -2, left: -5.5, bottom: -2, right: -8)
        
            let range  = tagText.string.rangeOfString(tag)
            
            let r :NSRange = NSMakeRange(tagText.string.startIndex.distanceTo((range?.startIndex)!), range!.startIndex.distanceTo((range?.endIndex)!))
            tagText.setTextBackgroundBorder(border, range: r)
            
            text.appendAttributedString(tagText)
            
        }
        
        text.lineSpacing = 10
        text.lineBreakMode = NSLineBreakMode.ByWordWrapping
        
        text.appendString("\n")
        text.appendAttributedString(text)
        
        textView = YYTextView()
        textView.attributedText = text;
        textView.size = self.view.size
        textView.textContainerInset = UIEdgeInsets(top: 10 + 64, left: 10, bottom: 10, right: 10)
        textView.allowsCopyAttributedString = true
        textView.allowsPasteAttributedString = true
        textView.delegate = self
        textView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.Interactive
        textView.scrollIndicatorInsets = textView.contentInset
        textView.selectedRange = NSMakeRange(text.length, 0)
        self.view.addSubview(textView)
        
        dispatch_after(UInt64(0.6 * 1000000000), dispatch_get_main_queue()) { () -> Void in
            self.textView.becomeFirstResponder()
        }
        
    }

    
    //MARK:-  ----textView delegate -----
    func textViewDidBeginEditing(textView: YYTextView!) {
        
    }
    
    func textViewDidEndEditing(textView: YYTextView!) {
        
    }

}
