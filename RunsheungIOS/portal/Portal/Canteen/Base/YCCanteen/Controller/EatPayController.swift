//
//  EatPayController.swift
//  Portal
//
//

import UIKit

class EatPayController: CanteenBaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    enum sectionType:Int {
      case people
      case price
      static let count = 2
      init(indexPath:IndexPath){
         self.init(rawValue: indexPath.section)!
      }
      init(section:Int){
         self.init(rawValue: section)!
      }
        var rows:Int{
            switch self {
            case .people:
                return 4
            case .price:
                return 1
            }
        }
    }
    
    var tableView:UITableView!
    
    private func footView() -> UIView {
        
        let footer = UIView()
        footer.frame.size = CGSize(width: screenWidth, height: 150)
        footer.backgroundColor = UIColor.clear
        
        let resultBtn = UIButton(type: .custom)
        resultBtn.translatesAutoresizingMaskIntoConstraints = false
        resultBtn.addTarget(self, action: #selector(didResult), for: .touchUpInside)
        resultBtn.setTitle("登录结果", for: .normal)
        resultBtn.backgroundColor = UIColor.navigationbarColor
        resultBtn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        resultBtn.setTitleColor(UIColor.white, for: .normal)
        footer.addSubview(resultBtn)
        resultBtn.topAnchor.constraint(equalTo: footer.topAnchor,constant:15).isActive = true
        resultBtn.widthAnchor.constraint(equalTo: footer.widthAnchor, multiplier: 0.8).isActive = true
        resultBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        resultBtn.centerXAnchor.constraint(equalTo: footer.centerXAnchor).isActive = true
        
        let backBtn = UIButton(type: .custom)
        backBtn.addTarget(self, action: #selector(popBack), for: .touchUpInside)
        backBtn.setTitle("返回", for: .normal)
        backBtn.backgroundColor = UIColor.white
        backBtn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        backBtn.setTitleColor(UIColor.darkcolor, for: .normal)
        backBtn.translatesAutoresizingMaskIntoConstraints = false
        footer.addSubview(backBtn)
        backBtn.topAnchor.constraint(equalTo: resultBtn.topAnchor,constant:15).isActive = true
        backBtn.widthAnchor.constraint(equalTo: resultBtn.widthAnchor).isActive = true
        backBtn.heightAnchor.constraint(equalTo: resultBtn.heightAnchor).isActive = true
        backBtn.centerXAnchor.constraint(equalTo: footer.centerXAnchor).isActive = true
        
        return footer
    }
    
    
    
    @objc private func didResult(){
      
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.groupTableViewBackground
        
        tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClassOf(eatPayCell.self)
        tableView.tableFooterView = self.footView()
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionType.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectiontype = sectionType(section:section)
        return sectiontype.rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectiontype = sectionType(indexPath:indexPath)
        switch sectiontype {
        case .people:
            let cell:eatPayCell = tableView.dequeueReusableCell()
            return cell
        case .price:
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            cell.textLabel?.textAlignment = .right
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}







class eatPayCell:UITableViewCell {
    
    var avatarImgView:UIImageView!
    var namelb:UILabel!
    var pricelb:UILabel!
    var selectBtn:UIButton!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        avatarImgView = UIImageView()
        contentView.addSubview(avatarImgView)
        
        namelb = UILabel()
        namelb.textColor = UIColor.darkcolor
        namelb.font = UIFont.systemFont(ofSize: 13)
        contentView.addSubview(namelb)
        
        selectBtn = UIButton(type: .custom)
        selectBtn.addTarget(self, action: #selector(didSelect), for: .touchUpInside)
        contentView.addSubview(selectBtn)
        selectBtn.snp.makeConstraints { (make) in
            make.trailing.equalTo(contentView).offset(-15)
            make.centerY.equalTo(contentView)
            make.width.height.equalTo(15)
        }
        
        pricelb = UILabel()
        pricelb.textColor = UIColor.darkcolor
        pricelb.font = UIFont.systemFont(ofSize: 13)
        contentView.addSubview(pricelb)
        pricelb.snp.makeConstraints { (make) in
            make.trailing.equalTo(selectBtn.snp.leading).offset(-10)
            make.centerY.equalTo(contentView)
        }
        
        
    }
    
    @objc private func didSelect(){
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




