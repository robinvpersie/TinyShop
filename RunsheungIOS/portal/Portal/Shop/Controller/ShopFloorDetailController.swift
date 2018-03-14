//
//  ShopFloorDetailController.swift
//  Portal
//
//  Created by PENG LIN on 2017/5/17.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import UIKit

class ShopFloorDetailController: ShopTableViewController {
    
    var div:String
    var mainModel:ShopHomeModel?
    
    init(div:String){
       self.div = div
       super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerClassOf(ShopHomeBasicCell.self)
        self.tableView.registerClassOf(ShopHomeoddCell.self)
        self.tableView.registerClassOf(ShopHomeevenCell.self)
        self.tableView.separatorStyle = .none
        requestData(.Static)
    }
    
    fileprivate func requestData(_ model:UpdateMode,finish:(()->Void)? = nil)
    {
        if isFetching { return }
        isFetching = true
        ShopHomeModel.GetWithDiv(div, memid: nil, token: nil) { result in
            self.isloading = false
            self.isFetching = false
            switch result {
            case .success(let model):
                self.mainModel = model
                let waytoUpdate:UITableView.WayToUpdate = .reloadData
                waytoUpdate.performWithTableView(tableview: self.tableView)
                finish?()
            case .failure(let error):
                self.showMessage(error.localizedDescription)
                let waytoUpdate:UITableView.WayToUpdate = .reloadData
                waytoUpdate.performWithTableView(tableview: self.tableView)
                finish?()
                
            }
        }

    }

    
    override func topRefresh() {
        requestData(.TopRefresh) {
            self.refreshController.endRefreshing()
        }
    }
    
    override func fetchAgain() {
        requestData(.Static)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        guard let _ = mainModel else { return 0 }
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mainModel!.category.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let Intfloor = Int(mainModel!.category[indexPath.row].floorNum)
        if Intfloor! % 2 == 0 {
            return ShopHomeevenCell.getHeight()
        }else {
            return ShopHomeoddCell.getHeight()
        }

    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Intfloor = Int(mainModel!.category[indexPath.row].floorNum)
        if Intfloor! % 2 == 0 {
            let cell:ShopHomeevenCell = tableView.dequeueReusableCell()
            return cell
        }else {
            let cell:ShopHomeoddCell = tableView.dequeueReusableCell()
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        func actionWithCell(_ cell:ShopHomeBasicCell?){
            cell?.arrorAction = { [weak self] in
                guard let strongself = self else { return }
                let Intfloor = Int(strongself.mainModel!.category[indexPath.row].floorNum)
                let floor = ShopFloorController(floorNum: Intfloor!)
                floor.divCode = strongself.div
                floor.mainModel = strongself.mainModel
                floor.title = "\(Intfloor!)楼"
                floor.hidesBottomBarWhenPushed = true
                strongself.navigationController?.pushViewController(floor, animated: true)
            }
            
            cell?.btnAction = { [weak self] cha in
                guard let strongself = self else { return }
                let data:[UniqueFloor] = strongself.mainModel!.category[indexPath.row].data
                data.forEach({ uniqueFloor in
                    if let evenImg = uniqueFloor.eventImage.first {
                        let characters = evenImg.displayNum.characters
                        if characters.contains(cha.characters.first!) {
                            let parameter = FilterParameter(brandCode: uniqueFloor.customCode,divCode:strongself.div)
                            let filter = ShopBrandFilterController(with: parameter)
                            filter.hidesBottomBarWhenPushed = true
                            strongself.navigationController?.pushViewController(filter, animated: true)
                        }
                    }
                })
            }

        }
        
        let Intfloor = Int(mainModel!.category[indexPath.row].floorNum)
        if Intfloor! % 2 == 0 {
            let cell = cell as? ShopHomeevenCell
            cell?.updateWithModel(mainModel!.category[indexPath.row])
            actionWithCell(cell)
        }else {
            let cell = cell as? ShopHomeoddCell
            cell?.updateWithModel(mainModel!.category[indexPath.row])
            actionWithCell(cell)
        }

    }


}
