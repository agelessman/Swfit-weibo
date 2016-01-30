//
//  WBStatusCardView.swift
//  weibo-swift
//
//  Created by 马超 on 16/1/11.
//  Copyright © 2016年 马超. All rights reserved.
//

import UIKit

class WBStatusCardView: UIView {

 
    var imageView :UIImageView!
    var badgeImageView :UIImageView!
    var label :YYLabel!
    var button :UIButton!
    var cell :WBStatusCell!
    var _isRetweet = false
    
    override init(var frame: CGRect) {
        
        if (frame.size.width == 0 && frame.size.height == 0) {
            frame.size.width = kScreenWidth
            frame.origin.x = CGFloat(kWBCellPadding)
        }
        
        super.init(frame: frame)
        self.exclusiveTouch = true
        
        imageView                         = UIImageView()
        imageView.clipsToBounds           = true
        imageView.contentMode             = UIViewContentMode.ScaleAspectFill

        badgeImageView                    = UIImageView()
        badgeImageView.clipsToBounds      = true
        badgeImageView.contentMode        = UIViewContentMode.ScaleAspectFill

        label                             = YYLabel()
        label.textVerticalAlignment       = YYTextVerticalAlignment.Center
        label.numberOfLines               = 3
        label.ignoreCommonProperties      = true
        label.displaysAsynchronously      = true
        label.fadeOnAsynchronouslyDisplay = false
        label.fadeOnHighlight             = false

        button                            = UIButton(type: UIButtonType.Custom)

        self.backgroundColor              = kWBCellInnerViewColor
        self.layer.borderWidth            = CGFloatFromPixel(1)
        self.layer.borderColor            = UIColor(white: 0.000, alpha: 0.070).CGColor
        
        self.addSubview(imageView)
        self.addSubview(badgeImageView)
        self.addSubview(label)
        self.addSubview(button)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setWithLayout(layout :WBStatusLayout , isRetweet :Bool) {
        
        let pageInfo = isRetweet ? layout.status?.retweetedStatus?.pageInfo : layout.status?.pageInfo
        if pageInfo == nil { return }
        self.height = isRetweet ? CGFloat(layout.retweetCardHeight!) : CGFloat(layout.cardHeight!)
        /*
        badge: 25,25 左上角 (42)
        image: 70,70 方形
        100, 70 矩形
        btn:  60,70
        
        lineheight 20
        padding 10
        */
        self._isRetweet = isRetweet
        switch isRetweet ? layout.retweetCardType! : layout.cardType! {
        case WBStatusCardType.None : break
        case WBStatusCardType.Normal :
            self.width = CGFloat(kWBCellContentWidth)
            if let _ = pageInfo!.typeIcon {
                badgeImageView.hidden = false
                badgeImageView.frame = CGRectMake(0, 0, 25, 25)
                badgeImageView.setImageWithURL(pageInfo!.typeIcon!, placeholder: nil)
            }else {
                badgeImageView.hidden = true
            }
            
            if let _ = pageInfo!.pagePic {
                imageView.hidden = false
                if let _ = pageInfo!.typeIcon {
                    imageView.frame = CGRectMake(0, 0, 100, 70)
                }else {
                    imageView.frame = CGRectMake(0, 0, 70, 70)
                }
                imageView.setImageWithURL(pageInfo!.pagePic, placeholder: nil)
            }else {
                imageView.hidden = true
            }
            
            label.hidden = false
            label.frame = isRetweet ? layout.retweetCardTextRect! : layout.cardTextRect!
            label.textLayout = isRetweet ? layout.retweetCardTextLayout! : layout.cardTextLayout!
            
            let buttonLink :WBButtonLink? = pageInfo!.buttons?.firstObject as? WBButtonLink
            if buttonLink?.pic != nil && buttonLink?.name != nil {
                self.button.hidden = false
                self.button.size = CGSizeMake(60, 70)
                self.button.top = 0
                self.button.right = self.width
                self.button.setTitle(buttonLink!.name, forState: UIControlState.Normal)
                self.button.setImageWithURL(buttonLink!.pic, forState: UIControlState.Normal, placeholder: nil)
            }else {
                self.button.hidden = true
            }
        case WBStatusCardType.Video :
            self.width = self.height
            badgeImageView.hidden = true
            label.hidden = true
            imageView.frame = self.bounds
            imageView.setImageWithURL(pageInfo!.pagePic, options: YYWebImageOptions.AllowBackgroundTask)
            self.button.hidden = false
            self.button.frame = self.bounds
            self.button.setTitle(nil, forState: UIControlState.Normal)
            self.button.cancelImageRequestForState(UIControlState.Normal)
            self.button.setImage(WBStatusHelper.imageNamed("multimedia_videocard_play"), forState: UIControlState.Normal)
       
        }
        self.backgroundColor = isRetweet ? UIColor.whiteColor() : kWBCellInnerViewColor
    }
    
    //只有点击头像和姓名的时候跳转
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
      self.backgroundColor = kWBCellInnerViewHighlightColor
    }
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.backgroundColor = self._isRetweet ? UIColor.whiteColor() : kWBCellInnerViewColor
        self.cell.delegate.cellDidClickCard(self.cell)
    }
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        self.backgroundColor = self._isRetweet ? UIColor.whiteColor() : kWBCellInnerViewColor
    }

}
