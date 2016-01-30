//
//  MCTextRubyExampleController.swift
//  weibo-swift
//
//  Created by 马超 on 15/12/22.
//  Copyright © 2015年 马超. All rights reserved.
//

import UIKit

class MCTextRubyExampleController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.whiteColor()
        if self.respondsToSelector("setAutomaticallyAdjustsScrollViewInsets:")
        {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        let text = NSMutableAttributedString()
        
        var one = NSMutableAttributedString(string: "这是用汉语写的一段文字。")
        one.font = UIFont.boldSystemFontOfSize(30)
        
        var oneStringOfOc = one.string as NSString
        
        var ruby = YYTextRubyAnnotation()
        ruby.textBefore = "hàn yŭ"
        one .setTextRubyAnnotation(ruby, range: oneStringOfOc.rangeOfString("汉语"))
        
        ruby.textBefore = "wén"
        one .setTextRubyAnnotation(ruby, range: oneStringOfOc.rangeOfString("文"))
        
        ruby.textBefore = "zì"
        ruby.alignment = CTRubyAlignment.Center
        one .setTextRubyAnnotation(ruby, range: oneStringOfOc.rangeOfString("字"))
        
        text.appendAttributedString(one)
        text.appendAttributedString(self.padding())
        
        
        
        one = NSMutableAttributedString(string: "日本語で書いた作文です。")
        one.font = UIFont.boldSystemFontOfSize(30)
        
        oneStringOfOc = one.string as NSString
        
        ruby = YYTextRubyAnnotation()
        ruby.textBefore = "に"
        one .setTextRubyAnnotation(ruby, range: oneStringOfOc.rangeOfString("日"))
        
        ruby.textBefore = "ほん"
        one .setTextRubyAnnotation(ruby, range: oneStringOfOc.rangeOfString("本"))
        
        ruby.textBefore = "ご"
        one .setTextRubyAnnotation(ruby, range: oneStringOfOc.rangeOfString("語"))
        
        ruby.textBefore = "か"
        one .setTextRubyAnnotation(ruby, range: oneStringOfOc.rangeOfString("書"))
        
        ruby.textBefore = "さく"
        one .setTextRubyAnnotation(ruby, range: oneStringOfOc.rangeOfString("作"))
        
        ruby.textBefore = "ぶん"
        one .setTextRubyAnnotation(ruby, range: oneStringOfOc.rangeOfString("文"))
        
        text.appendAttributedString(one)
        
        let label :YYLabel  = YYLabel()
        label.attributedText = text
        label.width = self.view.width - 60
        label.centerX = self.view.width / 2
        label.height = self.view.height - 64 - 60
        label.top = 64 + 30
        label.textAlignment = NSTextAlignment.Center
        label.textVerticalAlignment = YYTextVerticalAlignment.Center
        label.numberOfLines = 0
        label.backgroundColor = UIColor(white: 0.933, alpha: 1.000)
        self.view.addSubview(label)
        
    }

    
    func padding() -> NSAttributedString
    {
        let padding :NSMutableAttributedString = NSMutableAttributedString(string: "\n\n")
        padding.font = UIFont.systemFontOfSize(30)
        return padding
    }

}
