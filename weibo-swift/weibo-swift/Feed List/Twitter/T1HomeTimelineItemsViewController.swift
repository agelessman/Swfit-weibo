//
//  T1HomeTimelineItemsViewController.swift
//  weibo-swift
//
//  Created by 马超 on 15/12/28.
//  Copyright © 2015年 马超. All rights reserved.
//

import UIKit


class T1HomeTimelineItemsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,TWStatusCellDelegate {

    var fpsLabel :MCFPSLabel!
    var tableView :UITableView!
    var layouts :NSMutableArray = NSMutableArray()
    
    
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
                        }else if item.isKindOfClass(TWConversation.self){
                            
                            let conv = item as! TWConversation
                            let convLayouts = NSMutableArray()
                            
                            for tw in conv.tweets! as! [TWTweet] {
                                
                                let la = TWLayout()
                                la.conversation = conv
                                la.tweet = tw
                                convLayouts.addObject(la)
                            }
                            
                            if conv.targetCount != nil && Float(conv.targetCount!) > 0 && convLayouts.count >= 2 {
                                let laa = TWLayout()
                                laa.conversation = conv
                                laa .layout()
                                convLayouts.insertObject(laa, atIndex: 1)
                            }
                            layouts.addObjectsFromArray(convLayouts as [AnyObject])
                        }
                    }
                }
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    self.title = "Tweet (loaded:\(layouts.count))"
                    indicator.removeFromSuperview()
                    self.navigationController?.view.userInteractionEnabled = true
                    self.layouts = layouts
                    self.tableView.reloadData()
                })
                
            }
            
            
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
        
        let cellId = "twcell"
        var cell :TWeetCell? = tableView.dequeueReusableCellWithIdentifier(cellId) as? TWeetCell
        if cell == nil {
            cell = TWeetCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellId)
            cell!.delegate = self
        }
        return cell!
    }
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if self.layouts.count > 0 {
            let layout = self.layouts[indexPath.row] as! TWLayout
            (cell as! TWeetCell).bindLayout(layout)
        }
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if self.layouts.count > 0 {
            let layout = self.layouts[indexPath.row] as! TWLayout
            return layout.height
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
    
    
    
    //MARK: --------------  点击了头像的代理  ----------------
    func cell(cell: TWeetCell, didClickAvatarWithLongPress longPress: Bool) {
        
        self.showMessage("点击了头像，该功能尚未开发！")
        
    }
    

    
    //MARK:----------------  点击了自身的代理  ---------------
    func cell(cell: TWeetCell, didClickContentWithLongPress longPress: Bool) {
        
        self.showMessage("点击了我，该功能尚未开发！")
        
    }
    
    
    
    //MARK: --------------- 点击了图片的代理 ------------------
    func cell(cell: TWeetCell, didClickImageAtIndex index: Int, withLongPress longPress: Bool) {
        
        if (longPress) {
            
            let sheet = UIAlertController(title: "您长按了第\(index)张图片", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
            
            let action0 = UIAlertAction(title: "保存到相册", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                
                print("保存到相册")
                
            })
            
            let action1 = UIAlertAction(title: "分享到朋友圈", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                
                print("分享到朋友圈")
                
            })
            
            let action2 = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: { (action) -> Void in
                
                print("取消")
                
            })
            
            sheet.addAction(action0)
            sheet.addAction(action1)
            sheet.addAction(action2)
            self.presentViewController(sheet, animated: true, completion: nil)
            
            return;
        }
        
        var fromView: UIView!
        let items = NSMutableArray()
        let images: NSArray? = cell.layout.images
        
        if images?.count > 0 {
            
            for var i = 0 ,max = images!.count ; i < max ; i++ {
                let imageView = cell.statusView.mediaView.imageViews[i]
                let pic = images![i] as! TWMedia
                let item = MCPhotoGroupItem()
                item.thumbView = imageView as? UIView
                item.largeImageURL = pic.mediaLarge!.url
                item.largeImageSize = pic.mediaLarge!.size
                items.addObject(item)
                if i == index {
                    fromView = imageView as! UIView
                }
            }
        }
        
        let v = MCPhotoGroupView(items: items)
        v.presentFromImageView(fromView!, toContainer: self.navigationController!.view, animated: true, completion: nil)
    }

    
    
    //MARK: --------------- 点击了quote --------------
    func cell(cell: TWeetCell, didClickQuoteWithLongPress longPress: Bool) {
        
        self.showMessage("点击了quote，该功能尚未开发")
        
    }
    
    
    //MARK: --------------- 点击了reply ---------------
    func cellDidClickReply(cell: TWeetCell) {
        
    }
    
    
    
    //MARK: ---------------- 点击了转发 ----------------
    func cellDidClickRetweet(cell: TWeetCell) {
        
        let layout = cell.layout
        let tw = layout.displayedTweet
        if tw.retweeted == "1" {
            
            tw.retweeted = "0"
            if tw.retweetCount != nil && Int(tw.retweetCount!) > 0 {
                
                var tempCount = Int(tw.retweetCount!)!
                tempCount--
                tw.retweetCount = String(tempCount)
            
                layout.retweetCountTextLayout = layout.retweetCountTextLayoutForTweet(tw)
            }
            
        }else {
            
            tw.retweeted = "1"
            if tw.retweetCount != nil  {
                
                var tempCount = Int(tw.retweetCount!)!
                tempCount++
                tw.retweetCount = String(tempCount)
                
                layout.retweetCountTextLayout = layout.retweetCountTextLayoutForTweet(tw)
            }
            
        }
        
        cell.statusView.inlineActionsView.updateRetweetWithAnimation()

    }
    
    //MARK: ---------------- 点击了关注 ---------------
    func cellDidClickFollow(cell: TWeetCell) {
     
        let layout = cell.layout
        let tw = layout.displayedTweet
        tw.user?.following = tw.user?.following == "1" ? "0" : "1"
        cell.statusView.inlineActionsView.updateFollowWithAnimation()
        
    }
    
    
    //MARK: --------------- 点击了赞 ---------------
    func cellDidClickFavorite(cell: TWeetCell) {
        
        
        let layout = cell.layout
        let tw = layout.displayedTweet
        if tw.favorited == "1" {
            
            tw.favorited = "0"
            if tw.favoriteCount != nil && Int(tw.favoriteCount!) > 0 {
                
                var tempCount = Int(tw.favoriteCount!)!
                tempCount--
                tw.favoriteCount = String(tempCount)
                
                layout.favoriteCountTextLayout = layout.favoriteCountTextLayoutForTweet(tw)
            }
            
        }else {
            
            tw.favorited = "1"
            if tw.favoriteCount != nil  {
                
                var tempCount = Int(tw.favoriteCount!)!
                tempCount++
                tw.favoriteCount = String(tempCount)
                
                layout.favoriteCountTextLayout = layout.favoriteCountTextLayoutForTweet(tw)
            }
            
        }
        
        cell.statusView.inlineActionsView.updateFavouriteWithAnimation()
        
    }
    
    
    //MARK: --------------  点击了文本高亮  ------------------
    func cell(cell: TWeetCell, didClickInLabel label: YYLabel, textRange: NSRange) {
        
        let highlight = label.textLayout.text.attribute(YYTextHighlightAttributeName, atIndex: UInt(textRange.location)) as? YYTextHighlight
        
        if let _ = highlight {
            
            let info = highlight!.userInfo as NSDictionary
            
            var link: NSURL?
            var linkTitle: String?
            
            if let _ = info["TWURL"] {
                
                let url = info["TWURL"] as! TWURL
                if url.expandedURL != nil {
                    
                    link = NSURL(string: url.expandedURL!)
                    linkTitle = url.displayURL
                }
            }else if let _ = info["TWMedia"] {
                
                let media = info["TWMedia"] as! TWMedia
                if media.expandedURL != nil {
                    
                    link = NSURL(string: media.expandedURL!)
                    linkTitle = media.displayURL
                }
            }
            
            if let _ = link {
                
                let vc = YYSimpleWebViewController(WithUrl: link!)
                vc.title = linkTitle
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
        }

        
    }

    //MARK: --------------   显示头部标签的的点击事件    ----------------
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
