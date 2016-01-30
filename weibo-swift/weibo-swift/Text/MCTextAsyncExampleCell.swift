//
//  MCTextAsyncExampleCell.swift
//  weibo-swift
//
//  Created by 马超 on 15/12/28.
//  Copyright © 2015年 马超. All rights reserved.
//

import UIKit


let asyncCellHeight :CGFloat = 34.0


class MCTextAsyncExampleCell: UITableViewCell {

     var async :Bool = false
    let uiLabe :UILabel!
    let yyLabel :YYLabel!
    
    private var dataSource :MCWebImageExampleCellDataSource?
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        uiLabe = UILabel()
        uiLabe.font = UIFont.systemFontOfSize(8)
        uiLabe.numberOfLines = 0
        uiLabe.size = CGSizeMake(UIScreen.mainScreen().bounds.size.width, asyncCellHeight)
        
        yyLabel = YYLabel()
        yyLabel.font = uiLabe.font
        yyLabel.numberOfLines = 0
        yyLabel.size = uiLabe.size
        yyLabel.displaysAsynchronously = true
        yyLabel.hidden = true
        
        
        print("init----style")
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(uiLabe)
        self.contentView.addSubview(yyLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setAyncText(text :AnyObject)
    {
        
        if self.async
        {
            self.yyLabel.layer.contents = nil
            self.yyLabel.textLayout = text as! YYTextLayout
        }
        else
        {
            self.uiLabe.attributedText = text as? NSAttributedString
        }
    }
    
    func setAs (asy :Bool)
    {
        self.async = asy
        self.uiLabe.hidden = asy
        self.yyLabel.hidden = !asy
    }

}
