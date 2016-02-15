//
//  TWStatusQuoteView.swift
//  weibo-swift
//
//  Created by 马超 on 16/2/4.
//  Copyright © 2016年 马超. All rights reserved.
//

import UIKit

class TWStatusQuoteView: YYControl {


     var cell: TWeetCell!
    var nameLabel: YYLabel!
    var textLabel: YYLabel!
    
    

    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        
        self.width = kTWContentWidth
        self.clipsToBounds = true
        self.layer.cornerRadius = 2
        self.layer.borderColor = UIColor(white: 0.000, alpha: 0.108).CGColor;
        self.layer.borderWidth = CGFloatFromPixel(1)
        self.exclusiveTouch = true
        
        
        self.nameLabel = YYLabel()
        self.nameLabel.textVerticalAlignment = YYTextVerticalAlignment.Center
        self.nameLabel.displaysAsynchronously = true
        self.nameLabel.ignoreCommonProperties = true
        self.nameLabel.fadeOnHighlight = false
        self.nameLabel.fadeOnAsynchronouslyDisplay = false
        self.nameLabel.width = kTWQuoteContentWidth
        self.nameLabel.left = kTWCellPadding
        self.addSubview(self.nameLabel)
        
        self.textLabel = YYLabel()
        self.textLabel.textVerticalAlignment = YYTextVerticalAlignment.Center
        self.textLabel.displaysAsynchronously = true
        self.textLabel.ignoreCommonProperties = true
        self.textLabel.fadeOnHighlight = false
        self.textLabel.fadeOnAsynchronouslyDisplay = false
        self.textLabel.width = kTWQuoteContentWidth
        self.textLabel.left = kTWCellPadding
        self.addSubview(self.textLabel)
        
        
        self.touchBlock =  { (view :YYControl,  state :YYGestureRecognizerState, touches :NSSet , even :UIEvent ) -> Void in
            
            if state == YYGestureRecognizerState.Began {
                
                self.backgroundColor = kTWCellBGHighlightColor
                
            }else if state != YYGestureRecognizerState.Moved {
                
                self.backgroundColor = UIColor.clearColor()
                
            }
            
            if state == YYGestureRecognizerState.Ended {
                
                let touch = touches.anyObject()! as! UITouch
                let p = touch.locationInView(self)
                
                if CGRectContainsPoint(self.bounds, p) {
                    
                    if let _ = self.cell.delegate {
                        
                        self.cell.delegate!.cell(self.cell, didClickQuoteWithLongPress: false)
                        
                    }
                    
                }
                
            }
           
        }
        
     
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setWithLayout(layout: TWLayout) {
        
        self.nameLabel.height = kTWUserNameFontSize * 2
        self.nameLabel.centerY = kTWCellPadding + kTWUserNameFontSize / 2
        self.nameLabel.textLayout = layout.quotedNameTextLayout
        
        self.textLabel.height = CGRectGetMaxY(layout.quotedTextLayout!.textBoundingRect)
        self.textLabel.top = kTWCellPadding + kTWUserNameFontSize + kTWCellInnerPadding
        self.textLabel.textLayout = layout.quotedTextLayout
        
    }
}
