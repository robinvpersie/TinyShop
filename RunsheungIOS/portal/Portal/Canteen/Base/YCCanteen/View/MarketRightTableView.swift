//
//  MarketRightTableView.swift
//  Portal
//
//  Created by PENG LIN on 2017/3/3.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit

class MarketRightTableView: UITableView {
    
    var squarelist:[Squarelis]?{
        didSet{
          reloadData()
        }
    }
    var selectedIndex = 0
    var zipCode:String!
    var selectIndexAction:((_ index:Int,_ square:Squarelis) -> Void)?
    
    convenience init(zipCode:String){
        self.init(frame: CGRect.zero, style: .plain)
        self.zipCode = zipCode
    }
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        backgroundColor = UIColor.clear
        delegate = self
        dataSource = self
        separatorStyle = .none
        tableFooterView = UIView()
        registerClassOf(ChooseMarketSquareCell.self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MarketRightTableView:UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          selectedIndex = indexPath.row
//        let indexCell = tableView.cellForRow(at: indexPath) as! ChooseMarketSquareCell
//        for (_,cell) in tableView.visibleCells.enumerated() {
//           let cell = cell as! ChooseMarketSquareCell
//           cell.squareLable.textColor = UIColor.darkcolor
//         }
//        indexCell.squareLable.textColor = UIColor.navigationbarColor
          selectIndexAction?(indexPath.row,squarelist![indexPath.row])
    }
}

extension MarketRightTableView:UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = cell as! ChooseMarketSquareCell
        print(self.zipCode)
        cell.updateWithSelected(squarelist![indexPath.row].divName == self.zipCode ? true:false, with: squarelist![indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let squarelist = self.squarelist {
           return squarelist.count
        }else {
          return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ChooseMarketSquareCell = tableView.dequeueReusableCell()
        return cell
    }
}
