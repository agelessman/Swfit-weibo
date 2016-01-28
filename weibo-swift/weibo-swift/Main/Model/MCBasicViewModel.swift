//
//  MCBasicViewModel.swift
//  weibo-swift
//
//  Created by 马超 on 15/12/11.
//  Copyright © 2015年 马超. All rights reserved.
//

import UIKit


typealias SuccessBlock = (success :AnyObject?) ->Void
typealias FailureBlock = (failure :AnyObject?) ->Void
typealias ErrorBlock = (error :AnyObject?) ->Void
//
enum LoadType{
    case LoadTypeNew //加载最新
    case LoadTypeMore //加载更多
    case LoadTypeSearch //加载搜索的数据
}
class MCBasicViewModel: NSObject {
    
    var successBlock :SuccessBlock?
    var failureBlock :FailureBlock?
    var errorBlock :ErrorBlock?

    func setBlockWithSusscessBlock(susscessBlock :SuccessBlock , failureBlock :FailureBlock ,errorBlock :ErrorBlock)
    {
        self.successBlock = susscessBlock
        self.failureBlock = failureBlock;
        self.errorBlock = errorBlock;
    }
}
