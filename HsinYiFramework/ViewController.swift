//
//  ViewController.swift
//  HsinYiFramework
//
//  Created by giming on 2017/9/8.
//  Copyright © 2017年 Hsin-Yi. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler {
    
    var wk: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let path = Bundle.main.path(forResource: "index", ofType: ".html", inDirectory: "HTML5")
        let url = URL(fileURLWithPath: path!)
        let request = URLRequest(url: url)
        
        // 提供 JS 調用的窗口
        let conf = WKWebViewConfiguration()
        conf.userContentController.add(self, name: "interOp")
        

        // 不占用頂端的 stausBar
        let frame = CGRect(x:0, y:20, width:UIScreen.main.bounds.width, height:UIScreen.main.bounds.height)
        wk = WKWebView(frame: frame)
        // 禁用最頂端下拉拖動的效果
        wk.scrollView.bounces = false
    
//        self.wk.load(URLRequest(url: URL(string: "http://m.piaotian.com/")!))
        
        // 加載頁面
        wk.load(request)
        wk.navigationDelegate = self
        wk.uiDelegate = self

        view.addSubview(wk)
        
    }
    
    // 回應 JS 的調用
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print(message.body)

    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("didFail :" + error.localizedDescription)
    }
    

    
    func webView(_ webView: WKWebView, didFinish: WKNavigation!) {
        print(self.wk.title!)
        self.wk.evaluateJavaScript("showAlert('奏是一个弹框')") { (item, error) in
            // 闭包中处理是否通过了或者执行JS错误的代码
        self.wk.evaluateJavaScript("alert('yes')", completionHandler: nil)
        }
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("didFailProvisionalNavigation :" + error.localizedDescription)
    }
    
    
    // HTML頁面 Alert時調用
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let ac = UIAlertController(title: webView.title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        ac.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: { (a) -> Void in
            completionHandler()
        }))
        
        self.present(ac, animated: true, completion: nil)
    }
    
    
    // HTML頁面 Confirm 時調用
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let ac = UIAlertController(title: webView.title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        ac.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler:
            { (ac) -> Void in
                completionHandler(true)  // 按[確定]時傳 true
        }))
        
        ac.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler:
            { (ac) -> Void in
                completionHandler(false)  // 按[取消]時傳 true
        }))
        
        self.present(ac, animated: true, completion: nil)

    }
    
    
    
   
   

}

