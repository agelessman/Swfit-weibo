//
//  MCRootController.swift
//  weibo-swift
//
//  Created by 马超 on 15/12/8.
//  Copyright © 2015年 马超. All rights reserved.
//

import UIKit

class MCRootController: UITableViewController {

    var titles = [String]()
    var classNames = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

     
//        var path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).first!
//        path     = path.stringByAppendingString("/com.ibireme.yykit")
//        path     = path.stringByAppendingString("/images")
//        
//        if NSFileManager.defaultManager().fileExistsAtPath(path) {
//            
//            let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
//            dispatch_async(queue, { () -> Void in
//                do {
//                  try NSFileManager.defaultManager().removeItemAtPath(path)
//                }catch
//                {
//                }
//                
//            })
//        }

        
        let  s: NSRange = NSMakeRange(0, 1)
        let  at = UnsafeMutablePointer<NSRange>.alloc(100)
        at .memory = s
        let b = NSMakeRange(33, 33)
        at.memory = b
        print(at.memory)
        
        let cache = YYWebImageManager.sharedManager().cache
        cache.memoryCache.removeAllObjects()
        cache.diskCache.removeAllObjects()

        self.title = "马超演示的首页"
        
        self.addCell("Sign", className: "MCSignController")
        self.addCell("Model", className: "MCModelExample")
        self.addCell("Image", className: "MCImageListController")
        self.addCell("Text", className: "MCTextExampleController")
        self.addCell("Feed List Demo", className: "MCFeedListController")
        self.tableView.reloadData()
        
    }

    func addCell(title :String , className:String){
        self.titles.append(title)
        self.classNames.append(className)
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titles.count
    }

    // MARK: - table view delegate
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell :UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("MC")
        if cell == nil
        {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "MC")
        }
        cell?.textLabel?.text = self.titles[indexPath.row]
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let className :String = self.classNames[indexPath.row]
        if className == "MCModelExample"
        {
            let modelVc :MCModelExample = MCModelExample()
            modelVc.title = self.titles[indexPath.row];
            self.navigationController?.pushViewController(modelVc, animated: true)
        }
        if className == "MCSignController"
        {
            let modelVc :MCSignController = MCSignController()
            modelVc.title = self.titles[indexPath.row];
            self.navigationController?.pushViewController(modelVc, animated: true)
        }
        if className == "MCImageListController"
        {
            let modelVc :MCImageListController = MCImageListController()
            modelVc.title = self.titles[indexPath.row];
            self.navigationController?.pushViewController(modelVc, animated: true)
        }
        if className == "MCTextExampleController"
        {
            let modelVc :MCTextExampleController = MCTextExampleController()
            modelVc.title = self.titles[indexPath.row];
            self.navigationController?.pushViewController(modelVc, animated: true)
        }
        if className == "MCFeedListController"
        {
            let modelVc :MCFeedListController = MCFeedListController()
            modelVc.title = self.titles[indexPath.row];
            self.navigationController?.pushViewController(modelVc, animated: true)
        }
    }
   
    
    

}
