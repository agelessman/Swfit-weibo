//
//  WBStatusComposeController.swift
//  weibo-swift
//
//  Created by 马超 on 16/1/22.
//  Copyright © 2016年 马超. All rights reserved.
//

import UIKit

let kToolbarHeight: CGFloat = 35 + 46

enum WBStatusComposeViewType {
    
    case Status   ///< 发微博
    case Retweet  ///< 转发微博
    case Comment  ///< 发评论
}

class WBStatusComposeController: UIViewController,YYTextViewDelegate,YYTextKeyboardObserver,WBStatusComposeEmoticonViewDelegate {

    
    var type: WBStatusComposeViewType?
    var dismissFunc: (() ->Void)?
    var textView: YYTextView?
    var toolbar: UIView!
    var toolbarBackground: UIView!
    var toolbarPOIButton: UIButton!
    var toolbarGroupButton: UIButton!
    
    var toolbarPictureButton: UIButton!
    var toolbarAtButton: UIButton!
    var toolbarTopicButton: UIButton!
    var toolbarEmoticonButton: UIButton!
    var toolbarExtraButton: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.whiteColor()
        if self.respondsToSelector("setAutomaticallyAdjustsScrollViewInsets:")
        {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        YYTextKeyboardManager.defaultManager().addObserver(self)
        
        self.initNavBar()
        self.initTextView()
        self.initToolbar()
        
  
    }

    deinit {
        YYTextKeyboardManager.defaultManager().removeObserver(self)
    }
    //MARK: 初始化控件
  
    private func initNavBar() {
        
        let button = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.Plain, target: self, action: "cancel")
        button.setTitleTextAttributes([NSFontAttributeName : UIFont.systemFontOfSize(16.0) , NSForegroundColorAttributeName : UIColor(hexString: "4c4c4c")], forState: UIControlState.Normal)
        self.navigationItem.leftBarButtonItem = button
        
        if self.type != nil {
            switch self.type! {
            case WBStatusComposeViewType.Status :
                self.title = "发微博"
            case WBStatusComposeViewType.Retweet :
                self.title = "转发微博"
            case WBStatusComposeViewType.Comment :
                self.title = "发评论"
            }
        }else{
            self.title = "未写明类型"
        }
  
    }

    func initTextView() {
        if self.textView != nil { return }
        self.textView = YYTextView()
        self.textView!.size = CGSizeMake(self.view.width, self.view.height)
        self.textView!.textContainerInset = UIEdgeInsetsMake(12, 16, 12, 16)
        self.textView!.contentInset = UIEdgeInsetsMake(64, 0, kToolbarHeight, 0)
        self.textView!.autoresizingMask = [UIViewAutoresizing.FlexibleWidth , UIViewAutoresizing.FlexibleHeight]
        self.textView!.extraAccessoryViewHeight = kToolbarHeight
        self.textView!.showsVerticalScrollIndicator = false
        self.textView!.alwaysBounceVertical = true
        self.textView!.allowsCopyAttributedString = false
        self.textView!.font = UIFont.systemFontOfSize(17)
        self.textView!.textParser = WBStatusComposeTextParser()
        self.textView!.delegate = self
        self.textView!.inputAccessoryView = UIView()
        
         let modifier = WBTextLinePositionModifier()
        modifier.font = UIFont(name: "Heiti SC", size: 17.0)
        modifier.paddingTop = 12
        modifier.paddingBottom = 12
        modifier.lineHeightMultiple = 1.5

        self.textView!.linePositionModifier = modifier
        
        var placeholderPlainText: String?
        switch self.type! {
        case WBStatusComposeViewType.Status:
            placeholderPlainText = "分享新鲜事..."
        case WBStatusComposeViewType.Retweet:
            placeholderPlainText = "说说分享心得..."
        case WBStatusComposeViewType.Comment:
            placeholderPlainText = "写评论..."
        }

        if let _ = placeholderPlainText {
            let atr = NSMutableAttributedString(string: placeholderPlainText!)
            atr.color = UIColor(hexString: "b4b4b4")
            atr.font = UIFont.systemFontOfSize(17.0)
            self.textView!.placeholderAttributedText = atr
            
        }
        
        self.view.addSubview(self.textView!)
        
  
    }
    
    func initToolbar() {
        if self.toolbar != nil { return }
        
        self.toolbar = UIView()
        self.toolbar.backgroundColor = UIColor.whiteColor()
        self.toolbar.size = CGSizeMake(self.view.width, kToolbarHeight)
        self.toolbar.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        

        self.toolbarBackground = UIView()
        self.toolbarBackground.backgroundColor = UIColor(hexString: "F9F9F9")
        self.toolbarBackground.size = CGSizeMake(self.toolbar.width, 46)
        self.toolbarBackground.bottom = self.toolbar.height
        self.toolbarBackground.autoresizingMask = [UIViewAutoresizing.FlexibleWidth,UIViewAutoresizing.FlexibleHeight]
        self.toolbar.addSubview(self.toolbarBackground)
        
        self.toolbarBackground.height = 300 // extend
        
        let line = UIView()
        line.backgroundColor = UIColor(hexString: "BFBFBF")
        line.width = self.toolbarBackground.width
        line.height = CGFloatFromPixel(1)
        line.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        self.toolbarBackground.addSubview(line)
     
    

        self.toolbarPOIButton = UIButton()
        self.toolbarPOIButton.size = CGSizeMake(88, 26)
        self.toolbarPOIButton.centerY = 35.0 / 2.0
        self.toolbarPOIButton.left = 5
        self.toolbarPOIButton.clipsToBounds = true
        self.toolbarPOIButton.layer.cornerRadius = self.toolbarPOIButton.height / 2
        self.toolbarPOIButton.layer.borderColor = UIColor(hexString: "e4e4e4").CGColor
        self.toolbarPOIButton.layer.borderWidth = CGFloatFromPixel(1)
        self.toolbarPOIButton.titleLabel?.font = UIFont.systemFontOfSize(14.0)
        self.toolbarPOIButton.adjustsImageWhenHighlighted = false
        self.toolbarPOIButton.setTitle("显示位置 ", forState: UIControlState.Normal)
        self.toolbarPOIButton.setTitleColor(UIColor(hexString: "939393"), forState: UIControlState.Normal)
        self.toolbarPOIButton.setImage(WBStatusHelper.imageNamed("compose_locatebutton_ready"), forState: UIControlState.Normal)
        self.toolbarPOIButton.setBackgroundImage(UIImage(color: UIColor(hexString: "f8f8f8")), forState: UIControlState.Normal)
        self.toolbarPOIButton.setBackgroundImage(UIImage(color: UIColor(hexString: "e0e0e0")), forState: UIControlState.Highlighted)
        self.toolbar.addSubview(self.toolbarPOIButton)
        
        
        self.toolbarGroupButton = UIButton()
        self.toolbarGroupButton.size = CGSizeMake(62, 26)
        self.toolbarGroupButton.centerY = 35.0 / 2.0
        self.toolbarGroupButton.right = self.toolbar.width - 5
        self.toolbarGroupButton.autoresizingMask = UIViewAutoresizing.FlexibleLeftMargin
        self.toolbarGroupButton.clipsToBounds = true
        self.toolbarGroupButton.layer.cornerRadius = self.toolbarGroupButton.height / 2
        self.toolbarGroupButton.layer.borderColor = UIColor(hexString: "e4e4e4").CGColor
        self.toolbarGroupButton.layer.borderWidth = CGFloatFromPixel(1)
        self.toolbarGroupButton.titleLabel?.font = UIFont.systemFontOfSize(14.0)
        self.toolbarGroupButton.adjustsImageWhenHighlighted = false
        self.toolbarGroupButton.setTitle("公开 ", forState: UIControlState.Normal)
        self.toolbarGroupButton.setTitleColor(UIColor(hexString: "527ead"), forState: UIControlState.Normal)
        self.toolbarGroupButton.setImage(WBStatusHelper.imageNamed("compose_publicbutton"), forState: UIControlState.Normal)
        self.toolbarGroupButton.setBackgroundImage(UIImage(color: UIColor(hexString: "f8f8f8")), forState: UIControlState.Normal)
        self.toolbarGroupButton.setBackgroundImage(UIImage(color: UIColor(hexString: "e0e0e0")), forState: UIControlState.Highlighted)
        self.toolbar.addSubview(self.toolbarGroupButton)
      
        
        self.toolbarPictureButton = self.toolbarButtonWithImage("compose_toolbar_picture", highlight: "compose_toolbar_picture_highlighted")
        self.toolbarAtButton = self.toolbarButtonWithImage("compose_mentionbutton_background", highlight: "compose_mentionbutton_background_highlighted")
        self.toolbarTopicButton = self.toolbarButtonWithImage("compose_trendbutton_background", highlight: "compose_trendbutton_background_highlighted")
        self.toolbarEmoticonButton = self.toolbarButtonWithImage("compose_emoticonbutton_background", highlight: "compose_emoticonbutton_background_highlighted")
        self.toolbarExtraButton = self.toolbarButtonWithImage("message_add_background", highlight: "message_add_background_highlighted")
        
        let one: CGFloat = self.toolbar.width / 5
        self.toolbarPictureButton.centerX = one * 0.5
        self.toolbarAtButton.centerX = one * 1.5
        self.toolbarTopicButton.centerX = one * 2.5
        self.toolbarEmoticonButton.centerX = one * 3.5
        self.toolbarExtraButton.centerX = one * 4.5
        
        self.toolbar.bottom = self.view.height
        self.view.addSubview(self.toolbar)
       
    }
    
    
    func toolbarButtonWithImage(imageName: String , highlight highlightImageName: String) -> UIButton {
        
        let button = UIButton()
        button.exclusiveTouch = true
        button.size = CGSizeMake(46, 46)
        button.setImage(WBStatusHelper.imageNamed(imageName), forState: UIControlState.Normal)
        button.setImage(WBStatusHelper.imageNamed(highlightImageName), forState: UIControlState.Highlighted)
        button.centerY = 46 / 2
        button.autoresizingMask = [UIViewAutoresizing.FlexibleLeftMargin ,UIViewAutoresizing.FlexibleRightMargin]
        button.addTarget(self, action: "buttonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        self.toolbarBackground.addSubview(button)
        return button;
    }
    //MARK:点击事件
    
    func cancel() {
        
        self.view.endEditing(true)
        if let _ = self.dismissFunc { self.dismissFunc!() }
    }

    func buttonClicked(sender: UIButton) {
        
        switch sender {
        case self.toolbarPictureButton :
            return
        case self.toolbarAtButton :
            let atArray: NSArray = ["@张飞 ", "@李逵 ", "@猪八戒 ", "@james " , "@张无忌 ", "@皇上驾到 "]
           let atStr = atArray.randomObject()
           self.textView?.replaceRange((self.textView?.selectedTextRange)!, withText: atStr as! String)
        case self.toolbarTopicButton :
            let topicArray: NSArray = ["#冰雪奇缘[电影]# ", "#Let It Go[音乐]# ", "#纸牌屋[图书]# ", "#北京·理想国际大厦[地点]# " , "#腾讯控股 kh00700[股票]# ", "#WWDC# "]
            let topicStr = topicArray.randomObject()
            self.textView?.replaceRange((self.textView?.selectedTextRange)!, withText: topicStr as! String)
        case self.toolbarExtraButton :
            return
        case self.toolbarEmoticonButton :
            
            if self.textView!.inputView != nil {
                self.textView!.inputView = nil
                self.textView!.reloadInputViews()
                self.textView!.becomeFirstResponder()
            self.toolbarEmoticonButton.setImage(WBStatusHelper.imageNamed("compose_emoticonbutton_background"), forState: UIControlState.Normal)
            self.toolbarEmoticonButton.setImage(WBStatusHelper.imageNamed("compose_emoticonbutton_background_highlighted"), forState: UIControlState.Highlighted)
            }else{
                
                let v = WBEmoticonInputView()
                v.delegate = self
                self.textView!.inputView = v
                self.textView!.reloadInputViews()
                self.textView!.becomeFirstResponder()
            self.toolbarEmoticonButton.setImage(WBStatusHelper.imageNamed("compose_keyboardbutton_background"), forState: UIControlState.Normal)
            self.toolbarEmoticonButton.setImage(WBStatusHelper.imageNamed("compose_keyboardbutton_background_highlighted"), forState: UIControlState.Highlighted)
            }
  
          
        default:
            break
        }
    }
    
    //MARK: textviewDelegate
    func textViewDidChange(textView: YYTextView!) {
        
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    

    //MAEK: protocol YYTextKeyboardObserver
    func keyboardChangedWithTransition(transition: YYTextKeyboardTransition) {
        
        let toFrame = YYTextKeyboardManager.defaultManager().convertRect(transition.toFrame, toView: self.view)
  
        if (transition.animationDuration == 0) {
            self.toolbar.bottom = CGRectGetMinY(toFrame)
        } else {
            UIView.animateWithDuration(transition.animationDuration, delay: 0, options: [UIViewAnimationOptions.BeginFromCurrentState,transition.animationOption], animations: { () -> Void in
                self.toolbar.bottom = CGRectGetMinY(toFrame)
                }, completion: nil)
        
        }
    }
    
    //MARK: 表情的代理
    func emoticonInputDidTapText(text: String) {

       self.textView!.replaceRange(self.textView!.selectedTextRange!, withText: text)
    }
    
    func emoticonInputDidTapBackspace() {
        self.textView!.deleteBackward()
    }
}
