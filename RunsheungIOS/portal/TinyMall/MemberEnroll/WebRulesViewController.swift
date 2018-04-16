//
//  WebRulesViewController.swift
//  Portal
//
//  Created by dlwpdlr on 2018/4/16.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit
import SnapKit

class WebRulesViewController: UIViewController {
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
			self.dismiss(animated: true, completion: nil)
		}
	}

   @objc public	func loadRulesWeb(loadurl:String){
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

extension WebRulesViewController:UIWebViewDelegate{
	func webViewDidStartLoad(_ webView: UIWebView) {
		
		
	}
	
	func webViewDidFinishLoad(_ webView: UIWebView) {
		
	}
	
	func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
		return true
	}
	
}
