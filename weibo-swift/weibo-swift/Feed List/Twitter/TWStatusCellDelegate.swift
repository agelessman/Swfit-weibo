//
//  TWStatusCellDelegate.swift
//  weibo-swift
//
//  Created by 马超 on 16/2/6.
//  Copyright © 2016年 马超. All rights reserved.
//

import UIKit


protocol TWStatusCellDelegate {
    
    ///
    func cellDidClickFavorite(cell :TWeetCell)
    
    ///
    func cellDidClickFollow(cell :TWeetCell)
    
    ///
    func cellDidClickRetweet(cell :TWeetCell)
    
    ///
    func cellDidClickReply(cell :TWeetCell)
    
    ///
    func cell(cell :TWeetCell ,didClickContentWithLongPress longPress :Bool )

    
    ///
    func cell(cell :TWeetCell ,didClickAvatarWithLongPress longPress :Bool )

    
    ///
    func cell(cell :TWeetCell ,didClickQuoteWithLongPress longPress :Bool )
    
    /// 点击了图片
    func cell(cell :TWeetCell ,didClickImageAtIndex index :Int ,withLongPress longPress: Bool)

    /// 点击了 Label 的链接
    func cell(cell :TWeetCell ,didClickInLabel label :YYLabel , textRange :NSRange)
}
