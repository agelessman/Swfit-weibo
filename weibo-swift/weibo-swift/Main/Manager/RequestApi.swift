//
//  RequestApi.swift
//  weibo-swift
//
//  Created by 马超 on 15/12/11.
//  Copyright © 2015年 马超. All rights reserved.
//

import UIKit

typealias Succeed = (NSURLSessionDataTask!,AnyObject!)->Void
typealias Failure = (NSURLSessionDataTask!,NSError!)->Void

class RequestApi: NSObject {

    //普通get网络请求
    class func GET(url:String!,body:AnyObject?,succeed:Succeed,failed:Failure) {
        let mysucceed:Succeed = succeed
        let myfailure:Failure = failed
        RequestClient.sharedInstance.GET(url, parameters: body, success: { (task:NSURLSessionDataTask?, responseObject:AnyObject?) -> Void in
            mysucceed(task,responseObject)
            
            }) { (task:NSURLSessionDataTask?, error:NSError!) -> Void in
                myfailure(task,error)
        }
    }
    
    //普通post网络请求
    class func POST(url:String!,body:AnyObject?,succeed:Succeed,failed:Failure) {
        let mysucceed:Succeed = succeed
        let myfailure:Failure = failed
        RequestClient.sharedInstance.POST(url, parameters: body, success: { (task:NSURLSessionDataTask?, responseObject:AnyObject?) -> Void in
            mysucceed(task,responseObject)
            
            }) { (task:NSURLSessionDataTask?, error:NSError!) -> Void in
                myfailure(task,error)
        }
    }
}
