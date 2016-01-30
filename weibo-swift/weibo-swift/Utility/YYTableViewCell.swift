//
//  YYTableViewCell.swift
//  weibo-swift
//
//  Created by 马超 on 16/1/9.
//  Copyright © 2016年 马超. All rights reserved.
//

import UIKit

class YYTableViewCell: UITableViewCell {


    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        for view :UIView in self.subviews
        {
            if view.isKindOfClass(UIScrollView.self) {
                (view as! UIScrollView).delaysContentTouches = false
                break
            }
        }
        
        self.selectionStyle = UITableViewCellSelectionStyle.None
        self.backgroundView?.backgroundColor = UIColor.clearColor()
        self.contentView.backgroundColor = UIColor.clearColor()
        self.backgroundColor = UIColor.clearColor()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  

}
