//
//  MCImageListController.swift
//  weibo-swift
//
//  Created by 马超 on 15/12/16.
//  Copyright © 2015年 马超. All rights reserved.
//

import UIKit

class MCImageListController: UITableViewController {

    var titles = [String]()
    var classNames = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "图片的特殊处理"
        
        self.addCell("Animated Image", className: "MCImageDisplayExample")
        self.addCell("Progressive Image", className: "MCImageProgressiveExample")
        self.addCell("Web Image", className: "MCWebImageExample")
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

        if className == "MCImageDisplayExample"
        {
            let modelVc :MCImageDisplayExample = MCImageDisplayExample()
            modelVc.title = self.titles[indexPath.row];
            self.navigationController?.pushViewController(modelVc, animated: true)
        }
        if className == "MCImageProgressiveExample"
        {
            let modelVc :MCImageProgressiveExample = MCImageProgressiveExample()
            modelVc.title = self.titles[indexPath.row];
            self.navigationController?.pushViewController(modelVc, animated: true)
        }
        if className == "MCWebImageExample"
        {
            let modelVc :MCWebImageExample = MCWebImageExample()
            modelVc.title = self.titles[indexPath.row];
            self.navigationController?.pushViewController(modelVc, animated: true)
        }
    }
    
    

}
