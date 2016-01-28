//
//  YYSimpleWebViewController.swift
//  weibo-swift
//
//  Created by 马超 on 16/1/15.
//  Copyright © 2016年 马超. All rights reserved.
//

import UIKit



class YYSimpleWebViewController: UIViewController,UIWebViewDelegate,UIGestureRecognizerDelegate {

     var urlS :NSURL?
     var cusWebView :UIWebView!
     var  isLoaded = false
     let cover = UIView()
    
     init(WithUrl webUrl :NSURL?) {
        super.init(nibName: nil, bundle: nil)
        self.urlS = webUrl
        cusWebView = UIWebView()
        cusWebView.delegate = self
        NSURLCache.sharedURLCache().removeAllCachedResponses()
        NSURLCache.sharedURLCache().diskCapacity = 0
        NSURLCache.sharedURLCache().memoryCapacity = 0
    
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        cusWebView.frame = self.view.bounds
        self.view.addSubview(cusWebView)
        
        
        cover.backgroundColor          = UIColor.clearColor()
        cover.frame                    = cusWebView.bounds;
        cusWebView.scrollView.addSubview(cover)

        print(cusWebView.gestureRecognizers)
        let doubleTap                  = UITapGestureRecognizer(target: self, action: "tap")
        doubleTap.numberOfTapsRequired = 2
        doubleTap.delegate             = self
        cover.addGestureRecognizer(doubleTap)
        
        if self.urlS != nil {
           
             cusWebView.loadRequest(NSURLRequest(URL: self.urlS!))
        }
       
        
    }
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return true
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        
        self.cover.removeFromSuperview()
        self.title = webView.stringByEvaluatingJavaScriptFromString("document.title")
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        self.cover.removeFromSuperview()
    }
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        
        return true
    }
   
 
    func tap() {
        
    }
}
