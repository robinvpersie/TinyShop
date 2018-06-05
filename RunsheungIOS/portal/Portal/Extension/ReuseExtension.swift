//
//  ReuseExtension.swift
//  Portal
//
//  Created by linpeng on 2016/11/21.
//  Copyright © 2016年 linpeng. All rights reserved.
//

import Foundation
import UIKit



extension UITableView{
    
    enum WayToUpdate{
      case none
      case reloadData
      case reloadIndexPaths([IndexPath])
      case insert([IndexPath])
     
    var needsLabor:Bool{
      switch self {
        case .none:
            return false
        case .reloadData:
            return true
        case .reloadIndexPaths:
            return true
        case .insert:
            return true
        }
    }
        
     
    func performWithTableView(tableview: UITableView){
            switch self {
            case .none:
                break;
            case .reloadData:
                DispatchQueue.main.async {
                    tableview.reloadData()
                }
            case let .reloadIndexPaths(indexpath):
                DispatchQueue.main.async {
                    tableview.reloadRows(at: indexpath, with: .none)
                }
            case let .insert(indexpath):
                DispatchQueue.main.async {
                    tableview.insertRows(at: indexpath, with: .none)
                }
            }
        }
        
    }
}


extension UICollectionView{
    
    enum WayToUpdate{
       case none
       case reloadData
       case insert([IndexPath])
        
        var needsLabor: Bool{
            switch self {
            case .none:
                return false
            case .reloadData:
                return true
            case .insert:
                return true
            }
        }
        
        func performWithCollectionView(collectionview: UICollectionView){
            switch self {
            case .none:
                print("collectionview waytoupdate:none")
            case .reloadData:
                DispatchQueue.main.async {
                    collectionview.reloadData()
                }
            case .insert(let indexpaths):
                DispatchQueue.main.async {
                    collectionview.insertItems(at: indexpaths)
                }
            }
        
        }
    
    }

}


protocol Reusable: class {
    static var portal_reuseIdentifier: String { get }
}

protocol NibLoadable {
    static var portal_nibName: String { get }
}

extension UITableViewCell: NibLoadable{
    static var portal_nibName: String {
        return String(describing: self)
    }
}

extension UITableViewCell: Reusable{
    static var portal_reuseIdentifier: String{
        return String(describing: self)
    }
}

extension UITableViewHeaderFooterView: Reusable{
    static var portal_reuseIdentifier: String{
        return String(describing: self)
    }
}

extension UITableViewHeaderFooterView: NibLoadable{
    static var portal_nibName: String{
        return String(describing:self)
    }
}

extension UICollectionReusableView: NibLoadable{
    static var portal_nibName: String{
        return String(describing:self)
    }
}


extension UICollectionReusableView: Reusable{
    static var portal_reuseIdentifier: String{
        return String(describing: self)
    }
}

extension UICollectionView{
    
    func registerClassOf<T>(_: T.Type) where T: UICollectionViewCell {
        self.register(T.self, forCellWithReuseIdentifier: T.portal_reuseIdentifier)
    }
    
    func registerNibOf<T>(_: T.Type) where T: UICollectionViewCell{
        let nib = UINib(nibName: T.portal_nibName, bundle: nil)
        self.register(nib, forCellWithReuseIdentifier: T.portal_reuseIdentifier)
    }
    
    func registerHeaderNibOf<T>(_: T.Type) where T: UICollectionReusableView{
        let nib = UINib(nibName: T.portal_nibName, bundle: nil)
        register(nib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: T.portal_reuseIdentifier)
    }
    
    func registerHeaderClassOf<T>(_: T.Type) where T: UICollectionReusableView {
        register(T.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: T.portal_reuseIdentifier)
    }

    
    func registerFooterClassOf<T>(_: T.Type) where T: UICollectionReusableView {
        register(T.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: T.portal_reuseIdentifier)
    }
    
    func registerFooterNibOf<T>(_: T.Type) where T: UICollectionReusableView{
        let nib = UINib(nibName: T.portal_nibName, bundle: nil)
        register(nib, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: T.portal_reuseIdentifier)
    }

    func dequeueReusableCell<T>(indexpath: IndexPath) -> T where T: UICollectionViewCell {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.portal_reuseIdentifier, for: indexpath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.portal_reuseIdentifier)")
        }
        return cell
    }
    
    func dequeueReusableSupplementaryView<T>(ofKind kind: String, forIndexPath indexPath: IndexPath) -> T where T: UICollectionReusableView {
        
        guard let view = dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: T.portal_reuseIdentifier, for: indexPath as IndexPath) as? T else {
            fatalError("Could not dequeue supplementary view with identifier: \(T.portal_reuseIdentifier), kind: \(kind)")
        }
        return view
    }

    
    
 }

extension UITableView {
    
    func registerClassOf<T>(_: T.Type) where T: UITableViewCell {
        self.register(T.self, forCellReuseIdentifier: T.portal_reuseIdentifier)
    }
    
    func registerNibOf<T>(_: T.Type) where T: UITableViewCell {
        let nib = UINib(nibName: T.portal_nibName, bundle: nil)
        self.register(nib, forCellReuseIdentifier: T.portal_reuseIdentifier)
    }
    
    func regisiterHeaderFooterClassOf<T>(_: T.Type) where T: UITableViewHeaderFooterView {
        self.register(T.self, forHeaderFooterViewReuseIdentifier: T.portal_reuseIdentifier)
    }
    
    func registerNibOf<T>(_: T.Type) where T: UITableViewHeaderFooterView{
        let nib = UINib(nibName: T.portal_nibName, bundle: nil)
        self.register(nib, forHeaderFooterViewReuseIdentifier: T.portal_reuseIdentifier)
    }
    
    func dequeueReusableCell<T>() -> T where T: UITableViewCell {
        
        guard let cell = dequeueReusableCell(withIdentifier: T.portal_reuseIdentifier) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.portal_reuseIdentifier)")
        }
        return cell
    }
    
    func dequeueReusableHeaderFooter<T>() -> T where T: UITableViewHeaderFooterView {
        guard let view = dequeueReusableHeaderFooterView(withIdentifier: T.portal_reuseIdentifier) as? T else {
            fatalError("Could not dequeue header with identifier: \(T.portal_reuseIdentifier)")
        }
        return view
    }

    

}
