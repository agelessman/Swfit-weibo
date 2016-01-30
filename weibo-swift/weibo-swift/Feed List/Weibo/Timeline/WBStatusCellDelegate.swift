//
//  WBStatusCellDelegate.swift
//  weibo-swift
//
//  Created by 马超 on 16/1/9.
//  Copyright © 2016年 马超. All rights reserved.
//

import UIKit

protocol WBStatusCellDelegate  {

    /// 点击了 Cell
    func cellDidClick(cell :WBStatusCell)
    
    /// 点击了 Card
    func cellDidClickCard(cell :WBStatusCell)

    /// 点击了转发内容
    func cellDidClickRetweet(cell :WBStatusCell)

    /// 点击了Cell菜单
    func cellDidClickMenu(cell :WBStatusCell)

    /// 点击了关注
    func cellDidClickFollow(cell :WBStatusCell)

    /// 点击了转发
    func cellDidClickRepost(cell :WBStatusCell)
 
    /// 点击了下方 Tag
    func cellDidClickTag(cell :WBStatusCell)

    /// 点击了评论
    func cellDidClickComment(cell :WBStatusCell)
   
    /// 点击了赞
    func cellDidClickLike(cell :WBStatusCell)

    /// 点击了用户
    func cell(cell :WBStatusCell ,didClickUser user :WBUser )

    /// 点击了图片
    func cell(cell :WBStatusCell ,didClickImageAtIndex index :Int )

    /// 点击了 Label 的链接
    func cell(cell :WBStatusCell ,didClickInLabel label :YYLabel , textRange :NSRange)

}
