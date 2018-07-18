//
//  DataStatisticsDatePicker.swift
//  Portal
//
//  Created by dlwpdlr on 2018/6/21.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import UIKit

class DataStatisticsDatePicker: UIView {
	var maskview:UIImageView = UIImageView()
	var choiceView:UIView = UIView()
	var datePicker1:UIDatePicker?
	var datePicker2:UIDatePicker?
	var choicePickerMap:(String,String)->Void = { (picker1:String,picker2:String)->Void in }

	override init(frame: CGRect) {
		super.init(frame: frame)
		createSuv()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func createSuv(){
		
		self.backgroundColor = UIColor.white
		self.layer.cornerRadius = 5
		self.layer.masksToBounds = true
		
		self.maskview.backgroundColor = UIColor.black
		self.maskview.alpha = 0.3
		self.maskview.isUserInteractionEnabled = true
		let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(cancelAction))
		self.maskview.addGestureRecognizer(tap)
		UIApplication.shared.delegate?.window??.addSubview(self.maskview)
		self.maskview.snp.makeConstraints { (make) in
			
			make.edges.equalToSuperview()
		}
		
		let cancel:UIButton = UIButton()
		cancel.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
		cancel.setImage(UIImage(named: "icon_close_date"), for: .normal)
		self.addSubview(cancel)
		cancel.snp.makeConstraints { (make) in
			make.right.equalToSuperview().offset(-15)
			make.top.equalToSuperview().offset(15)
			make.width.height.equalTo(25)
		}
		
		let title:UILabel = UILabel()
		title.text = "自定查询区间".localized
		title.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight(rawValue: 0.4))
		self.addSubview(title)
		title.snp.makeConstraints { (make) in
			make.centerX.equalToSuperview()
			make.top.equalToSuperview().offset(30)
		}
		
		let startlabel:UILabel = UILabel()
		startlabel.text = "从".localized
		startlabel.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight(rawValue: 0.2))
		self.addSubview(startlabel)
		startlabel.snp.makeConstraints { (make) in
			make.centerX.equalToSuperview()
			make.top.equalTo(title.snp.bottom).offset(20)
		}
		
		self.datePicker1 = createDatePicker()
		self.datePicker1?.snp.makeConstraints({ (make) in
			make.top.equalTo(startlabel.snp.bottom).offset(5)
			make.left.equalToSuperview().offset(30)
			make.right.equalToSuperview().offset(-30)
			make.height.equalTo(100)
		})
		
		let endlabel:UILabel = UILabel()
		endlabel.text = "至".localized
		endlabel.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight(rawValue: 0.2))
		self.addSubview(endlabel)
		endlabel.snp.makeConstraints { (make) in
			make.center.equalToSuperview()
		}
		
		self.datePicker2 = createDatePicker()
		self.datePicker2?.snp.makeConstraints({ (make) in
			make.top.equalTo(endlabel.snp.bottom).offset(5)
			make.left.equalToSuperview().offset(30)
			make.right.equalToSuperview().offset(-30)
			make.height.equalTo(100)
		})
		
		let okbtn:UIButton = UIButton()
		okbtn.setTitle("确定".localized, for: .normal)
		okbtn.backgroundColor = UIColor(red: 33, green: 192, blue: 67)
		okbtn.setTitleColor(UIColor.white, for: .normal)
		okbtn.layer.cornerRadius = 5
		okbtn.layer.masksToBounds = true
		okbtn.addTarget(self, action: #selector(sumbit), for: .touchUpInside)
		self.addSubview(okbtn)
		okbtn.snp.makeConstraints({ (make) in
			make.bottom.equalToSuperview().offset(-20)
			make.left.equalToSuperview().offset(30)
			make.right.equalToSuperview().offset(-30)
			make.height.equalTo(40)
		})
		
	}
	
	private func createDatePicker()->UIDatePicker{

		let datepicker:UIDatePicker = UIDatePicker()
		datepicker.locale = Locale(identifier: "zh_CN")
		datepicker.datePickerMode = .date
		datepicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
		self.addSubview(datepicker)

		return datepicker
	}
 }

extension DataStatisticsDatePicker{
	@objc func dateChanged(datePicker : UIDatePicker){
	}
	
	@objc private func sumbit(){
		
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyyMMdd"
		let picker1time:String = (formatter.string(from: (self.datePicker1?.date)!))
		let picker2time:String = (formatter.string(from: (self.datePicker2?.date)!))
 		self.choicePickerMap(picker1time, picker2time)
		self.hidden()

	}
	@objc private func cancelAction(){
		self.hidden()
		
	}
	private func hidden(){
		self.maskview.removeFromSuperview()
		self.removeFromSuperview()
	}

}
