//
//  MCNavController.swift
//  weibo-swift
//
//  Created by 马超 on 15/12/8.
//  Copyright © 2015年 马超. All rights reserved.
//

import UIKit

class MCNavController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }


    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    
    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
        return UIInterfaceOrientation.Portrait
    }
}
