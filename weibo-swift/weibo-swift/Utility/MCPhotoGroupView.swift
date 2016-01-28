//
//  MCPhotoGroupView.swift
//  weibo-swift
//
//  Created by 马超 on 16/1/15.
//  Copyright © 2016年 马超. All rights reserved.
//

import UIKit


let kPadding: CGFloat = 20
var oldDevices:NSMutableSet?

/// Single picture's info.
class MCPhotoGroupItem: NSObject,NSCopying {
    
    var thumbView: UIView? ///< thumb image, used for animation position calculation

    var largeImageSize: CGSize?
    var largeImageURL: NSURL?
    var thumbImage: UIImage? {
        get {
            if self.thumbView != nil && self.thumbView!.respondsToSelector("image") {
                
                return (self.thumbView as! YYControl).image
            }
            return nil
        }
    }
    var thumbClippedToTop: Bool {
        get {
            if let _ = self.thumbView {
                if self.thumbView!.layer.contentsRect.size.height < 1 {
                    return true
                }
            }
            return false
        }
    }
    
    func shouldClipToTop(imageSize: CGSize , forView view: UIView) ->Bool {
        
        if imageSize.width < 1 || imageSize.height < 1 { return false }
        if view.width < 1 || view.height < 1 { return false }
        return imageSize.height / imageSize.width > view.height / view.width
    }
    
    func copyWithZone(zone: NSZone) -> AnyObject {
        return self
    }
    
}


class MCPhotoGroupCell: UIScrollView ,UIScrollViewDelegate{
    
    var imageContainerView: UIView!
    var imageView: YYAnimatedImageView!
    var page: Int = 0
    var showProgress = false
    var progress: CGFloat = 0
    var progressLayer: CAShapeLayer!
    var item: MCPhotoGroupItem?
    var itemDidLoad = false
    
    init () {
        super.init(frame: CGRectZero)
        self.delegate = self
        self.bouncesZoom = true
        self.maximumZoomScale = 3
        self.multipleTouchEnabled = true
        self.alwaysBounceVertical = false
        self.showsVerticalScrollIndicator = true
        self.showsHorizontalScrollIndicator = false
        self.frame = UIScreen.mainScreen().bounds
        
        self.imageContainerView = UIView()
        self.imageContainerView.clipsToBounds = true
        self.addSubview(self.imageContainerView)
        
        self.imageView = YYAnimatedImageView()
        self.imageView.clipsToBounds = true
        self.imageView.backgroundColor = UIColor(white: 1.000, alpha: 0.500)
        self.imageContainerView.addSubview(self.imageView)
        
        self.progressLayer = CAShapeLayer()
        self.progressLayer.size = CGSizeMake(40, 40)
        self.progressLayer.cornerRadius = 20
        self.progressLayer.backgroundColor = UIColor(white: 0.000, alpha: 0.500).CGColor
        let path = UIBezierPath(roundedRect: CGRectInset(self.progressLayer.bounds, 7, 7), cornerRadius: CGFloat(40 / 2 - 7))
        self.progressLayer.path = path.CGPath
        self.progressLayer.fillColor = UIColor.clearColor().CGColor
        self.progressLayer.strokeColor = UIColor.whiteColor().CGColor
        self.progressLayer.lineWidth = 4
        self.progressLayer.lineCap = kCALineCapRound
        self.progressLayer.strokeStart = 0
        self.progressLayer.strokeEnd = 0
        self.progressLayer.hidden = false
        self.layer.addSublayer(self.progressLayer)
        
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.progressLayer.center = CGPointMake(self.width / 2 , self.height / 2)
        
    }
    
    func setWithItem(item: MCPhotoGroupItem?) {
        
  
        if self.item == item {
            return
        }
        self.item = item
        self.itemDidLoad = false
        
        self.setZoomScale(1, animated: false)
        self.maximumZoomScale = 1
        
        self.imageView.cancelCurrentImageRequest()
        self.imageView.layer.removePreviousFadeAnimation()
        
        self.progressLayer.hidden = false
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        self.progressLayer.strokeEnd = 0
        self.progressLayer.hidden = true
        CATransaction.commit()
        
        if self.item == nil {
            self.imageView.image = nil
            return
        }
        self.imageView.setImageWithURL(item!.largeImageURL, placeholder: item!.thumbImage, options: YYWebImageOptions.AllowBackgroundTask, progress: { (receivedSize, expectedSize) -> Void in
            
            var progress: Float = Float(receivedSize) / Float(expectedSize)
            progress = progress < 0.01 ? 0.01 : progress > 1 ? 1 : progress
            if isnan(progress) { progress = 0 }
            self.progressLayer.hidden = false
            self.progressLayer.strokeEnd = CGFloat(progress)
            
            }, transform: nil) { (image, url, from, stage, error) -> Void in
                
                self.progressLayer.hidden = true
                if stage == YYWebImageStage.Finished {
                    self.maximumZoomScale = 3
                    if let _ = image {
                        self.itemDidLoad = true
                        
                        self.resizeSubviewSize()
                        self.imageView.layer.addFadeAnimationWithDuration(0.1, curve: UIViewAnimationCurve.Linear)
                    }
                }
        }
        
        self.resizeSubviewSize()
        
        
    }
    
    func resizeSubviewSize() {
        
        self.imageContainerView.origin = CGPointZero
        self.imageContainerView.width = self.width
        
        let image = self.imageView.image
        if image == nil { return }
        if image!.size.height / image!.size.width > self.height / self.width {
            self.imageContainerView.height = floor(image!.size.height / (image!.size.width / self.width))
        }else {
        
            var height = image!.size.height / image!.size.width * self.width
            if (height < 1 || isnan(height)) { height = self.height }
            height = floor(height);
            self.imageContainerView.height = height
            self.imageContainerView.centerY = self.height / 2
        
        }
        
        if self.imageContainerView.height > self.height && self.imageContainerView.height - self.height <= 1 {
            self.imageContainerView.height = self.height
        }
        
        self.contentSize = CGSizeMake(self.width, max(self.imageContainerView.height, self.height))
        self.scrollRectToVisible(self.bounds, animated: false)
        
        if self.imageContainerView.height < self.height {
            self.alwaysBounceVertical = false
        }else {
            self.alwaysBounceVertical = true
        }
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        self.imageView.frame = self.imageContainerView.bounds
        CATransaction.commit()
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.imageContainerView
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        
        let subView = self.imageContainerView
        let offsetX = scrollView.bounds.size.width > scrollView.contentSize.width ?
        (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0
        
        let offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height) ?
        (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0
        
        subView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
        scrollView.contentSize.height * 0.5 + offsetY)
    }
}

public class MCPhotoGroupView: UIView,UIGestureRecognizerDelegate,UIScrollViewDelegate {
    
    //MARK: 图片数组
    
    public var groupItems: NSArray
    //MARK:当前页
    
    public var currentPage: Int {
        get {
          
           var page = Int(Float(self.scrollView.contentOffset.x / self.scrollView.width + 0.5))
            if page > Int(self.groupItems.count) - 1 { page = Int((self.groupItems.count) - 1)}
            if page < 0 { page = 0 }
            return page
        }
    }
    
    //MARK: ///< Default is YES
    public var blurEffectBackground: Bool
    //MARK: 提供的默认的初始化方法
    
    public init(items: NSArray) {
        
        self.scrollView = UIScrollView()
        self.blurEffectBackground = true
        self.groupItems = items
        super.init(frame: CGRectZero)
        
        let model = UIDevice.currentDevice().machineModel
        if oldDevices == nil {
            oldDevices = NSMutableSet()
            oldDevices!.addObject("iPod1,1")
            oldDevices! .addObject("iPod2,1")
            oldDevices! .addObject("iPod3,1")
            oldDevices! .addObject("iPod4,1")
            oldDevices! .addObject("iPod5,1")
            
            oldDevices! .addObject("iPhone1,1")
            oldDevices! .addObject("iPhone1,1")
            oldDevices! .addObject("iPhone1,2")
            oldDevices! .addObject("iPhone2,1")
            oldDevices! .addObject("iPhone3,1")
            oldDevices! .addObject("iPhone3,2")
            oldDevices! .addObject("iPhone3,3")
            oldDevices! .addObject("iPhone4,1")
            
            oldDevices! .addObject("iPad1,1")
            oldDevices! .addObject("iPad2,1")
            oldDevices! .addObject("iPad2,2")
            oldDevices! .addObject("iPad2,3")
            oldDevices! .addObject("iPad2,4")
            oldDevices! .addObject("iPad2,5")
            oldDevices! .addObject("iPad2,6")
            oldDevices! .addObject("iPad2,7")
            oldDevices! .addObject("iPad3,1")
            oldDevices! .addObject("iPad3,2")
            oldDevices! .addObject("iPad3,3")
        }
        
        if oldDevices!.containsObject(model) {
            self.blurEffectBackground = false
        }
        
        self.backgroundColor = UIColor.clearColor()
        self.frame = UIScreen.mainScreen().bounds
        self.clipsToBounds = true
        
        let tap = UITapGestureRecognizer(target: self, action: "dismiss")
        tap.delegate = self
        self.addGestureRecognizer(tap)
        
        let tap2 = UITapGestureRecognizer(target: self, action: "doubleTap:")
        tap2.delegate = self
        tap2.numberOfTapsRequired = 2
        tap.requireGestureRecognizerToFail(tap2)
        self.addGestureRecognizer(tap2)
        
        let press = UILongPressGestureRecognizer(target: self, action: "longPress")
        press.delegate = self
        self.addGestureRecognizer(press)
        
        let pan = UIPanGestureRecognizer(target: self, action: "pan:")
        self.addGestureRecognizer(pan)
        
        self.background = UIImageView()
        self.background.frame = self.bounds
        self.background.autoresizingMask = [UIViewAutoresizing.FlexibleWidth,UIViewAutoresizing.FlexibleHeight]
        
        self.blurBackground = UIImageView()
        self.blurBackground.frame = self.bounds
        self.blurBackground.autoresizingMask = [UIViewAutoresizing.FlexibleWidth,UIViewAutoresizing.FlexibleHeight]
        
        self.contentView = UIView()
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [UIViewAutoresizing.FlexibleWidth,UIViewAutoresizing.FlexibleHeight]
        
        self.scrollView.frame = CGRectMake(-kPadding / 2, 0, self.width + kPadding, self.height)
        self.scrollView.delegate = self
        self.scrollView.scrollsToTop = false
        self.scrollView.pagingEnabled = true
        self.scrollView.alwaysBounceHorizontal = groupItems.count > 1
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.autoresizingMask = [UIViewAutoresizing.FlexibleWidth,UIViewAutoresizing.FlexibleHeight]
        self.scrollView.delaysContentTouches = false
        self.scrollView.canCancelContentTouches = true
        
        self.pager = UIPageControl()
//        self.pager.backgroundColor = UIColor.redColor()
        self.pager.hidesForSinglePage = true
        self.pager.userInteractionEnabled = false
        self.pager.width = self.width - 36
        self.pager.height = 10
        self.pager.center = CGPointMake(self.width / 2, self.height - 18)
        self.pager.autoresizingMask = [UIViewAutoresizing.FlexibleWidth,UIViewAutoresizing.FlexibleHeight]
        
    
        self.addSubview(self.background)
        self.addSubview(self.blurBackground)
        self.addSubview(self.contentView)
        self.contentView.addSubview(self.scrollView)
        self.contentView.addSubview(self.pager)
        
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func presentFromImageView(fromView: UIView ,toContainer: UIView? , animated: Bool , completion: (() ->Void)?) {
        
        if toContainer == nil { return }
        self.fromView = fromView
        self.toContainerView = toContainer!
        
        var page = -1
        for var i = 0 ; i < self.groupItems.count ; i++ {
            if self.fromView == (self.groupItems[i] as! MCPhotoGroupItem).thumbView {
                page = i
                break
            }
        }
        if page == -1 { page = 0 }
        self.fromItemIndex = page
        
        self.snapshotImage = self.toContainerView.snapshotImageAfterScreenUpdates(false)
        let fromViewHidden = self.fromView.hidden
        fromView.hidden = true
        self.snapshorImageHideFromView = self.toContainerView.snapshotImage()
        fromView.hidden = fromViewHidden

        self.background.image = self.snapshorImageHideFromView!
        if (self.blurEffectBackground) {
            self.blurBackground.image = self.snapshorImageHideFromView!.imageByBlurDark() //Same to UIBlurEffectStyleDark
        } else {
            self.blurBackground.image = UIImage(color: UIColor.blackColor())
        }
        
        self.size = self.toContainerView.size
        self.blurBackground.alpha = 0
        self.pager.alpha = 0
        self.pager.numberOfPages = self.groupItems.count
        self.pager.currentPage = page
        self.toContainerView.addSubview(self)
        

        self.scrollView.contentSize = CGSizeMake(self.scrollView.width * CGFloat(self.groupItems.count), self.scrollView.height)
        self.scrollView.scrollRectToVisible(CGRectMake(self.scrollView.width * CGFloat(self.pager.currentPage), 0, self.scrollView.width, self.scrollView.height), animated: false)
        self.scrollViewDidScroll(self.scrollView)

        //隐藏导航
        UIView.setAnimationsEnabled(true)
        self.fromNavigationBarHidden = UIApplication.sharedApplication().statusBarHidden
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: animated ? UIStatusBarAnimation.Fade : UIStatusBarAnimation.None)
        

        let cell = self.cellForPage(self.currentPage)
        let item = self.groupItems[self.currentPage] as! MCPhotoGroupItem

        if !item.thumbClippedToTop {
            let imageKey = YYWebImageManager.sharedManager().cacheKeyForURL(item.largeImageURL)
            if (YYWebImageManager.sharedManager().cache.getImageForKey(imageKey, withType: YYImageCacheType.Memory) != nil) {
                cell!.setWithItem(item )
            }
        }
        
        
        if cell?.item == nil {
            cell!.imageView.image = item.thumbImage
            cell!.resizeSubviewSize()
        }


        
        if item.thumbClippedToTop {
            
            let fromFrame = self.fromView.convertRect(self.fromView.bounds, toView: cell)
            let originFrame = cell!.imageContainerView.frame
            let scale = fromFrame.size.width / cell!.imageContainerView.width
            
            cell!.imageContainerView.centerX = CGRectGetMidX(fromFrame)
            cell!.imageContainerView.height = fromFrame.size.height / scale
            cell!.imageContainerView.layer.transformScale = scale
            cell!.imageContainerView.centerY = CGRectGetMidY(fromFrame)
            
            let oneTime = animated ? 0.25 : 0
            
            UIView.animateWithDuration(oneTime, delay: 0, options: [UIViewAnimationOptions.BeginFromCurrentState,UIViewAnimationOptions.CurveEaseInOut], animations: { () -> Void in
                
                self.blurBackground.alpha = 1
                
                }, completion: { (finished) -> Void in
                
            })
            
            self.scrollView.userInteractionEnabled = false
            
            UIView.animateWithDuration(oneTime, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                
                cell!.imageContainerView.layer.transformScale = 1;
                cell!.imageContainerView.frame = originFrame
                self.pager.alpha = 1
                
                }, completion: { (finished) -> Void in
                    self.isPresented = true
                    self.scrollViewDidScroll(self.scrollView)
                    self.scrollView.userInteractionEnabled = true
                      self.hidePager()
                    if (completion != nil) { completion!()}
            })
            
        }else {
            
            let fromFrame = self.fromView.convertRect(self.fromView.bounds, toView: cell!.imageContainerView)
            cell?.imageContainerView.clipsToBounds = false
            cell?.imageView.frame = fromFrame
            cell?.imageView.contentMode = UIViewContentMode.ScaleAspectFill
            
            let oneTime = animated ? 0.18 : 0
            
            UIView.animateWithDuration(oneTime * 2, delay: 0, options: [UIViewAnimationOptions.BeginFromCurrentState,UIViewAnimationOptions.CurveEaseInOut], animations: { () -> Void in
                
                self.blurBackground.alpha = 1
                
                }, completion: { (finished) -> Void in
                    
            })
            
            self.scrollView.userInteractionEnabled = false
            
            UIView.animateWithDuration(oneTime, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                
                cell!.imageView.frame = cell!.imageContainerView.bounds
                cell!.imageView.layer.transformScale = 1.01
                
                
                }, completion: { (finished) -> Void in
                    cell?.imageContainerView.clipsToBounds = true
                    self.isPresented = true
                    self.scrollViewDidScroll(self.scrollView)
                    self.scrollView.userInteractionEnabled = true
                    self.hidePager()
                    if (completion != nil) { completion!()}
            })
        }
        
    }
    public func dismissAnimated(animated: Bool , completion: (() ->Void)?) {
        
        UIView.setAnimationsEnabled(true)
        UIApplication.sharedApplication().setStatusBarHidden(self.fromNavigationBarHidden, withAnimation: animated ? UIStatusBarAnimation.Fade : UIStatusBarAnimation.None)
        
        let currentPage = self.currentPage
        let cell = self.cellForPage(currentPage)
        let item = self.groupItems[currentPage]
        
        
        let fromView: UIView?
        if self.fromItemIndex == currentPage {
            fromView = self.fromView
        }else {
            fromView = item.thumbView!!
        }
        
        self.cancelAllImageLoad()
        self.isPresented = false
        
        let isFromImageClipped = fromView!.layer.contentsRect.size.height < 1
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        if isFromImageClipped {
            let frame = cell!.imageContainerView.frame
            cell!.imageContainerView.layer.anchorPoint = CGPointMake(0.5, 0)
            cell!.imageContainerView.frame = frame
        }
        cell!.progressLayer.hidden = true
        CATransaction.commit()
        
        
        if fromView == nil {
            UIView.animateWithDuration(animated ? 0.25 : 0, delay: 0, options: [UIViewAnimationOptions.BeginFromCurrentState,UIViewAnimationOptions.CurveEaseOut], animations: { () -> Void in
                self.alpha = 0.0
                self.scrollView.layer.transformScale = 0.95
                self.scrollView.alpha = 0
                self.pager.alpha = 0
                self.blurBackground.alpha = 0
                }, completion: { (finish) -> Void in
                    self.scrollView.layer.transformScale = 1
                    self.removeFromSuperview()
                    self.cancelAllImageLoad()
                  if (completion != nil) { completion!()}
            })
            
            return
        }
        
        if (self.fromItemIndex != currentPage) {
            self.background.image = self.snapshotImage
            self.background.layer.addFadeAnimationWithDuration(0.25, curve: UIViewAnimationCurve.EaseOut)
           
        } else {
            self.background.image = self.snapshorImageHideFromView
        }
        
        if isFromImageClipped {
            cell?.scrollToTopAnimated(false)
        }
        
        
        UIView.animateWithDuration(animated ? 0.2 : 0, delay: 0, options: [UIViewAnimationOptions.BeginFromCurrentState,UIViewAnimationOptions.CurveEaseOut], animations: { () -> Void in

            self.pager.alpha = 0
            self.blurBackground.alpha = 0
            if (isFromImageClipped) {
                
                let fromFrame = fromView!.convertRect(fromView!.bounds, toView: cell)
                let scale = fromFrame.size.width / cell!.imageContainerView.width * cell!.zoomScale
                var height = fromFrame.size.height / fromFrame.size.width * cell!.imageContainerView.width
                
                if isnan(height) {  height =  cell!.imageContainerView.height}
    
                cell!.imageContainerView.height = height
                cell!.imageContainerView.center = CGPointMake(CGRectGetMidX(fromFrame), CGRectGetMinY(fromFrame))
                cell!.imageContainerView.layer.transformScale = scale
                
            } else {
                let fromFrame = fromView!.convertRect(fromView!.bounds, toView: cell!.imageContainerView)
                cell!.imageContainerView.clipsToBounds = false
                cell!.imageView.contentMode = fromView!.contentMode
                cell!.imageView.frame = fromFrame
            }
            }, completion: { (finish) -> Void in
                UIView.animateWithDuration(animated ? 0.2 : 0, delay: 0, options: [UIViewAnimationOptions.BeginFromCurrentState,UIViewAnimationOptions.CurveEaseOut], animations: { () -> Void in
                    
                    self.alpha = 0
                    }, completion: { (finish) -> Void in
                        cell!.imageContainerView.layer.anchorPoint = CGPointMake(0.5, 0.5)
                        self.removeFromSuperview()
                        if (completion != nil) { completion!()}
                })
        })
        
    }
    
    public func dismiss() {
        self.dismissAnimated(true, completion: nil)
    }
    
    private var scrollView: UIScrollView
    private var panGesture: UIPanGestureRecognizer!
    private var cells: NSArray = NSArray()
    private var background: UIImageView!
    private var blurBackground: UIImageView!
    private var contentView: UIView!
    private var pager: UIPageControl!
    private var fromView: UIView!
    private var toContainerView: UIView!
    private var fromItemIndex: Int = 0
    private var snapshotImage: UIImage?
    private var snapshorImageHideFromView: UIImage?
    private var fromNavigationBarHidden: Bool = false
    private var isPresented = false
    private var panGestureBeginPoint = CGPointZero
    
    private var temp = 0
    
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        
        self.updateCellsForReuse()
        let  floatPage = self.scrollView.contentOffset.x / self.scrollView.width
        let  page = Int(Float(self.scrollView.contentOffset.x / self.scrollView.width + 0.5))

     
        for var i = page - 1 ; i <= page + 1 ; i++ {
           
            
            if i >= 0 && i < self.groupItems.count {
                
                let cell = self.cellForPage(i)
                if cell == nil {
                    
                    let cell = self.dequeueReusableCell()
                    cell.page = i
                    print((self.width + kPadding) * CGFloat(i) + kPadding / 2)
                    cell.left = (self.width + kPadding) * CGFloat(i) + kPadding / 2
                    if self.isPresented {
                        cell.setWithItem(self.groupItems[i] as? MCPhotoGroupItem)
                    }
                    
                    self.scrollView.addSubview(cell)
                }else{
                    
                    if self.isPresented && cell?.item == nil {
                       
                       cell!.setWithItem(self.groupItems[i] as? MCPhotoGroupItem)
                    }
                }
            }
        }
        
        var intPage = Int(Float(floatPage + 0.5))
        intPage = intPage < 0 ? 0 : intPage >= self.groupItems.count ? self.groupItems.count - 1 : intPage
        self.pager.currentPage = intPage
       
        UIView.animateWithDuration(0.3, delay: 0, options: [UIViewAnimationOptions.BeginFromCurrentState,UIViewAnimationOptions.CurveEaseInOut], animations: { () -> Void in
            self.pager.alpha = 1
            }) { (finish) -> Void in
                
        }
    
    }
    
    public func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.hidePager()
        }
    }
    
    public func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.hidePager()
    }
    
    /// get the cell for specified page, nil acell is invisible
    private func cellForPage(page: Int) -> MCPhotoGroupCell? {
        
        for cell: MCPhotoGroupCell in self.cells as! [MCPhotoGroupCell] {
            if cell .page == page {
                return cell
            }
        }
        return nil
    }
    
    private func hidePager() {
        
        UIView.animateWithDuration(0.3, delay: 0.8, options: [UIViewAnimationOptions.BeginFromCurrentState,UIViewAnimationOptions.CurveEaseOut], animations: { () -> Void in
            self.pager.alpha = 0
            }) { (finish) -> Void in
                
        }
       
    }
    
    private func cancelAllImageLoad() {
        self.cells.enumerateObjectsUsingBlock { (cell, idx, stop) -> Void in
            (cell as! MCPhotoGroupCell).imageView.cancelCurrentImageRequest()
        }
    }
    
    private func updateCellsForReuse() {
        
        for cell in self.cells as! [MCPhotoGroupCell] {
            if cell.superview != nil {
                if cell.left > self.scrollView.contentOffset.x + self.scrollView.width * 2 || cell.right < self.scrollView.contentOffset.x - self.scrollView.width {
                    print("remove")
                    cell.removeFromSuperview()
                    cell.page = -1
                    cell.setWithItem(nil)
                }
            }
        }
       
    }
    
    private func dequeueReusableCell()-> MCPhotoGroupCell {
        var cell: MCPhotoGroupCell
        for cell in self.cells as! [MCPhotoGroupCell] {
            if cell.superview == nil {
                return cell
            }
        }
        
        cell = MCPhotoGroupCell()
        cell.frame = self.bounds
        cell.imageContainerView.frame = self.bounds
        cell.imageView.frame = cell.bounds
        cell.page = -1
        cell.setWithItem(nil)
        let temp = NSMutableArray(array: self.cells)
        temp.addObject(cell)
        self.cells = temp
        return cell
    }
    
    public func doubleTap(g: UITapGestureRecognizer) {
        if !self.isPresented { return }
        let tile = self.cellForPage(self.currentPage)

        if tile != nil {
            if tile!.zoomScale > 1 {
                tile!.setZoomScale(1, animated: true)
            }else {
               let touchPoint = g.locationInView(tile!.imageView)
                let newZoomScale = tile!.maximumZoomScale
                let xsize = self.width / newZoomScale
                let ysize = self.height / newZoomScale
                
                tile!.zoomToRect(CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize), animated: true)
            }
        }
    }
    
    public func longPress() {
        
        if !self.isPresented  { return }
        
        let tile = self.cellForPage(self.currentPage)
        if tile?.imageView.image == nil { return }
        
        // try to save original image data if the image contains multi-frame (such as GIF/APNG)
        var imageItem = tile!.imageView.image!.dataRepresentation() as AnyObject

        let type = YYImageDetectType(imageItem as! CFData)
        if type != YYImageType.PNG && type != YYImageType.JPEG && type != YYImageType.GIF {
            imageItem = tile!.imageView.image!
        }
    
        let activityViewController = UIActivityViewController(activityItems: [imageItem], applicationActivities: nil)
        let toVC = self.toContainerView.viewController
        toVC.presentViewController(activityViewController, animated: true, completion: nil)
       
    }
    
    public func pan(g: UIPanGestureRecognizer) {
        switch g.state {
        case UIGestureRecognizerState.Began :
            if self.isPresented {
                self.panGestureBeginPoint = g.locationInView(self)
            }else{
                self.panGestureBeginPoint = CGPointZero
            }
        case UIGestureRecognizerState.Changed :
            
            if self.panGestureBeginPoint.x == 0 && self.panGestureBeginPoint.y == 0 { return }
            let p = g.locationInView(self)
            let deltaY = p.y - self.panGestureBeginPoint.y
            self.scrollView.top = deltaY
            
            let alphaDelta: CGFloat = 160
            var alpha = (alphaDelta - fabs(deltaY) + 50) / alphaDelta
            alpha = (((alpha) > (1)) ? (1) : (((alpha) < (0)) ? (0) : (alpha)))

            UIView.animateWithDuration(0.1, delay: 0, options: [UIViewAnimationOptions.BeginFromCurrentState,UIViewAnimationOptions.AllowUserInteraction,UIViewAnimationOptions.CurveLinear], animations: { () -> Void in
                
                }, completion: { (finish) -> Void in
                    self.blurBackground.alpha = alpha
                    self.pager.alpha = alpha
            })
        case UIGestureRecognizerState.Ended :
            
            if self.panGestureBeginPoint.x == 0 && self.panGestureBeginPoint.y == 0 { return }
            let v = g.velocityInView(self)
            let p = g.locationInView(self)
            let deltaY = p.y - self.panGestureBeginPoint.y
            
            
            if (fabs(v.y) > 1000 || fabs(deltaY) > 120) {
                self.cancelAllImageLoad()
                self.isPresented = false
                UIApplication.sharedApplication().setStatusBarHidden(self.fromNavigationBarHidden, withAnimation: UIStatusBarAnimation.Fade)
                
              let moveToTop = (v.y < -50 || (v.y < 50 && deltaY < 0))
                
                var vy = fabs(v.y)
                if (vy < 1) { vy = 1 }
                
                var duration = (moveToTop ? self.scrollView.bottom : self.height - self.scrollView.top) / vy
                duration *= 0.8
                duration = (((duration) > (0.3)) ? (0.3) : (((duration) < (0.53)) ? (0.53) : (duration)))
                
                UIView.animateWithDuration(Double(duration), delay: 0, options: [UIViewAnimationOptions.BeginFromCurrentState,UIViewAnimationOptions.CurveLinear], animations: { () -> Void in
                    
                    self.blurBackground.alpha = 0
                    self.pager.alpha = 0

                    if (moveToTop) {
                        self.scrollView.bottom = 0
                    } else {
                        self.scrollView.top = self.height
                    }
                    }, completion: { (finish) -> Void in
                        self.removeFromSuperview()
                })
                
             self.background.image = self.snapshotImage
                self.background.layer.addFadeAnimationWithDuration(0.3, curve: UIViewAnimationCurve.EaseInOut)
    
            } else {
                
                
                UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: v.y / 1000, options: [UIViewAnimationOptions.CurveEaseInOut,UIViewAnimationOptions.AllowUserInteraction,UIViewAnimationOptions.BeginFromCurrentState], animations: { () -> Void in
                    self.scrollView.top = 0
                    self.blurBackground.alpha = 1
                    self.pager.alpha = 1
                    }, completion: { (finish) -> Void in
                        
                })
                
                
              
            }
        case UIGestureRecognizerState.Cancelled :
            
            self.scrollView.top = 0
            self.blurBackground.alpha = 1
            
        default :
            break
        }
        
    }
}


