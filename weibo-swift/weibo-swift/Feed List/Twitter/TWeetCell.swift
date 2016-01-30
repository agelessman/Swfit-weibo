//
//  TWeetCell.swift
//  weibo-swift
//
//  Created by 马超 on 16/1/30.
//  Copyright © 2016年 马超. All rights reserved.
//

import UIKit

class TWeetCell: UITableViewCell {

 
    var statusView: TWStatusView!
    var layout: TWLayout!
    
    override  init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.statusView = TWStatusView()
        self.contentView.addSubview(self.statusView)
        self.statusView.cell = self
        
        self.contentView.backgroundColor = UIColor.clearColor()
        self.backgroundColor = UIColor.clearColor()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bindLayout(layout: TWLayout) {
        
        self.layout = layout
        self.contentView.height = layout.height
        self.statusView.height = layout.height
        self.statusView.setWithLayout(layout)
    }
}
