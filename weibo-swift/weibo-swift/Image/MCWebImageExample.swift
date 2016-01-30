//
//  MCWebImageExample.swift
//  weibo-swift
//
//  Created by 马超 on 15/12/16.
//  Copyright © 2015年 马超. All rights reserved.
//

import UIKit

let kcellHeight = ceil(UIScreen.mainScreen().bounds.size.width * 3.0 / 4.0)

class MCWebImageExample: UITableViewController {

    var imageurls  = Array <String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.view.backgroundColor = UIColor.whiteColor()
        
        let rigntItem :UIBarButtonItem = UIBarButtonItem(title: "刷新", style: UIBarButtonItemStyle.Plain, target: self, action: "reload")
        self.navigationItem.rightBarButtonItem = rigntItem
        self.view.backgroundColor = UIColor(white: 0.217, alpha: 1.000)
        
        
        imageurls = [
            /*
            You can add your image url here.
            */
            
            // progressive jpeg
            "https://s-media-cache-ak0.pinimg.com/1200x/2e/0c/c5/2e0cc5d86e7b7cd42af225c29f21c37f.jpg",
            
            // animated gif: http://cinemagraphs.com/
            "http://i.imgur.com/uoBwCLj.gif",
            "http://i.imgur.com/8KHKhxI.gif",
            "http://i.imgur.com/WXJaqof.gif",
            
            // animated gif: https://dribbble.com/markpear
            "https://d13yacurqjgara.cloudfront.net/users/345826/screenshots/1780193/dots18.gif",
            "https://d13yacurqjgara.cloudfront.net/users/345826/screenshots/1809343/dots17.1.gif",
            "https://d13yacurqjgara.cloudfront.net/users/345826/screenshots/1845612/dots22.gif",
            "https://d13yacurqjgara.cloudfront.net/users/345826/screenshots/1820014/big-hero-6.gif",
            "https://d13yacurqjgara.cloudfront.net/users/345826/screenshots/1819006/dots11.0.gif",
            "https://d13yacurqjgara.cloudfront.net/users/345826/screenshots/1799885/dots21.gif",
            
            // animaged gif: https://dribbble.com/jonadinges
            "https://d13yacurqjgara.cloudfront.net/users/288987/screenshots/2025999/batman-beyond-the-rain.gif",
            "https://d13yacurqjgara.cloudfront.net/users/288987/screenshots/1855350/r_nin.gif",
            "https://d13yacurqjgara.cloudfront.net/users/288987/screenshots/1963497/way-back-home.gif",
            "https://d13yacurqjgara.cloudfront.net/users/288987/screenshots/1913272/depressed-slurp-cycle.gif",
            
            // jpg: https://dribbble.com/snootyfox
            "https://d13yacurqjgara.cloudfront.net/users/26059/screenshots/2047158/beerhenge.jpg",
            "https://d13yacurqjgara.cloudfront.net/users/26059/screenshots/2016158/avalanche.jpg",
            "https://d13yacurqjgara.cloudfront.net/users/26059/screenshots/1839353/pilsner.jpg",
            "https://d13yacurqjgara.cloudfront.net/users/26059/screenshots/1833469/porter.jpg",
            "https://d13yacurqjgara.cloudfront.net/users/26059/screenshots/1521183/farmers.jpg",
            "https://d13yacurqjgara.cloudfront.net/users/26059/screenshots/1391053/tents.jpg",
            "https://d13yacurqjgara.cloudfront.net/users/26059/screenshots/1399501/imperial_beer.jpg",
            "https://d13yacurqjgara.cloudfront.net/users/26059/screenshots/1488711/fishin.jpg",
            "https://d13yacurqjgara.cloudfront.net/users/26059/screenshots/1466318/getaway.jpg",
            
            // animated webp and apng: http://littlesvr.ca/apng/gif_apng_webp.html
            "http://littlesvr.ca/apng/images/BladeRunner.png",
            "http://littlesvr.ca/apng/images/Contact.webp",
            
           ]
        
        self.tableView.reloadData()
        self.scrollViewDidScroll(self.tableView)
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Default
        self.navigationController?.navigationBar.tintColor = nil
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
    }

 
    func reload()
    {
        YYImageCache.sharedCache().memoryCache.removeAllObjects()
        YYImageCache.sharedCache().diskCache.removeAllObjectsWithBlock(nil)
        self.tableView.performSelector(Selector("reloadData"), afterDelay: 0.1)
    }
    
    
    override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    override func  tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.imageurls.count * 4
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return kcellHeight
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell :MCWebImageExampleCell? = tableView.dequeueReusableCellWithIdentifier("cell") as? MCWebImageExampleCell
        if cell == nil
        {
            cell = MCWebImageExampleCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        }
        
        let index = indexPath.row % self.imageurls.count
        cell?.configure(NSURL(string: self.imageurls[index]))
        return cell!
    }
    
    
    override func scrollViewDidScroll(scrollView :UIScrollView)
    {
        
        let viewHeight :CGFloat = scrollView.height + scrollView.contentInset.top
        
        let array :NSArray = self.tableView.visibleCells
        
        for var i = 0 ; i < array.count ; i++
        {
            let cell :MCWebImageExampleCell = array[i] as! MCWebImageExampleCell
            let y :CGFloat = cell.centerY - scrollView.contentOffset.y
            let p :CGFloat = y - viewHeight / 2
            let scale :CGFloat = CGFloat(cos(p / viewHeight * 0.8)) * 0.95
            
            UIView.animateWithDuration(0.15, delay: 0, options: [UIViewAnimationOptions.CurveEaseInOut,UIViewAnimationOptions.AllowUserInteraction,UIViewAnimationOptions.BeginFromCurrentState], animations: { () -> Void in
                
                cell.webImageView.transform = CGAffineTransformMakeScale(scale, scale)
                }, completion: nil)
            
        }
    }
    

}
