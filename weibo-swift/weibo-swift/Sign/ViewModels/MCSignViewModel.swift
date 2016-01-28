//
//  MCSignViewModel.swift
//  weibo-swift
//
//  Created by 马超 on 15/12/11.
//  Copyright © 2015年 马超. All rights reserved.
//

import UIKit

class MCSignViewModel: MCBasicViewModel {

    /**
    *  发送签到的数据
    */
    func sendSignToServerWith(param :MCServerBasicParam)
    {
        MCSignInhttp.signInWithParam(param, success: { (result :MCServerBasicResult?) -> Void in
            
            if result?.code == "1"
            {
                if (self.successBlock != nil)
                {
                    self.successBlock!(success: result)
                }
            }else
            {
                if (self.failureBlock != nil)
                {
                    self.failureBlock!(failure: result)
                }
                
            }
            
            }) { (error :NSError!) -> Void in
                if (self.errorBlock != nil)
                {
                    self.errorBlock!(error: error)
                }
        }
    }
}
