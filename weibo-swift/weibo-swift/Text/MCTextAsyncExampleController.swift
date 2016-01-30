//
//  MCTextAsyncExampleController.swift
//  weibo-swift
//
//  Created by 马超 on 15/12/22.
//  Copyright © 2015年 马超. All rights reserved.
//

import UIKit

class MCTextAsyncExampleController: UIViewController ,UITableViewDelegate,UITableViewDataSource{

    var async :Bool  = false
    var tableView :UITableView!
    var strings :NSMutableArray = NSMutableArray()
    var layouts :NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        
        tableView = UITableView()
        tableView.frame = self.view.frame
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(MCTextAsyncExampleCell.self, forCellReuseIdentifier: "id")
        self.view.addSubview(tableView)
        
        
        let stringM = NSMutableArray()
        let layoutM = NSMutableArray()
        for var i = 0 ; i < 300 ; i++
        {
            let str = NSString(format: "%d  Async Display Test ✺◟(∗❛ัᴗ❛ั∗)◞✺ ✺◟(∗❛ัᴗ❛ั∗)◞✺ 😀😖😐😣😡🚖🚌🚋🎊💖💗💛💙🏨🏦🏫 Async Display Test ✺◟(∗❛ัᴗ❛ั∗)◞✺ ✺◟(∗❛ัᴗ❛ั∗)◞✺ 😀😖😐😣😡🚖🚌🚋🎊💖💗💛💙🏨🏦🏫", i)
            
            let text = NSMutableAttributedString(string: str as String)
            text.font = UIFont.systemFontOfSize(10)
            text.lineSpacing = 0
            text.strokeWidth = (-3)
            text.strokeColor = UIColor.redColor()
            text.lineHeightMultiple = 1
            text.maximumLineHeight = 12
            text.minimumLineHeight = 12
            
            
            stringM.addObject(text)
            
            
            let container = YYTextContainer(size: CGSizeMake(UIScreen.mainScreen().bounds.size.width , asyncCellHeight))
            let layout = YYTextLayout(container: container, text: text)
            
            layoutM.addObject(layout)
            
        }
        
        self.strings = stringM
        self.layouts = layoutM
        
        
        
        let toolbar = UIToolbar()
        toolbar.size = CGSizeMake(self.view.width, 40)
        toolbar.top = 64
        self.view.addSubview(toolbar)
        
        
       //添加显示fps
        let fps = MCFPSLabel()
        fps.left = 5
        fps.centerY = toolbar.height / 2
//        fps.size = CGSizeMake(55, 20)
        toolbar.addSubview(fps)
        
        
        let label = UILabel()
        label.backgroundColor = UIColor.clearColor()
        label.font = UIFont.systemFontOfSize(14)
        label.text = "UILabel/YYLabel(Async): "
        label.centerY = toolbar.height / 2
        label.left = fps.right + 10
        label.sizeToFit()
        toolbar.addSubview(label)
        
        let switcher = UISwitch()
        switcher.sizeToFit()
        switcher.centerY = toolbar.height / 2
        switcher.left = label.right + 10
        switcher.layer.transformScale = 0.7
        switcher.addBlockForControlEvents(UIControlEvents.ValueChanged) { (sender) -> Void in
            
            let sw = sender as! UISwitch
            self.setsync(sw.on)
        }
        toolbar.addSubview(switcher)
        
        
        
        
        
    }
    
    func setsync(async :Bool)
    {
        self.async = async
        for var i = 0 ; i < self.tableView.visibleCells.count ; i++
        {
            let cell = self.tableView.visibleCells[i] as! MCTextAsyncExampleCell
            cell.setAs(async)
            
            let indexPath = self.tableView.indexPathForCell(cell)
            if self.async
            {
                cell.setAyncText(self.layouts[indexPath!.row])
            }else
            {
                cell.setAyncText(self.strings[indexPath!.row])
            }
        }
    
    }
    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.strings.count
    }
    
     func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
         return asyncCellHeight
    }
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell :MCTextAsyncExampleCell = tableView.dequeueReusableCellWithIdentifier("id", forIndexPath: indexPath) as! MCTextAsyncExampleCell
        
        cell.async = self.async
        if self.async
        {
            cell.setAyncText(self.layouts[indexPath.row])
        }else
        {
            cell.setAyncText(self.strings[indexPath.row])
        }
        
        return cell
    }

    

}
