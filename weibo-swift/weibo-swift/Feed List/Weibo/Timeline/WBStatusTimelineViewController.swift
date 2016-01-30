//
//  WBStatusTimelineViewController.swift
//  weibo-swift
//
//  Created by 马超 on 15/12/28.
//  Copyright © 2015年 马超. All rights reserved.
//

import UIKit

class WBStatusTimelineViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,WBStatusCellDelegate {

    var fpsLabel :MCFPSLabel!
    var tableView :UITableView!
    let layouts :NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.view.backgroundColor = UIColor.whiteColor()
        if self.respondsToSelector("setAutomaticallyAdjustsScrollViewInsets:")
        {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        let rightItem = UIBarButtonItem(image: WBStatusHelper.imageNamed("toolbar_compose_highlighted"), style: UIBarButtonItemStyle.Plain, target: self, action: "sendStatus")
        rightItem.tintColor = UIColor(hexString: "fd8224")
        self.navigationItem.rightBarButtonItem = rightItem
        
        
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
        
        
        //异步获取数据
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        dispatch_async(queue, { () -> Void in
        
            for var i = 0 ; i <= 7 ; i++ {
                
                let data = NSData(named: "weibo_\(i).json")
                let item = WBTimelineItem.modelWithJSON(data)

                for status :WBStatus  in item.statuses! as! [WBStatus]  {
                   
                    let layout = WBStatusLayout(status: status, style: WBLayoutStyle.Timeline)

                    self.layouts.addObject(layout)
                }
            }
            
            // 复制一下，让列表长一些，不至于滑两下就到底了
//            self.layouts.addObjectsFromArray(self.layouts as [AnyObject])
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.title = "Weibo (loaded:\(self.layouts.count))"
                indicator.removeFromSuperview()
                self.navigationController?.view.userInteractionEnabled = true
                self.tableView.reloadData()
            })
       
            
        })
     
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
        
        let cellId = "cell"
        var cell :WBStatusCell? = tableView.dequeueReusableCellWithIdentifier(cellId) as? WBStatusCell
        if cell == nil {
            cell = WBStatusCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellId)
            cell?.delegate = self
        }
        return cell!
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
    
    
    //MARK: -----delegate----
    
    func sendStatus() {
        let vc = WBStatusComposeController()
        vc.type = WBStatusComposeViewType.Status
        let nav = UINavigationController(rootViewController: vc)
        vc.dismissFunc = {() ->Void in
            nav.dismissViewControllerAnimated(true, completion: nil)
        }
        
        self.presentViewController(nav, animated: true, completion: nil)
    }
    func cellDidClick(cell: WBStatusCell) {
        
        self.showMessage("该功能暂未开发")
    }
    
    func cellDidClickTag(cell: WBStatusCell) {
        
        let tag = cell.statusView.layout.status?.tagStruct?.firstObject as! WBTag
        let url = tag.tagScheme
        if let _ = url {
            let vc = YYSimpleWebViewController(WithUrl: NSURL(string: url!))
            vc.title = tag.tagName
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func cellDidClickCard(cell: WBStatusCell) {
        
      
        let pageInfo = cell.statusView.layout.status?.pageInfo
        let url = pageInfo?.pageURL
        if let _ = url {
            let vc = YYSimpleWebViewController(WithUrl: NSURL(string: url!))
            vc.title = pageInfo!.pageTitle
            self.navigationController?.pushViewController(vc, animated: true)
        }
   
    }
    
    func cellDidClickLike(cell: WBStatusCell) {
        
        let status = cell.statusView.layout.status
        cell.statusView.toolbarView.setLiked(status?.attitudesStatus == "1" ? false : true, withAnimation: true)
     
    }
    
    func cellDidClickMenu(cell: WBStatusCell) {
        self.showMessage("该功能暂未开发")
    }
    
    func cellDidClickFollow(cell: WBStatusCell) {
        
    }
    
    func cellDidClickRepost(cell: WBStatusCell) {
        let vc = WBStatusComposeController()
        vc.type = WBStatusComposeViewType.Retweet
        let nav = UINavigationController(rootViewController: vc)
        vc.dismissFunc = {() ->Void in
            nav.dismissViewControllerAnimated(true, completion: nil)
        }
        
        self.presentViewController(nav, animated: true, completion: nil)
    }
    
    func cellDidClickComment(cell: WBStatusCell) {
        let vc = WBStatusComposeController()
        vc.type = WBStatusComposeViewType.Comment
        let nav = UINavigationController(rootViewController: vc)
        vc.dismissFunc = {() ->Void in
            nav.dismissViewControllerAnimated(true, completion: nil)
        }
        
        self.presentViewController(nav, animated: true, completion: nil)
        
    }
    
    func cellDidClickRetweet(cell: WBStatusCell) {
        self.showMessage("该功能暂未开发")
    }
    
    func cell(cell: WBStatusCell, didClickUser user: WBUser) {
    
        if Int64(user.userID!) == 0 { return }
        let url = "http://m.weibo.cn/u/\(user.userID!)"

        let vc = YYSimpleWebViewController(WithUrl: NSURL(string: url))
        vc.title = "个人信息"
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func cell(cell: WBStatusCell, didClickImageAtIndex index: Int) {
        
        var fromView: UIView!
         let items = NSMutableArray()
        let status = cell.statusView.layout.status!
        let pics = status.retweetedStatus != nil ? status.retweetedStatus!.pics  : status.pics
        
  
        if pics?.count > 0 {
            
            for var i = 0 ,max = pics!.count ; i < max ; i++ {
                let imageView = cell.statusView.picViews![i]
                let pic = pics![i] as! WBPicture
                let meta: WBPictureMetadata? = (pic.largest!.badgeType == WBPictureBadgeType.WBPictureBadgeTypeGIF ? pic.largest : pic.large)!
                let item = MCPhotoGroupItem()
                item.thumbView = imageView as! YYControl
                item.largeImageURL = meta?.url
                item.largeImageSize = CGSizeMake(CGFloat(Float(meta!.width!)!), CGFloat(Float(meta!.height!)!))
                items.addObject(item)
                if i == index {
                    fromView = imageView as! YYControl
                }
            }
        }
       
        let v = MCPhotoGroupView(items: items)
        v.presentFromImageView(fromView!, toContainer: self.navigationController!.view, animated: true, completion: nil)
   
     
    }
    
    func cell(cell: WBStatusCell, didClickInLabel label: YYLabel, textRange: NSRange) {
        
        let text:NSAttributedString = label.textLayout.text
        if textRange.location > text.length { return }
        
        let highlight = text.attribute(YYTextHighlightAttributeName, atIndex: UInt(textRange.location))
        let info: NSDictionary = highlight.userInfo
        if info.count == 0 { return }
        
        if info[kWBLinkHrefName] != nil {
            let url = info[kWBLinkHrefName] as! String
            let vc = YYSimpleWebViewController(WithUrl: NSURL(string: url))
            self.navigationController?.pushViewController(vc, animated: true)
            return
        }
        
        if info[kWBLinkAtName] != nil {
            let name = info[kWBLinkAtName] as! NSString
          
            if name.length > 0 {
                let na = name.stringByURLEncode()
         
                    let url = "http://m.weibo.cn/n/" + na!
                print(url)
                    let vc = YYSimpleWebViewController(WithUrl: NSURL(string: url))
                    self.navigationController?.pushViewController(vc, animated: true)
            }
            return
        }
        
        if info[kWBLinkTopicName] != nil {
            let topic = info[kWBLinkTopicName] as! WBTopic
            let topicStr = topic.topicTitle! as NSString
            if topicStr.length > 0 {
                let na = topicStr.stringByURLEncode()
                
                let url = "http://m.weibo.cn/k/" + na!
                print(url)
                let vc = YYSimpleWebViewController(WithUrl: NSURL(string: url))
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return
        }
        
        if info[kWBLinkURLName] != nil {
            let url = info[kWBLinkURLName] as! WBURL
            let pic: WBPicture? = url.pics?.firstObject as? WBPicture
            if let _ = pic {
                let attachment = label.textLayout.text.attribute(YYTextAttachmentAttributeName, atIndex: UInt(textRange.location)) as! YYTextAttachment
                if attachment.content.isKindOfClass(UIView.self) {
                    
                    let item: MCPhotoGroupItem = MCPhotoGroupItem()
                    item.largeImageURL = pic!.large?.url
                    item.largeImageSize = CGSizeMake(CGFloat(Float(pic!.large!.width!)!), CGFloat(Float(pic!.large!.height!)!))
                    
                    let v = MCPhotoGroupView(items: [item])
                    v.presentFromImageView(attachment.content as! UIView, toContainer: self.navigationController?.view, animated: true, completion: nil)
                }
            }else if url.oriURL != nil {
                let vc = YYSimpleWebViewController(WithUrl: NSURL(string: url.oriURL!))
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            return
        }
        
       
   
    
    }
    
    //弹窗显示提示
    func showMessage(message :NSString)
    {
        let padding :CGFloat = 10.0
        let label :YYLabel = YYLabel()
        label.text = message as String
        label.textAlignment = NSTextAlignment.Center
        label.font = UIFont.systemFontOfSize(16.0)
        label.textColor = UIColor.whiteColor()
        label.backgroundColor = UIColor(red: 0.033, green: 0.685, blue: 0.978, alpha: 0.730)
        label.width = self.view.width
        label.textContainerInset = UIEdgeInsetsMake(padding, padding, padding, padding)
        label.height = message.heightForFont(label.font, width: label.width) + 2 * padding
        label.bottom = 64
        
        self.view.addSubview(label)
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            
            label.top = 64;
            
            }) { (finished) -> Void in
                
                UIView.animateWithDuration(0.2, delay: 2, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                    
                    label.bottom = 64
                    
                    }, completion: { (finished) -> Void in
                        
                        label.removeFromSuperview()
                        
                })
        }
        
    }
}
