//
//  MCModelExample.swift
//  weibo-swift
//
//  Created by 马超 on 15/12/9.
//  Copyright © 2015年 马超. All rights reserved.
//

import UIKit


class MCModelExample:UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad() 

        self.view.backgroundColor = UIColor.whiteColor()
        

    }

    //打开视频获取的回调，通过代理传过来的
    func MessageResponse(ret: String!, type strType: String!, returnData retData: NSObject!) {
        
    }
    
    func have() {
        
    }
    //创建一个label
    func initLable()
    {
        let label :UILabel = UILabel()
        label.text = "马超创建的控件，这个控制器初始化模型"
        self.view.addSubview(label)
        label.left = 0
        label.centerY = self.view.centerY
        label.width = self.view.width
        label.height = 20
        label.textAlignment = NSTextAlignment.Center
    }

}
