//
//  T1HomeTimelineItemsViewController.swift
//  weibo-swift
//
//  Created by 马超 on 15/12/28.
//  Copyright © 2015年 马超. All rights reserved.
//

import UIKit


class T1HomeTimelineItemsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var fpsLabel :MCFPSLabel!
    var tableView :UITableView!
    let layouts :NSMutableArray = NSMutableArray()
    
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        self.view.backgroundColor = UIColor.whiteColor()
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(white:1.000, alpha: 0.919)


        if self.respondsToSelector("setAutomaticallyAdjustsScrollViewInsets:")
        {
            self.automaticallyAdjustsScrollViewInsets = false
        }

        
        self.initFPSLabel()
        self.initTableView()
        self.initFPSLabel()
        
        
        if UIDevice.systemVersion() < 7 {
            self.fpsLabel.top -= 44
            self.tableView.top -= 64;
            self.tableView.height += 20;
        }
        
        
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        indicator.size = CGSizeMake(80, 80)
        indicator.center = CGPointMake(self.view.width / 2, self.view.height / 2)
        indicator.backgroundColor = UIColor(white: 0.000, alpha: 0.670)
        indicator.clipsToBounds = true
        indicator.layer.cornerRadius = 6
        indicator.startAnimating()
        self.view.addSubview(indicator)
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            
            let layouts = NSMutableArray()
            for var i = 0 ; i <= 3 ; i++ {
                
                let data = NSData(named: "twitter_\(i).json")
                let response = TWAPIRespose.modelWithJSON(data)
                
                if response.timelineItmes?.count > 0 {
                
                    for item in response.timelineItmes! {
                        
                        if item.isKindOfClass(TWTweet.self) {
                            
                            let tweet: TWTweet = item as! TWTweet
                            let layout: TWLayout = TWLayout()
                            layout.tweet = tweet
                            layouts.addObject(layout)
                        }
                    }
                }
                
            }
            
            print(layouts)
        }

       
    }


    func initFPSLabel() {
        self.fpsLabel = MCFPSLabel()
        self.fpsLabel.sizeToFit()
        self.fpsLabel.bottom = self.view.height - CGFloat(kWBCellPadding)
        self.fpsLabel.left = CGFloat(kWBCellPadding)
        self.fpsLabel.alpha = 1
        self.view.addSubview(self.fpsLabel)
    }

    
    func initTableView() {
        
        self.tableView = YYTableView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.frame = self.view.bounds
        self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0)
        self.tableView.scrollIndicatorInsets = self.tableView.contentInset
        self.tableView.backgroundColor = UIColor.clearColor()
        self.view.addSubview(self.tableView)
    }
    

    //MARK:table data delegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.layouts.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        cell.textLabel?.text = "dddd"
        return cell
    }
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if self.layouts.count > 0 {
            let layout = self.layouts[indexPath.row] as! WBStatusLayout
            (cell as! WBStatusCell).setWithLayout(layout)
        }
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if self.layouts.count > 0 {
            let layout = self.layouts[indexPath.row] as! WBStatusLayout
            return CGFloat(layout.height!)
        }else {
            return 0
        }
        
    }
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    
    //MARK: 滚动的代理
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        
        if self.fpsLabel.alpha == 0 {
            
            UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: { () -> Void in
                self.fpsLabel.alpha = 1
                }, completion: nil)
        }
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if !decelerate {
            if self.fpsLabel.alpha != 0 {
                
                UIView.animateWithDuration(1, delay: 2, options: UIViewAnimationOptions.BeginFromCurrentState, animations: { () -> Void in
                    self.fpsLabel.alpha = 0
                    }, completion: nil)
            }
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if self.fpsLabel.alpha != 0 {
            
            UIView.animateWithDuration(1, delay: 2, options: UIViewAnimationOptions.BeginFromCurrentState, animations: { () -> Void in
                self.fpsLabel.alpha = 0
                }, completion: nil)
        }
    }
    
    func scrollViewDidScrollToTop(scrollView: UIScrollView) {
        if self.fpsLabel.alpha == 0 {
            
            UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: { () -> Void in
                self.fpsLabel.alpha = 1
                }, completion: nil)
        }
    }

}
