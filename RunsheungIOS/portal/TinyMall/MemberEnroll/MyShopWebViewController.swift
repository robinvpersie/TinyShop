//
//  MyShopWebViewController.swift
//  Portal
//
//  Created by dlwpdlr on 2018/4/16.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit
import SnapKit

class MyShopWebViewController : UIViewController {
	var webview:UIWebView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setNav()
		
	}
	
	private func setNav(){
		
		navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.leftarrow?.withRenderingMode(.alwaysOriginal),
														   style: .plain,
														   target: self,
														   action: #selector(returnPreController))
	}
	
	@objc private func returnPreController(){
		if self.webview.canGoBack {
			self.webview.goBack()
		}else{
			self.navigationController?.popViewController(animated: true)
		}
	}
	
	@objc public func loadRulesWeb(loadurl:String){
		if self.webview == nil {
			self.webview = UIWebView()
			self.webview.delegate = self
			self.view.addSubview(self.webview)
			self.webview.snp.makeConstraints { (make) in
				make.edges.equalToSuperview()
			}
			
			self.webview.loadRequest(URLRequest(url: URL(string: loadurl)!))
		}
	}
	
	
}

extension MyShopWebViewController :UIWebViewDelegate{
	func webViewDidStartLoad(_ webView: UIWebView) {
		
		
	}
	
	func webViewDidFinishLoad(_ webView: UIWebView) {
		
	}
	
	func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
		return true
	}
	
}
