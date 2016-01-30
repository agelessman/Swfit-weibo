//
//  MCTextMarkdownExampleController.swift
//  weibo-swift
//
//  Created by 马超 on 15/12/22.
//  Copyright © 2015年 马超. All rights reserved.
//

import UIKit

class MCTextMarkdownExampleController: UIViewController {

    var textView :YYTextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.whiteColor()
        if self.respondsToSelector("setAutomaticallyAdjustsScrollViewInsets:")
        {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        let text = "#Markdown Editor\nThis is a simple markdown editor based on `YYTextView`.\n\n*********************************************\nIt\'s *italic* style.\n\nIt\'s also _italic_ style.\n\nIt\'s **bold** style.\n\nIt\'s ***italic and bold*** style.\n\nIt\'s __underline__ style.\n\nIt\'s ~~deleteline~~ style.\n\n\nHere is a link: [YYKit](https://github.com/ibireme/YYKit)\n\nHere is some code:\n\n\tif(a){\n\t\tif(b){\n\t\t\tif(c){\n\t\t\t\tprintf(\"haha\");\n\t\t\t}\n\t\t}\n\t}\n"
        
        let parser  = YYTextSimpleMarkdownParser()
        parser.setColorWithDarkTheme()
        
        textView = YYTextView()
        textView.text = text
        textView.textParser = parser
        textView.font = UIFont.systemFontOfSize(14.0)
        textView.size = self.view.size
        textView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10)
        textView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.Interactive
        textView.backgroundColor = UIColor(white: 0.134, alpha: 1.000)
        textView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0)
        textView.scrollIndicatorInsets = textView.contentInset
        textView.selectedRange = NSMakeRange(text.characters.count, 0)
        self.view.addSubview(textView)
    }

    

}
