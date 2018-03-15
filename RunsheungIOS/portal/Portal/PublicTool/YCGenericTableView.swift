//
//  YCGenericTableView.swift
//  Portal
//
//  Created by PENG LIN on 2017/4/1.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import Foundation
import UIKit

//struct Artist {
//    var name: String
//}
//
//let artists: [Artist] = [
//    Artist(name: "Prince"),
//    Artist(name: "Glen Hansard"),
//    Artist(name: "I Am Oak")
//]
//
//extension Artist {
//    
//    func configureCell(_ cell: UITableViewCell) {
//        cell.textLabel?.text = name
//    }
//    
//    func height()->CGFloat {
//       return 10
//    }
//    
//    var cellDescriptor:CellDesciptor {
//       return CellDesciptor(reuseIdentifier: UITableViewCell.portal_reuseIdentifier, configure: self.configureCell, height: self.height)
//    }
//    
//}




struct CellDesciptor {
    let cellClass: UITableViewCell.Type
    let reuseIdentifier: String
    let configure: (UITableViewCell) -> ()
    let getHeight: () -> CGFloat
    
    init<Cell:UITableViewCell>(reuseIdentifier: String, configure: @escaping (Cell) -> (), height: @escaping () -> CGFloat) {
        self.cellClass = Cell.self
        self.reuseIdentifier = reuseIdentifier
        self.configure = { cell in
            configure(cell as! Cell)
        }
        self.getHeight = {
            return height()
        }
    }
}


final class ItemsTableView<Item>: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    var items:[Item] = [Item](){
        didSet {
          self.reloadData()
        }
    }
    var cellDescriptor:(Item) -> CellDesciptor
    var didSelect:(Item)->() = { _ in }
    var reuseIdentifiers:Set<String> = []
    
    init(cellDescriptor:@escaping (Item)->CellDesciptor){
        self.cellDescriptor = cellDescriptor
        super.init(frame: CGRect.zero, style: .plain)
        self.delegate = self
        self.dataSource = self
        self.tableFooterView = UIView()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let item = items[indexPath.row]
        let descriptor = cellDescriptor(item)
        return descriptor.getHeight()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        didSelect(item)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        let descriptor = cellDescriptor(item)
        if !reuseIdentifiers.contains(descriptor.reuseIdentifier) {
            tableView.register(descriptor.cellClass, forCellReuseIdentifier: descriptor.reuseIdentifier)
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: descriptor.reuseIdentifier, for: indexPath)
        descriptor.configure(cell)
        return cell
    }
}
