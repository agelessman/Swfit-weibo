//
//  MCTextExampleHelper.swift
//  weibo-swift
//
//  Created by 马超 on 15/12/22.
//  Copyright © 2015年 马超. All rights reserved.
//

import UIKit

var DebugEnabled :Bool = false

class MCTextExampleHelper: NSObject {

    class func addDebugOptionToViewController(vc :UIViewController)
    {
        let switcher :UISwitch = UISwitch()
        switcher.layer.transformScale = 0.8
        
        switcher.on = DebugEnabled
        switcher.addBlockForControlEvents(UIControlEvents.ValueChanged) { (sender  ) -> Void in
            
            let sen = sender as! UISwitch
            self.setDebug(sen.on)
        }
        
        let view :UIView = UIView()
        view.size = CGSizeMake(40, 44)
        view.addSubview(switcher)
        switcher.centerX = view.width / 2
        switcher.centerY = view.height / 2
        
        let item :UIBarButtonItem = UIBarButtonItem(customView: view)
        vc.navigationItem.rightBarButtonItem = item
        
    }
    
    
    class func setDebug(debug :Bool)
    {
        let debugOptions :YYTextDebugOption = YYTextDebugOption()
        if debug
        {
            debugOptions.baselineColor = UIColor.redColor()
            debugOptions.CTFrameBorderColor = UIColor.redColor()
            debugOptions.CTLineFillColor = UIColor(red: 0.000, green: 0.463, blue: 1.000, alpha: 0.180)
            debugOptions.CGGlyphBorderColor = UIColor(red: 1.000, green: 0.524, blue: 0.000, alpha: 0.200)
        }
        else
        {
            debugOptions.clear()
        }
        
        YYTextDebugOption.setSharedDebugOption(debugOptions)
        
        DebugEnabled = debug
        
    }
    
    
    class func isDebug() -> Bool
    {
        return DebugEnabled
    }
}
