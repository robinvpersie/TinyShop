//
//  EatWebController.swift
//  Portal
//
//  Created by PENG LIN on 2017/4/27.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit
import WebKit
import Alamofire
import MBProgressHUD


extension EatWebController:WKUIDelegate {
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
         YCAlert.alert(title: message, message: nil, dismissTitle: "确定", inViewController: nil) {}
    }
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Swift.Void){
            completionHandler(false)
    }


}

extension EatWebController:WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
         let requestUrlHost = navigationAction.request.url?.host
         if requestUrlHost == "closeWeb" {
            guard let navi = self.navigationController else {
                decisionHandler(.allow)
                return
            }
            navi.popViewController(animated: true)
         }else if requestUrlHost == "callCustomCenter" {
            CheckToken.chekcTokenAPI(completion: { (result) in
                switch result {
                case .success(let check):
                    if check.status == "1" {
                        let account = YCAccountModel.getAccount()
                        let phone = check.custom_code
                        let password = account?.password ?? ""
                        guard let openUrl = URL(string: "ycapp://contactService$\(phone)$\(password)$18229587471")
                         else {
                            return
                         }
                        if UIApplication.shared.canOpenURL(openUrl) {
                            UIApplication.shared.openURL(openUrl)
                        }else {
                           self.showMessage("未安装龙聊")
                        }
                    }else {
                        self.goToLogin()
                    }
                case .failure(_):
                      break
                }
            })
           }
         decisionHandler(.allow)
      }
    
    func  webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void){
        
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.title = webView.title
    }
}


class EatWebController: CanteenBaseViewController {
    
    fileprivate lazy var YCWebView:WKWebView = {
        let webview = WKWebView(frame: CGRect.zero)
        webview.uiDelegate = self
        webview.navigationDelegate = self
        if let request = try? self.url.asURLRequest(){
            webview.load(request)
        }
        return webview
    }()
    
    fileprivate lazy var progress:UIProgressView = {
        let progressView = UIProgressView()
        progressView.progressTintColor = UIColor.navigationbarColor
        progressView.trackTintColor = UIColor.clear
        return progressView
    }()
    
    var url:URLRequestConvertible!
    var hideNavigation:Bool?
    convenience init(url:URLRequestConvertible) {
        self.init()
        self.url = url
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let ishide = hideNavigation {
          self.navigationController?.setNavigationBarHidden(ishide, animated: false)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(YCWebView)
        YCWebView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        YCWebView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        view.addSubview(progress)
        progress.snp.makeConstraints { (make) in
             make.leading.trailing.equalTo(view)
             make.top.equalTo(view).offset(64)
             make.height.equalTo(2)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        self.progress.progress = Float(self.YCWebView.estimatedProgress)
        if keyPath == "estimatedProgress" {
            if self.progress.progress == 1 {
               self.progress.isHidden = true
            }else {
               self.progress.isHidden = false 
            }
        }
    }
    
    deinit {
        self.YCWebView.removeObserver(self, forKeyPath: "estimatedProgress")
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
