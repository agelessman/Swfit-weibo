//
//  AppDelegate.swift
//  weibo-swift
//
//  Created by 马超 on 15/12/8.
//  Copyright © 2015年 马超. All rights reserved.
//

import UIKit


let suikanAppkey = "123456"
var suikanInitOk :Bool = false


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var rootViewController:MCNavController?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
//        //初始化随看
//        let ret  = SuicamSDK.RegistApp(suikanAppkey)
//        if ret == 0
//        {
//            suikanInitOk = true
//        }
        
        let root :MCRootController = MCRootController()
        let nav :MCNavController = MCNavController()
        if nav.respondsToSelector("setAutomaticallyAdjustsScrollViewInsets:")
        {
            nav.automaticallyAdjustsScrollViewInsets = false
        }
        nav.pushViewController(root, animated: false)
        
        self.rootViewController = nav
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.rootViewController = self.rootViewController!
        self.window?.backgroundColor = UIColor.whiteColor()
        self.window?.makeKeyAndVisible()
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

