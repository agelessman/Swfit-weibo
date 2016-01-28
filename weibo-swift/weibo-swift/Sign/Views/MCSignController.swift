//
//  MCSignController.swift
//  weibo-swift
//
//  Created by 马超 on 15/12/10.
//  Copyright © 2015年 马超. All rights reserved.
//

import UIKit


class MCSignController: UIViewController {

    let viewModel :MCSignViewModel = MCSignViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.whiteColor()
        
        self.initSignButton()
        
        self.viewModel.setBlockWithSusscessBlock({ (success) -> Void in
            
            //成功后，弹出提示
            let alert :UIAlertController = UIAlertController(title: "提示", message: "成功", preferredStyle: UIAlertControllerStyle.Alert)
            let action :UIAlertAction = UIAlertAction(title: "ok", style: UIAlertActionStyle.Default, handler: { (action :UIAlertAction) -> Void in
                
            })
            alert.addAction(action)
            UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
            
            }, failureBlock: { (failure ) -> Void in
                let fa :MCServerBasicResult = failure as! MCServerBasicResult
                //成功后，弹出提示
                let alert :UIAlertController = UIAlertController(title: "提示", message: fa.msg, preferredStyle: UIAlertControllerStyle.Alert)
                let action :UIAlertAction = UIAlertAction(title: "ok", style: UIAlertActionStyle.Default, handler: { (action :UIAlertAction) -> Void in
                    
                })
                alert.addAction(action)
                UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
                
                
            }) { (error) -> Void in
                
        }
    
       
        
    }
    
    func signToServer()
    {
        let param :MCServerBasicParam = MCServerBasicParam()
        param.ids = "1338"
        param.listid = "13"
        param.comfrom = "2"
        param.address = "后永康胡同17号"
        param.lat = "39.944683"
        param.lon = "116.421807"
        let deviceid = UIDevice.currentDevice().identifierForVendor?.UUIDString
        param.machineid = deviceid
        self.viewModel.sendSignToServerWith(param)
    }

    
    func initSignButton()
    {
        let sign :UIButton = UIButton()
        sign.setTitle("点我", forState: UIControlState.Normal)
        sign.backgroundColor = UIColor.orangeColor()
        sign.addTarget(self, action: "signAction", forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(sign)
        sign.width = 100
        sign.height = 40
        sign.centerY = self.view.centerY
        sign.centerX = self.view.width * 0.5 
        
    }

    
    //MARK:------ action-----
    func signAction()
    {
        let pwdView :ZSDPaymentView = ZSDPaymentView()
        pwdView.title = "请输入密码"
        pwdView.goodsName = "必须输入"
        pwdView.show()
        pwdView.yes = { () -> Void in
            
            self.signToServer()
        }
 
    }
}
