//
//  YCDataManager.swift
//  Portal
//
//  Created by PENG LIN on 2017/9/13.
//  Copyright © 2017年 linpeng. All rights reserved.
//

import Foundation
import FMDB


class YCDataManager:NSObject{
    
    var dataBase:FMDatabase?
    private var fileName:String?
    private var lockQueue = DispatchQueue(label: "lockqueue")
    
    static let shareManager:YCDataManager = YCDataManager()
    
    override init() {
        super.init()
        lockQueue.sync { [weak self] in
            let fileManager = FileManager.default
            let library:URL? = try? fileManager.url(for: .libraryDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            if let library = library {
                let dburl = library.appendingPathComponent("library.sqlite")
                self?.fileName = dburl.absoluteString
            }
        }
    }
    
    
    func close(){
       self.dataBase?.close()
    }
    
    func open(){
        guard let dataBase = self.dataBase else {
            self.dataBase = FMDatabase(path: fileName ?? "")
            self.dataBase?.open()
            return
        }
        dataBase.open()
    }
    
}
