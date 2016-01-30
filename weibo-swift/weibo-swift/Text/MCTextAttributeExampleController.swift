//
//  MCTextAttributeExampleController.swift
//  weibo-swift
//
//  Created by 马超 on 15/12/22.
//  Copyright © 2015年 马超. All rights reserved.
//

import UIKit




class MCTextAttributeExampleController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        //添加调试
        MCTextExampleHelper.addDebugOptionToViewController(self)
        
        
        let text :NSMutableAttributedString = NSMutableAttributedString()
        
        
        //阴影
        let one :NSMutableAttributedString = NSMutableAttributedString(string: "Shadow")
        one.font = UIFont.boldSystemFontOfSize(30.0)
        one.color = UIColor.whiteColor()
        let shadow :YYTextShadow = YYTextShadow()
        shadow.color = UIColor(white: 0.000, alpha: 0.490)
        shadow.offset = CGSizeMake(0, 1)
        shadow.radius = 5
        one.textShadow = shadow
        text.appendAttributedString(one)
        text.appendAttributedString(self.padding())
        
        
        //内部阴影
        let two :NSMutableAttributedString = NSMutableAttributedString(string: "Inner Shadow")
        two.font = UIFont.boldSystemFontOfSize(30.0)
        two.color = UIColor.whiteColor()
        let shadowtwo :YYTextShadow = YYTextShadow()
        shadowtwo.color = UIColor(white: 0.000, alpha: 0.490)
        shadowtwo.offset = CGSizeMake(0, 1)
        shadowtwo.radius = 1
        two.textInnerShadow = shadowtwo
        text.appendAttributedString(two)
        text.appendAttributedString(self.padding())
        
        
        //组合阴影
        let three :NSMutableAttributedString = NSMutableAttributedString(string: "Multiple Shadows")
        three.font = UIFont.boldSystemFontOfSize(30.0)
        three.color = UIColor(red: 1.000, green: 0.795, blue: 0.014, alpha: 1.000)
        
        let shadowThree :YYTextShadow = YYTextShadow()
        shadowThree.color = UIColor(white: 0.000, alpha: 0.20)
        shadowThree.offset = CGSizeMake(0, -1)
        shadowThree.radius = 1.5
        
        let subShadowThree :YYTextShadow = YYTextShadow()
        subShadowThree.color = UIColor(white: 1.000, alpha: 0.99)
        subShadowThree.offset = CGSizeMake(0, 1)
        subShadowThree.radius = 1.5
        
        shadowThree.subShadow = subShadowThree
        three.textShadow = shadowThree
        
        let innerShadowThree :YYTextShadow = YYTextShadow()
        innerShadowThree.color = UIColor(red: 0.851, green: 0.311, blue: 0.000, alpha: 0.700)
        innerShadowThree.offset = CGSizeMake(0, 1)
        innerShadowThree.radius = 1
        three.textInnerShadow = innerShadowThree
        
        text.appendAttributedString(three)
        text.appendAttributedString(self.padding())
        
        
        //带背景样式的
        let four :NSMutableAttributedString = NSMutableAttributedString(string: "Background Image")
        four.font = UIFont.boldSystemFontOfSize(30.0)
        four.color = UIColor(red: 1.000, green: 0.795, blue: 0.014, alpha: 1.000)
        
        let size :CGSize = CGSizeMake(20, 20)
        let image :UIImage = UIImage(size: size) { (context :CGContextRef!) -> Void in
            
            let co0 = UIColor(red: 0.054, green: 0.879, blue: 0.000, alpha: 1.000)
            let co1 = UIColor(red: 0.869, green: 1.000, blue: 0.030, alpha: 1.000)
            co0.setFill()
            CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height))
            co1.setStroke()
            CGContextSetLineWidth(context, 2)
            for var i = 0 ; i < Int(size.width) * 2 ; i += 4
            {
                CGContextMoveToPoint(context, CGFloat(i) , -2)
                CGContextAddLineToPoint(context, CGFloat(i - Int(size.height)), size.height + 2)
            }
            CGContextStrokePath(context)

            
        }
        
        four.color = UIColor(patternImage: image)
        
        text.appendAttributedString(four)
        text.appendAttributedString(self.padding())
        
        
        //带边框的
        let five :NSMutableAttributedString = NSMutableAttributedString(string: "Border")
        five.font = UIFont.boldSystemFontOfSize(30.0)
        five.color = UIColor(red: 1.000, green: 0.029, blue: 0.651, alpha: 1.000)
        
        let border :YYTextBorder = YYTextBorder()
        border.strokeColor = UIColor(red: 1.000, green: 0.029, blue: 0.651, alpha: 1.000)
        border.strokeWidth = 3
        border.lineStyle = YYTextLineStyle.PatternCircleDot
        border.cornerRadius = 3
        border.insets = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: -4)
        five.textBackgroundBorder = border
        
        text.appendAttributedString(self.padding())
        text.appendAttributedString(five)
        text.appendAttributedString(self.padding())
        text.appendAttributedString(self.padding())
        text.appendAttributedString(self.padding())
        text.appendAttributedString(self.padding())
        
        
        //带下划线的
        let six :NSMutableAttributedString = NSMutableAttributedString(string: "Link")
        six.font = UIFont.boldSystemFontOfSize(30.0)
        six.color = UIColor(red: 0.093, green: 0.492, blue: 1.000, alpha: 1.000)
        six.underlineColor = six.color
        six.underlineStyle = NSUnderlineStyle.StyleSingle
        
        let sixHiBorder :YYTextBorder = YYTextBorder()
        sixHiBorder.cornerRadius = 3
        sixHiBorder.insets = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: -4)
        sixHiBorder.fillColor = UIColor(white: 0.000, alpha: 0.220)
        
        let highLight :YYTextHighlight = YYTextHighlight()
        highLight.setBorder(sixHiBorder)
        highLight.tapAction = { (containerView :UIView! ,text :NSAttributedString! ,range :NSRange! , rect :CGRect!) -> Void in
        
            //这里是把swift的字符换转换成了nsstring 使用
            let str :NSString = text.string as NSString
            self.showMessage("tap :" + str.substringWithRange(range))
        }
        
        six.setTextHighlight(highLight, range: six.rangeOfAll())
        
        text.appendAttributedString(six)
        text.appendAttributedString(self.padding())
        
        
        //另一种
        let seven :NSMutableAttributedString = NSMutableAttributedString(string: "Another Link")
        seven.font = UIFont.boldSystemFontOfSize(30.0)
        seven.color = UIColor.redColor()
        
        let sevenBorder :YYTextBorder = YYTextBorder()
        sevenBorder.cornerRadius = 50
        sevenBorder.insets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: -10)
        sevenBorder.strokeWidth = 0.5
        sevenBorder.strokeColor = seven.color
        sevenBorder.lineStyle = YYTextLineStyle.Single
        seven.textBackgroundBorder = sevenBorder
        
        let highlightBorder :YYTextBorder = YYTextBorder()
        highlightBorder.strokeWidth = 1
        highlightBorder.strokeColor = UIColor.greenColor()
        highlightBorder.fillColor = seven.color
        
        
        let sevenHighLight :YYTextHighlight = YYTextHighlight()
        sevenHighLight.setColor(UIColor.whiteColor())
        sevenHighLight.setBackgroundBorder(highlightBorder)
        sevenHighLight.tapAction = { (containerView :UIView! ,text :NSAttributedString! ,range :NSRange! , rect :CGRect!) -> Void in
            
            //这里使用swift自带的range来做,
            //在此说明下，，swift中的Range不同于oc中，可以这样理解，其实是相对的思想，下边就是截取距离字符串开始多远距离的的作为起点，，截取距离开始或结尾距离多少的作为结束
            let ra  = Range(start: text.string.startIndex.advancedBy(range.location) , end: text.string.startIndex.advancedBy(range.length + range.location))
            self.showMessage("tap :" + text.string.substringWithRange(ra))
            
        }
        
        seven.setTextHighlight(sevenHighLight, range: seven.rangeOfAll())
        
        text.appendAttributedString(seven)
        text.appendAttributedString(self.padding())
        
        
        
        
        
        
        
        let label :YYLabel = YYLabel()
        label.attributedText = text
        label.width = self.view.width
        label.height = self.view.height - 64
        label.top = 64
        label.textAlignment = NSTextAlignment.Center
        label.textVerticalAlignment = YYTextVerticalAlignment.Center
        label.numberOfLines = 0
        label.backgroundColor = UIColor(white: 0.933, alpha: 1.000)
        self.view.addSubview(label)
        

    }
    
    func padding() -> NSAttributedString
    {
        let padding :NSMutableAttributedString = NSMutableAttributedString(string: "\n\n")
        padding.font = UIFont.systemFontOfSize(4.0)
        return padding
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
