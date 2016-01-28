//
//  MCFeedListController.swift
//  weibo-swift
//
//  Created by 马超 on 15/12/28.
//  Copyright © 2015年 马超. All rights reserved.
//

import UIKit

class MCFeedListController: UITableViewController {

    var titles = [String]()
    var classNames = [String]()
    var imageNames = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let a = WBStatusHelper.emoticonGroups()
        let b = WBStatusHelper.emoticonGroups()
        self.title = "微博和Twitter"
        self.addCell("Twitter", className: "T1HomeTimelineItemsViewController", imageName: "Twitter.jpg")
        self.addCell("Weibo", className: "WBStatusTimelineViewController", imageName: "Weibo.jpg")
        self.tableView.reloadData()
        
    }
    
    func addCell(title :String , className:String ,imageName :String){
        self.titles.append(title)
        self.classNames.append(className)
        self.imageNames.append(imageName)
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
        
        if className == "T1HomeTimelineItemsViewController"
        {
            let modelVc :T1HomeTimelineItemsViewController = T1HomeTimelineItemsViewController()
            modelVc.title = self.titles[indexPath.row];
            self.navigationController?.pushViewController(modelVc, animated: true)
        }
        if className == "WBStatusTimelineViewController"
        {
            let modelVc :WBStatusTimelineViewController = WBStatusTimelineViewController()
            modelVc.title = self.titles[indexPath.row];
            self.navigationController?.pushViewController(modelVc, animated: true)
        }
    }
    


}
