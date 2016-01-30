//
//  WBEmoticonInputView.swift
//  weibo-swift
//
//  Created by 马超 on 16/1/25.
//  Copyright © 2016年 马超. All rights reserved.
//

import UIKit



class WBEmoticonCell: UICollectionViewCell {
    
    var _emoticon: WBEmoticon?
    
    var emoticon: WBEmoticon?{
        set {
            self._emoticon = newValue
            self.updateContent()
        }
        get {
            return self._emoticon
        }
    }
    
    var _isDelete: Bool = false
    var isDelete: Bool  {
        set {
            self._isDelete = newValue
            self.updateContent()
        }
        get {
           return self._isDelete
        }
    }
    var imageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.imageView = UIImageView()
        self.imageView.size = CGSizeMake(32, 32)
        self.imageView.contentMode = UIViewContentMode.ScaleAspectFill
        self.contentView.addSubview(self.imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.updateLayout()
    }
    
    func updateContent() {
        
        self.imageView.cancelCurrentImageRequest()
        self.imageView.image = nil
        if self.isDelete {
            self.imageView.image = WBStatusHelper.imageNamed("compose_emotion_delete")
        }else if self.emoticon != nil {
            if self.emoticon!.emo_type == WBEmoticonType.WBEmoticonTypeEmoji {
                
                let num = NSNumber(string: self.emoticon!.code!)
                let str = NSString(UTF32Char: num.unsignedIntValue)
                if let _ = str {
                    self.imageView.image = UIImage(emoji: str! as String, size: self.imageView.width)
                }
            }else if self.emoticon!.group?.groupID != nil && self.emoticon!.png != nil {
                
                var pngPath = WBStatusHelper.emoticonBundle().pathForScaledResource(self.emoticon!.png!, ofType: nil, inDirectory: self.emoticon!.group!.groupID!)
                if pngPath == nil {
                    
                    let addBundlePath = WBStatusHelper.emoticonBundle().bundlePath + "/additional"
                   let addBundle = NSBundle(path: addBundlePath)
                    
                  pngPath = addBundle?.pathForScaledResource(self.emoticon!.png, ofType: nil, inDirectory: self.emoticon!.group!.groupID!)
                 
                }
                if let _ = pngPath {
                    self.imageView.setImageWithURL(NSURL(fileURLWithPath: pngPath), options: YYWebImageOptions.IgnoreDiskCache)
                }
            }
        }
    }
    
    func updateLayout() {
        self.imageView.center = CGPointMake(self.width / 2, self.height / 2)
    }
}

protocol WBEmoticonScrollViewDelegate: UICollectionViewDelegate {
    func emoticonScrollViewDidTapCell(cell: WBEmoticonCell?)
}

class WBEmoticonScrollView: UICollectionView {
    
    var touchBeganTime: NSTimeInterval?
    var touchMoved: Bool = false
    var magnifier: UIImageView!
    var magnifierContent: UIImageView!
    var currentMagnifierCell: WBEmoticonCell?
    var backspaceTimer: NSTimer?
    

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        
        super.init(frame: frame, collectionViewLayout: layout)
        self.backgroundColor = UIColor.clearColor()
        self.backgroundView = UIView()
        self.pagingEnabled = true
        self.showsHorizontalScrollIndicator = false
        self.clipsToBounds = false
        self.canCancelContentTouches = false
        self.multipleTouchEnabled = false
        
        self.magnifier = UIImageView(image: WBStatusHelper.imageNamed("emoticon_keyboard_magnifier"))
          self.magnifierContent = UIImageView()
        self.magnifierContent.size = CGSizeMake(40, 40)
        self.magnifierContent.centerX = self.magnifier.width / 2
        self.magnifier.addSubview(self.magnifierContent)
        self.magnifier.hidden = true
        self.addSubview(self.magnifier)

        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.touchMoved = false
        let cell = self.cellForTouches(touches)
        if cell == nil { return }
        self.currentMagnifierCell = cell!
        
        self.showMagnifierForCell(self.currentMagnifierCell!)
        if cell!.imageView.image != nil && cell!.isDelete != false {
            UIDevice.currentDevice().playInputClick()
        }
        
        if cell!.isDelete {
            self.endBackspaceTimer()
            self.performSelector("startBackspaceTimer", afterDelay: 0.5)
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.touchMoved = true
        if self.currentMagnifierCell != nil && self.currentMagnifierCell!.isDelete { return }
        
      let cell = self.cellForTouches(touches)
         if cell == nil { return }
        if cell! != self.currentMagnifierCell {
            if self.currentMagnifierCell!.isDelete != true && cell!.isDelete != true
            {
                self.currentMagnifierCell = cell!
            }
            self.showMagnifierForCell(cell!)
        }
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
       
        let cell = self.cellForTouches(touches)
        if self.currentMagnifierCell != nil && cell != nil {
            if (self.currentMagnifierCell!.isDelete != true && cell!.emoticon != nil ) || (self.touchMoved == false && cell!.isDelete ) {
                
                (self.delegate as! WBEmoticonScrollViewDelegate).emoticonScrollViewDidTapCell(cell!)
            }
        }
      
        self.hideMagnifier()
        self.endBackspaceTimer()
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        self.hideMagnifier()
        self.endBackspaceTimer()
    }
    
    //MARK: private 
    func cellForTouches(touches: Set<UITouch>) -> WBEmoticonCell? {
        
        let touch = touches.first!
        let point = touch.locationInView(self)
        let indexPath = self.indexPathForItemAtPoint(point)
        
        if let _ = indexPath {
            return self.cellForItemAtIndexPath(indexPath!) as? WBEmoticonCell
        }
        return nil
    }
    
    func showMagnifierForCell(cell: WBEmoticonCell) {
        
        if cell.isDelete || cell.imageView.image == nil {
            self.hideMagnifier()
            return
        }
        
        let rect = cell.convertRect(cell.bounds, toView: self)
        self.magnifier.centerX = CGRectGetMidX(rect)
        self.magnifier.bottom = CGRectGetMaxY(rect) - 9
        self.magnifier.hidden = false
        
        self.magnifierContent.image = cell.imageView.image
        self.magnifierContent.top = 20
  
        self.magnifierContent.layer.removeAllAnimations()
      
        let dur: NSTimeInterval = 0.1
        UIView.animateWithDuration(dur, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            
            self.magnifierContent.top = 3
            }) { (finish) -> Void in
                
                UIView.animateWithDuration(dur, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                    
                    self.magnifierContent.top = 6
                    }) { (finish) -> Void in
                        UIView.animateWithDuration(dur, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                            
                            self.magnifierContent.top = 5
                            }) { (finish) -> Void in
                                
                        }
                }
        }
     
    }
    
    func hideMagnifier() {
        self.magnifier.hidden = true
    }
    
    func endBackspaceTimer() {
        
        NSObject.cancelPreviousPerformRequestsWithTarget(self, selector: "startBackspaceTimer", object: nil )
      self.backspaceTimer?.invalidate()
        self.backspaceTimer = nil

    }
    
    func startBackspaceTimer() {
        self.endBackspaceTimer()
        self.backspaceTimer = NSTimer(timeInterval: 0.1, block: { (timer) -> Void in
            
            let cell = self.currentMagnifierCell!
            if cell.isDelete {
                UIDevice.currentDevice().playInputClick()
                (self.delegate as! WBEmoticonScrollViewDelegate).emoticonScrollViewDidTapCell(cell)
            }
            }, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(self.backspaceTimer!, forMode: NSRunLoopCommonModes)
    }
}







protocol WBStatusComposeEmoticonViewDelegate {
    
     func emoticonInputDidTapText(text: String)
     func emoticonInputDidTapBackspace()
}



class WBEmoticonInputView: UIView ,UICollectionViewDelegate,UICollectionViewDataSource,UIInputViewAudioFeedback,WBEmoticonScrollViewDelegate{

    let kViewHeight: CGFloat = 216
    let kToolbarHeight: CGFloat = 37
    let kOneEmoticonHeight: CGFloat = 50
    let kOnePageCount: CGFloat = 20

    var toolbarButtons: NSArray!
    var collectionView: UICollectionView!
    var pageControl: UIView!
    var emoticonGroups: NSArray! ///< Array<WBEmoticonGroup>
    var emoticonGroupPageIndexs: NSArray!
    var emoticonGroupPageCounts: NSArray!
    var emoticonGroupTotalPageCount: Int = 0
    var currentPageIndex: Int!
  
    var delegate: WBStatusComposeEmoticonViewDelegate?
    
    class var sharedView: WBEmoticonInputView {
        get {
            struct Static {
                static let instance : WBEmoticonInputView = WBEmoticonInputView()
            }
            return Static.instance
        }
    }
    
     init() {
        
        super.init(frame: CGRectZero)
        self.frame = CGRectMake(0, 0, kScreenWidth, kViewHeight)
        self.backgroundColor = UIColor(hexString: "f9f9f9")
        
        self.initGroups()
        self.initTopLine()
        self.initCollectionView()
        self.initToolbar()
        
        self.currentPageIndex = NSNotFound
        self.toolbarBtnDidTapped(self.toolbarButtons.firstObject as! UIButton)
    }

     required init?(coder aDecoder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }

    
    func initGroups() {
        
        self.emoticonGroups = WBStatusHelper.emoticonGroups()
        
        let indexs = NSMutableArray()
        var index: Int32 = 0
        
        for group in self.emoticonGroups as! [WBEmoticonGroup] {
            indexs.addObject(NSNumber(int: index))
            var count = ceil(CGFloat(group.emoticons!.count) / kOnePageCount)
            
            if count == 0 { count = 1 }
            index += Int32(count)

        }
        
        self.emoticonGroupPageIndexs = indexs
        
        
        let pageCounts = NSMutableArray()
        self.emoticonGroupTotalPageCount = 0
        for group in self.emoticonGroups as! [WBEmoticonGroup] {
           
            var pagCount = ceil(CGFloat(group.emoticons!.count) / kOnePageCount)
            
            if pagCount == 0 { pagCount = 1 }

            pageCounts.addObject(NSNumber(float: Float(pagCount)))
            self.emoticonGroupTotalPageCount += Int(pagCount)
        }
        
        self.emoticonGroupPageCounts = pageCounts
       

    }
    
    func initTopLine() {
        
        let line = UIView()
        line.width = self.width
        line.height = CGFloatFromPixel(1)
        line.backgroundColor = UIColor(hexString: "bfbfbf")
        line.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        self.addSubview(line)
    }
    
    func initCollectionView() {
        var itemWidth: CGFloat = (kScreenWidth - 10 * 2) / 7.0
        itemWidth = CGFloatPixelRound(itemWidth)
        let padding = (kScreenWidth - 7 * itemWidth) / 2.0;
        let paddingLeft = CGFloatPixelRound(padding)
        let paddingRight = kScreenWidth - paddingLeft - itemWidth * 7
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        layout.itemSize = CGSizeMake(itemWidth, kOneEmoticonHeight)
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.sectionInset = UIEdgeInsetsMake(0, paddingLeft, 0, paddingRight);
        
        self.collectionView = WBEmoticonScrollView(frame: CGRectMake(0, 0, kScreenWidth, kOneEmoticonHeight * 3), collectionViewLayout: layout)
        self.collectionView.registerClass(WBEmoticonCell.self, forCellWithReuseIdentifier: "cell")
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.top = 5
        self.addSubview(self.collectionView)
        
        
        self.pageControl = UIView()
        self.pageControl.size = CGSizeMake(kScreenWidth, 20)
        self.pageControl.top = self.collectionView.bottom - 5
        self.pageControl.userInteractionEnabled = false
        self.addSubview(self.pageControl)
    }
    
    func initToolbar() {
        
        let toolbar = UIView()
        toolbar.size = CGSizeMake(kScreenWidth, kToolbarHeight);
        
        let bg = UIImageView(image: WBStatusHelper.imageNamed("compose_emotion_table_right_normal"))
        bg.size = toolbar.size
        toolbar.addSubview(bg)
        
        let scroll = UIScrollView()
        scroll.showsHorizontalScrollIndicator = false
        scroll.alwaysBounceHorizontal = true
        scroll.size = toolbar.size
        scroll.contentSize = toolbar.size
        toolbar.addSubview(scroll)
        
        let btns = NSMutableArray()
        for var i = 0 ; i < self.emoticonGroups.count ; i++ {
            let group = self.emoticonGroups[i] as! WBEmoticonGroup
            let btn = self.createToolbarButton()
            btn.setTitle(group.nameCN, forState: UIControlState.Normal)
            btn.left = kScreenWidth / CGFloat(self.emoticonGroups.count) * CGFloat(i)
            btn.tag = i
            scroll.addSubview(btn)
            btns.addObject(btn)
            
        }
        
        toolbar.bottom = self.height
        self.addSubview(toolbar)
        self.toolbarButtons = btns

    }
    
    func createToolbarButton() -> UIButton {
        
        let btn = UIButton()
        btn.exclusiveTouch = true
        btn.size = CGSizeMake(kScreenWidth / CGFloat(self.emoticonGroups.count), kToolbarHeight);
        btn.titleLabel!.font = UIFont.systemFontOfSize(14)
        btn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
         btn.setTitleColor(UIColor(hexString: "5D5C5A"), forState: UIControlState.Selected)
        
        
        var img: UIImage = WBStatusHelper.imageNamed("compose_emotion_table_left_normal")!
        img = img.resizableImageWithCapInsets(UIEdgeInsetsMake(0, 0, 0, img.size.width - 1), resizingMode: UIImageResizingMode.Stretch)
        btn.setBackgroundImage(img, forState: UIControlState.Normal)

        img = WBStatusHelper.imageNamed("compose_emotion_table_left_selected")!
        img = img.resizableImageWithCapInsets(UIEdgeInsetsMake(0, 0, 0, img.size.width - 1), resizingMode: UIImageResizingMode.Stretch)
        btn.setBackgroundImage(img, forState: UIControlState.Selected)
        
        btn.addTarget(self, action: "toolbarBtnDidTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        
        return btn;
        
    }
    
    
    //MARK: toolbar 点击方法
    func toolbarBtnDidTapped(sender: UIButton ) {
        
        print(self.toolbarButtons)
        let groupIndex = sender.tag
        let page = self.emoticonGroupPageIndexs[groupIndex].integerValue
        let rect = CGRectMake(CGFloat(page) * self.collectionView.width, 0, self.collectionView.width, self.collectionView.height)
        self.collectionView.scrollRectToVisible(rect, animated: false)
        self.scrollViewDidScroll(self.collectionView)

    }
    
    func emoticonForIndexPath(indexPath: NSIndexPath) -> WBEmoticon? {
        
        let section = indexPath.section
        for var i = self.emoticonGroupPageIndexs.count - 1 ; i >= 0 ; i-- {
            
            let pageIndex = self.emoticonGroupPageIndexs[i] as! NSNumber

            if section >= pageIndex.integerValue {
                
                let  group = self.emoticonGroups[i] as! WBEmoticonGroup
                let page = Int(section - pageIndex.integerValue)
                var index = Int(CGFloat(page) * kOnePageCount + CGFloat(indexPath.row))
                
                // transpose line/row
                let ip = index / Int(kOnePageCount)
                let ii = index % Int(kOnePageCount)
                let reIndex = (ii % 3) * 7 + (ii / 3);
                index = reIndex + ip * Int(kOnePageCount)
                
                if (index < group.emoticons!.count) {
                    return group.emoticons![Int(index)] as? WBEmoticon
                } else {
                    return nil
                }
            }
        }
        return nil

    }
    
    //MARK: UICollectionViewDelegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        var page: Int = Int(Float(round(scrollView.contentOffset.x / scrollView.width)))
        if page < 0 { page = 0 }
        else if page > self.emoticonGroupTotalPageCount { page = self.emoticonGroupTotalPageCount - 1}
        if page == self.currentPageIndex { return }
        self.currentPageIndex = page
        

        var curGroupIndex = 0, curGroupPageIndex = 0, curGroupPageCount = 0
        for var i = self.emoticonGroupPageIndexs.count - 1 ; i >= 0 ; i-- {
            let pageIndex: NSNumber = self.emoticonGroupPageIndexs[i] as! NSNumber
            if page >= pageIndex.integerValue {
                curGroupIndex = i
                curGroupPageIndex = self.emoticonGroupPageIndexs[i].integerValue
                curGroupPageCount = self.emoticonGroupPageCounts[i].integerValue
                break
            }
        }
        
        self.pageControl.layer.removeAllSublayers()
        
        
        let padding: CGFloat = 5, width: CGFloat = 6, height: CGFloat = 2
        let pageControlWidth: CGFloat = (width + 2 * padding) * CGFloat(curGroupPageCount)
        
        print(curGroupPageCount)
        //便利当前组内每一页，添加pagecontrol
        for var i = 0 ; i < curGroupPageCount ; i++ {
            let  layer = CALayer()
            layer.size = CGSizeMake(width, height)
            layer.cornerRadius = 1
            if page - curGroupPageIndex == i {
                layer.backgroundColor = UIColor(hexString: "fd8225").CGColor
            }else{
                layer.backgroundColor = UIColor(hexString: "dedede").CGColor
            }
            
            layer.centerY = self.pageControl.height / 2
            layer.left = (self.pageControl.width - pageControlWidth) / 2 + CGFloat(i) * (width + 2 * padding) + padding;
            self.pageControl.layer.addSublayer(layer)
            
        }
   
        self.toolbarButtons.enumerateObjectsUsingBlock { (btn, idx, stop:UnsafeMutablePointer<ObjCBool>) -> Void in
            (btn as! UIButton).selected = idx == curGroupIndex
        }
  

        
    }
    
    //MARK: WBEmoticonScrollViewDelegate
    func emoticonScrollViewDidTapCell(cell: WBEmoticonCell?) {
        
        if cell == nil { return }
        if cell!.isDelete {
            UIDevice.currentDevice().playInputClick()
            if self.delegate != nil {
                self.delegate?.emoticonInputDidTapBackspace()
            }
        }else if cell!.emoticon != nil {
            
            var text :NSString?
            
            switch cell!.emoticon!.emo_type! {
            case WBEmoticonType.WBEmoticonTypeImage:
                text = cell!.emoticon?.chs
            case WBEmoticonType.WBEmoticonTypeEmoji:
                let num = NSNumber(string: cell!.emoticon!.code)
                text = NSString(UTF32Char: num.unsignedIntValue)
            }
            
            if text != nil {
                self.delegate?.emoticonInputDidTapText(text! as String)
            }
        }
        
        
    }
    
    //MARK: collectionview delegage
     func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
     func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    //MARK: UICollectionViewDataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return self.emoticonGroupTotalPageCount
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Int(Float(kOnePageCount)) + 1
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! WBEmoticonCell
        if (indexPath.row == Int(Float(kOnePageCount))) {
            cell.isDelete = true
            cell.emoticon = nil
        } else {
            cell.isDelete = false
            cell.emoticon = self.emoticonForIndexPath(indexPath);
        }
        return cell;
    }
    
  
}
