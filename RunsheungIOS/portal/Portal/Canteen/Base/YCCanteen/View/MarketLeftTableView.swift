//
//  MarketLeftTableView.swift
//  Portal
//
//  Created by PENG LIN on 2017/3/3.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit

class MarketLeftTableView: UITableView {
    
    var selectIndex:Int = 0
    var didSelectIndex:((_ index:Int) -> Void)?
    var areaandsquares = [Areaandsquar](){
        didSet{
          reloadData()
        }
    }
    
    var cityName:String?{
        didSet{
           headerlabel.text = "定位城市:"+cityName!
        }
    }
    
    lazy var headerlabel:UILabel = {
         let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.width, height: 40))
         label.textColor = UIColor.darkcolor
         label.textAlignment = .center
         label.font = UIFont.systemFont(ofSize: 13)
         return label
    }()

    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        backgroundColor = UIColor.white
        delegate = self
        dataSource = self
        tableFooterView = UIView()
        separatorStyle = .none
        registerClassOf(ChooseMarcketRegionCell.self)
        self.tableHeaderView = headerlabel
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MarketLeftTableView:UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectIndex == indexPath.row {
            return
        }else {
            selectIndex = indexPath.row
        }
        let cell = tableView.cellForRow(at: indexPath) as! ChooseMarcketRegionCell
        for (_ , cell) in tableView.visibleCells.enumerated(){
            let cell = cell as! ChooseMarcketRegionCell
            cell.backView.backgroundColor = UIColor.white
        }
          cell.backView.backgroundColor = UIColor.BaseControllerBackgroundColor
          didSelectIndex?(selectIndex)
    }
   
}

extension MarketLeftTableView:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return areaandsquares.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ChooseMarcketRegionCell = tableView.dequeueReusableCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
          let cell = cell as! ChooseMarcketRegionCell
        cell.updateWithSelected(selectIndex == indexPath.row ? true:false,model:areaandsquares[indexPath.row])
    }
}




