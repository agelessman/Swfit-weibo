//
//  WBStatusCell.swift
//  weibo-swift
//
//  Created by 马超 on 16/1/9.
//  Copyright © 2016年 马超. All rights reserved.
//

import UIKit


class WBStatusCell: YYTableViewCell {

    var delegate :WBStatusCellDelegate!
    var statusView :WBStatusView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.statusView = WBStatusView()
        self.statusView.cell = self
        self.statusView.titleView!.cell = self
        self.statusView.profileView.cell = self
        self.statusView.cardView!.cell = self
        self.statusView.toolbarView.cell = self
        self.statusView.tagView!.cell = self
        self.contentView.addSubview(self.statusView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setWithLayout(layout :WBStatusLayout) {
        
        self.height = CGFloat(layout.height!)
        self.contentView.height = CGFloat(layout.height!)
        self.statusView.setWithLayout(layout)
    }
}
