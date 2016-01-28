//
//  MCWebImageExampleCell.swift
//  weibo-swift
//
//  Created by 马超 on 15/12/22.
//  Copyright © 2015年 马超. All rights reserved.
//

import UIKit

protocol MCWebImageExampleCellDataSource{
    var imageUrl :NSURL { get }
}

class MCWebImageExampleCell: UITableViewCell {

    let webImageView :YYAnimatedImageView!
    let indicator :UIActivityIndicatorView!
    let progressLayer :CAShapeLayer!
    let label :UILabel!
    
    private var dataSource :MCWebImageExampleCellDataSource?

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        webImageView = YYAnimatedImageView()
        indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        progressLayer = CAShapeLayer()
        label = UILabel()
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor.clearColor()
        self.contentView.backgroundColor = UIColor.clearColor()
        self.size = CGSizeMake(UIScreen.mainScreen().bounds.size.width, kcellHeight)
        self.contentView.size = self.size
        
        //设置imageView
        webImageView.size = self.size
        webImageView.clipsToBounds = true
        webImageView.contentMode = UIViewContentMode.ScaleAspectFill
        webImageView.backgroundColor = UIColor.whiteColor()
        self.contentView.addSubview(webImageView)
        
        //设置label
        label.size = self.size;
        label.text = "Load fail, tap to reload."
        label.textAlignment = NSTextAlignment.Center
        label.textColor = UIColor(white: 0.7, alpha: 1.0)
        label.hidden = true
        label.userInteractionEnabled = true
        self.contentView.addSubview(label)
        
        //设置进度条
        let lineHeight :CGFloat = 4.0
        progressLayer.size = CGSizeMake(webImageView.width, lineHeight)
        let path :UIBezierPath = UIBezierPath()
        path.moveToPoint(CGPointMake(0, progressLayer.height / 2.0))
        path.addLineToPoint(CGPointMake(webImageView.width, progressLayer.height / 2.0))
        progressLayer.lineWidth = lineHeight
        progressLayer.path = path.CGPath
        progressLayer.strokeColor = UIColor(red: 0.000, green: 0.640, blue: 1.000, alpha: 0.720).CGColor
        progressLayer.lineCap = kCALineCapButt
        progressLayer.strokeStart = 0.0
        progressLayer.strokeEnd = 0.0
        webImageView.layer.addSublayer(progressLayer)
        
        
        //添加手势
        let tap :UITapGestureRecognizer = UITapGestureRecognizer { (sender) -> Void in
            self.configure(self.webImageView.imageURL)
        }
        self.label.addGestureRecognizer(tap)
        

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //公开的cell配置方法
//    func configure(dataSource :MCWebImageExampleCellDataSource?)
//    {
//        self.dataSource = dataSource
//        
//    }
    //由于本cell需求的参数比较简单，不需要使用协议编程
    func configure(dataSource :NSURL?)
    {
        label.hidden = true
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        self.progressLayer.strokeEnd = 0
        self.progressLayer.hidden = true
        CATransaction.commit()
        
        
        self.webImageView.setImageWithURL(dataSource!, placeholder: nil, options: [YYWebImageOptions.ProgressiveBlur,YYWebImageOptions.ShowNetworkActivity,YYWebImageOptions.SetImageWithFadeAnimation], progress: { (receivedSize, expectedSize) -> Void in
            
            if receivedSize > 0 && expectedSize > 0
            {
                var progress :CGFloat =  CGFloat(receivedSize) / CGFloat(expectedSize)
                progress = progress < 0 ? 0 : progress > 1 ? 1 : progress
                
                if self.progressLayer.hidden
                {
                    self.progressLayer.hidden = false
                }
                
                self.progressLayer.strokeEnd = progress
                
            }
            
            }, transform: nil) { (image, url, from, stage, error) -> Void in
                
                if stage == YYWebImageStage.Finished
                {
                    self.progressLayer.hidden = true
                    if image == nil
                    {
                        self.label.hidden = false
                    }
                }
        }
        
    }
}
