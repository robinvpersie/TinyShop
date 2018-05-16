//
//  YCWebViewController.swift
//  Portal
//
//  Created by PENG LIN on 2016/12/16.
//  Copyright © 2016年 linpeng. All rights reserved.
//

import UIKit
import WebKit
import MBProgressHUD
import SnapKit

fileprivate let callback = "historyBack"
fileprivate let callLogin = "callLogin"
fileprivate let callScript = "callScript"
fileprivate let callShare = "shareAsMessenger"

class YCWebViewController: BaseViewController {
    
    enum backType {
        case pop
        case dismiss
    }
    
    var backtype: backType = .pop
    var webView: WKWebView!
    var url: URL!
    var progressView: UIProgressView!
    lazy var shareView: SocailView = SocailView()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    @objc (initWithURL:)
    convenience init(url:URL) {
        self.init()
        self.url = url
    }
    
    convenience init(urlConvertible: YCURLConvertible) {
        self.init()
        self.url = urlConvertible.asURL()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let config = WKWebViewConfiguration()
        webView = WKWebView(frame:.zero, configuration: config)
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        view.addSubview(webView)
        webView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        if #available(iOS 11.0, *) {
            webView.scrollView.contentInsetAdjustmentBehavior = .never
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        } else {
            automaticallyAdjustsScrollViewInsets = false
            webView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
            webView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true
        }
        
        progressView = UIProgressView()
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.progressTintColor = UIColor.navigationbarColor
        progressView.trackTintColor = UIColor.clear
        view.addSubview(progressView)
        progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        if #available(iOS 11.0, *) {
            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        } else {
            progressView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        }
        progressView.heightAnchor.constraint(equalToConstant: 2)
        
        refresh()

    }
    
    func refresh(){
        webView.load(URLRequest(url: url))
    }
    
    override func yc_back() {
        switch backtype {
        case .pop:
            navigationController?.popViewController(animated: true)
        case .dismiss:
            dismiss(animated: true, completion: nil)
        }
    }

    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        progressView.progress = Float(webView.estimatedProgress)
        if keyPath == "estimatedProgress" && webView.estimatedProgress == 1.0 {
                UIView.animate(withDuration: 0.25, animations: {
                    self.progressView.isHidden = true
                })
        }
    }
    
   


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
    }
}



extension YCWebViewController:WKNavigationDelegate{

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
       let requestUrlHost = navigationAction.request.url?.host
       if requestUrlHost == callback {
           decisionHandler(.allow)
           if self.presentingViewController != nil {
            dismiss(animated: true, completion: nil)
           }else {
            navigationController?.popViewController(animated: true)
           }
       }else if requestUrlHost == callLogin{
             decisionHandler(.allow)
             let login = MemberEnrollController()
             let navi = UINavigationController(rootViewController: login)
             present(navi, animated: true, completion: nil)
        }else if requestUrlHost == callScript {
           decisionHandler(.cancel)
           DispatchQueue.global().async(execute: {
            var script:String!
            let aboString = navigationAction.request.url?.absoluteString
            let valueArray = aboString?.getValurArray()
            if let data = YCAccountModel.getAccount() {
            let dic = data.getAccountDicFromModel(data)
            for (index,x) in valueArray!.enumerated() {
                    let value = dic?[x] as? String
                    if index == 0 {
                        script = x + "("
                    }else if index == 1 {
                        script = script + "'" + value! + "'"
                    }else {
                        script = script + ",'" + value! + "'"
                    }
            }
            script = script + ")"
            DispatchQueue.main.async(execute: {
                webView.evaluateJavaScript(script, completionHandler: nil)
            })
        }
        })
       }else if requestUrlHost == callShare {
            decisionHandler(.allow)
//            if let aboString = navigationAction.request.url?.absoluteString {
//              let utf8 = aboString.utf8encodedString()
//              let valueArray = utf8.getValurArray()
//              shareWithArray(valueArray)
//            }else {
//              self.showMessage("分享错误")
//            }
        }else {
            decisionHandler(.allow)
        }
    }

    func  webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void){
           decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error){
        
        UIView.animate(withDuration: 0.25, animations: {
            self.progressView.isHidden = true
        })

        let userInfo = (error as NSError).userInfo
        if let urlString:URL = userInfo["NSErrorFailingURLKey"] as? URL,urlString.scheme == "yucheng"  {
               return
        }
        showMessage(error.localizedDescription)
        if presentingViewController != nil {
             dismiss(animated: true, completion: nil)
        }else {
            navigationController?.popViewController(animated: true)
        }
     }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        UIView.animate(withDuration: 0.25, animations: {
            self.progressView.isHidden = true
        })

    }
}

extension YCWebViewController:WKUIDelegate{
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
           YCAlert.alert(title: message, message: nil, dismissTitle: "确定", inViewController: self) { 
             completionHandler()
        }
    }
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Swift.Void){
        
           YCAlert.confirmOrCancel(title: message, message: nil, confirmTitle: "确定", cancelTitle: "取消", inViewController: self, withConfirmAction: {
               completionHandler(true)
           }) {
               completionHandler(false)
           }
    }
    
    
}
