//
//  MCSignInhttp.swift
//  weibo-swift
//
//  Created by 马超 on 15/12/11.
//  Copyright © 2015年 马超. All rights reserved.
//

import UIKit

class MCSignInhttp: NSObject {


    //发送签到数据
    class func signInWithParam(param :MCServerBasicParam , success :(MCServerBasicResult? -> Void) ,failure:(NSError! -> Void))
    {
        var paramers :Dictionary<String,String> = Dictionary()
        paramers["client_key"] = "key"
        paramers["client_secret"] = "secret"
        if  (param.ids != nil)
        {
           paramers["ids"] = param.ids
        }
        if  (param.listid != nil)
        {
            paramers["listid"] = param.listid
        }
        if  (param.address != nil)
        {
            paramers["address"] = param.address
        }
        if  (param.lat != nil)
        {
            paramers["lat"] = param.lat
        }
        if  (param.lon != nil)
        {
            paramers["lon"] = param.lon
        }
        if  (param.comfrom != nil)
        {
            paramers["comfrom"] = param.comfrom
        }
        if  (param.machineid != nil)
        {
            paramers["machineid"] = param.machineid
        }

        func succeed(task:NSURLSessionDataTask!,responseObject:AnyObject!)->Void{
            
            print(responseObject)
            let result :MCServerBasicResult = MCServerBasicResult.mj_objectWithKeyValues(responseObject)
            
            if responseObject != nil
            {
                success(result)
            }
        }
        
        func failed(task:NSURLSessionDataTask!,error:NSError!)->Void{
            if error != nil
            {
            }
        }
        let url :String = onlineHttpApi + "/oauth2/" + "registration_add.json?"
        RequestApi.POST(url, body: paramers, succeed: succeed, failed: failed)
        
       
    }
}
