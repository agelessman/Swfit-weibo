//
//  MCTextUndoRedoExampleController.swift
//  weibo-swift
//
//  Created by 马超 on 15/12/22.
//  Copyright © 2015年 马超. All rights reserved.
//

import UIKit

class MCTextUndoRedoExampleController: UIViewController {

     var textView :YYTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.whiteColor()
        if self.respondsToSelector("setAutomaticallyAdjustsScrollViewInsets:")
        {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        let text = "You can shake the device to undo and redo."
        
        
        textView = YYTextView()
        textView.text = text
        textView.font = UIFont.systemFontOfSize(17)
        textView.size = self.view.size
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.Interactive
        textView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0)
        textView.scrollIndicatorInsets = textView.contentInset
        textView.allowsUndoAndRedo = true
        textView.maximumUndoLevel = 10
        self.view.addSubview(textView)
        textView.becomeFirstResponder()
        textView.selectedRange = NSMakeRange(text.startIndex.distanceTo(text.endIndex), 0)
        
    }

    

}
