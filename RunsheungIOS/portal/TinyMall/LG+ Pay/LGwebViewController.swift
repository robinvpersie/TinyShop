//
//  LUGwebViewController.swift
//  Portal
//
//  Created by dlwpdlr on 2018/4/12.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit
import SnapKit
import MBProgressHUD

class LGwebViewController: UIViewController,UIWebViewDelegate {
	var lguPlusView :UIWebView!
	var hud:MBProgressHUD = MBProgressHUD()
	let storeURL:String = "http://lgpay.gigawon.co.kr:8083/?OrderNumber=%@&OrderMoney=%@&OrderUserName=%@&GiftInfo=%@"
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setNav()
		
		
	}
	
	@objc public func loadRequestUrl(OrderNumber:String,OrderMoney:String,OrderUserName:String,GiftInfo:String){
		if self.lguPlusView == nil {
			self.lguPlusView = UIWebView()
			self.lguPlusView.delegate = self
			self.view.addSubview(self.lguPlusView)
			self.lguPlusView.snp.makeConstraints { (make) in
				make.edges.equalToSuperview()
			}
			hud = MBProgressHUD .showAdded(to: self.view, animated: true)
			let loadurl = String.init(format: storeURL,OrderNumber,OrderMoney,OrderUserName,GiftInfo)
			self.lguPlusView.loadRequest(URLRequest(url: URL.init(string: loadurl)!))

		}
	}
	
	private func setNav(){
		let titleview = UILabel()
		titleview.text = "U+"
		self.navigationItem.titleView = titleview
		navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.leftarrow?.withRenderingMode(.alwaysOriginal),
														   style: .plain,
														   target: self,
														   action: #selector(returnPreController))

	}
	
	@objc private func returnPreController(){
		if self.lguPlusView.canGoBack {
			self.lguPlusView.goBack()
		}else{
			self.navigationController?.popViewController(animated: true)
		}
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
}
extension LGwebViewController{
	
	func webViewDidStartLoad(_ webView: UIWebView) {
		
		
	}
	
	func webViewDidFinishLoad(_ webView: UIWebView) {
		hud.hide(animated: true)
	}
	
	func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
		let device = UIDevice.current
		var backgroundSupported:Bool = false
		backgroundSupported = device.isMultitaskingSupported
		if !backgroundSupported {
			let alert = UIAlertView(title:"안 내", message: "멀티테스킹을 지원하는 기기 또는 어플만  공인인증서비스가 가능합니다.", delegate: nil, cancelButtonTitle: "OK", otherButtonTitles: "")
			alert.show()
			return true

		}
		let reqUrl = request.url?.absoluteString
		let sh_url = "http://itunes.apple.com/us/app/id360681882?mt=8"
		let sh_url2  = "https://itunes.apple.com/kr/app/sinhan-mobilegyeolje/id572462317?mt=8"
		let hd_url = "http://itunes.apple.com/kr/app/id362811160?mt=8"
		let sh_appname = "smshinhanansimclick"
		let sh_appname2 = "shinhan-sr-ansimclick"
		let hd_appname = "smhyundaiansimclick"
		let lottecard = "lottesmartpay"
		if (reqUrl?.hasPrefix("ispmobile://"))! {
			UIApplication.shared.open(request.url!, options: [:], completionHandler: nil)

		}
		if (reqUrl?.hasPrefix("smartxpay-transfer://"))! {

			UIApplication.shared.open(request.url!, options: [:], completionHandler: nil)
			
		}

		if (reqUrl?.hasPrefix("paypin://"))! {
			UIApplication.shared.open(request.url!, options: [:], completionHandler: nil)
		}

		if (reqUrl?.hasPrefix("uppay://uppayservice"))! {
			UIApplication.shared.open(request.url!, options: [:], completionHandler: nil)
		}
		if reqUrl == hd_url {
			UIApplication.shared.open(request.url!, options: [:], completionHandler: nil)
			return false
		}

		if (reqUrl?.hasPrefix(hd_appname))! {
			UIApplication.shared.open(request.url!, options: [:], completionHandler: nil)
			return false
		}
	
		if reqUrl == sh_url {
			UIApplication.shared.open(request.url!, options: [:], completionHandler: nil)
			return false
		}
		
		if (reqUrl?.hasPrefix(sh_appname))! {
			UIApplication.shared.open(request.url!, options: [:], completionHandler: nil)
			return false
		}

		if reqUrl == sh_url2 {
			UIApplication.shared.open(request.url!, options: [:], completionHandler: nil)
			return false
		}
		
		if (reqUrl?.hasPrefix(sh_appname2))! {
			UIApplication.shared.open(request.url!, options: [:], completionHandler: nil)
			return false
		}
		if (reqUrl?.hasPrefix(lottecard))! {
			UIApplication.shared.open(request.url!, options: [:], completionHandler: nil)
			return false
		}

		let nh_url = "https://itunes.apple.com/kr/app/nhansimkeullig/id609410702?mt=8"
		let nh_appname = "nonghyupcardansimclick"
		if ( reqUrl == nh_url){
			UIApplication.shared.open(request.url!, options: [:], completionHandler: nil)
			return false;
		}
		if ( reqUrl == nh_appname){
			UIApplication.shared.open(request.url!, options: [:], completionHandler: nil)
			return false;
		}

	
		
		return true
	}
	
	 }
