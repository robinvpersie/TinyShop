//
//  LUGwebViewController.swift
//  Portal
//
//  Created by dlwpdlr on 2018/4/12.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit
import SnapKit
import  MBProgressHUD

class LGwebViewController: BaseViewController,UIWebViewDelegate {
	var lguPlusView :UIWebView!
	var hud:MBProgressHUD = MBProgressHUD()
	let storeURL:String = "http://lgpay.gigawon.co.kr:8083/?OrderNumber=%@&OrderMoney=%@&OrderUserName=%@&GiftInfo=%@"
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setNav()
		
	}
	
	public func loadRequestUrl(OrderNumber:String,OrderMoney:String,OrderUserName:String,GiftInfo:String){
		if self.lguPlusView == nil {
			self.lguPlusView = UIWebView()
			self.lguPlusView.delegate = self
			self.view.addSubview(self.lguPlusView)
			self.lguPlusView.snp.makeConstraints { (make) in
				make.edges.equalToSuperview()
			}
			
			let loadurl = String.init(format: storeURL,OrderNumber,OrderMoney,OrderUserName,GiftInfo)
			self.lguPlusView.loadRequest(URLRequest(url: URL.init(string: loadurl)!))

		}
	}
	
	private func setNav(){
		let titleview = UILabel()
		titleview.text = "LG+ Pay"
		self.navigationItem.titleView = titleview
		
		
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
}
extension LGwebViewController{
	
	func webViewDidStartLoad(_ webView: UIWebView) {
		
		hud.show(animated: true)
	}
	
	func webViewDidFinishLoad(_ webView: UIWebView) {
		hud.hide(animated: true)
	}
	func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
		return true
	}
	
}
