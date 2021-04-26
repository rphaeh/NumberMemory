//
//  RandomNum.swift
//  NumMemery
//
//  Created by rphaeh on 2021/1/22.
//

import UIKit

class RandomNumVC: BaseVController {
    deinit {
        storeCache()
        NotificationCenter.default.removeObserver(self)
    }
    @IBOutlet weak var collectionV: UICollectionView!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    private var dataSource:[XMAlertVc.randomDataModel] = []
    private var isUnfold = true
    private var produceNum = 1
   

    override func setupUI() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (screenWidth - 80) / 6 , height: (screenWidth - 80) / 6)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        collectionV.setCollectionViewLayout(layout, animated: false)
        collectionV.delegate = self
        collectionV.dataSource = self
        collectionV.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        view.addSubview(collectionV)
        NotificationCenter.default.addObserver(self, selector: #selector(changeState(notif:)), name: NSNotification.Name(rawValue: "updateState"), object: nil)
        readCache()
        // 将日期选择器区域设置为中文（默认显示英文）
        datePicker.locale = Locale(identifier: "zh_CN")
                
        // 添加方法
        datePicker.addTarget(self, action:#selector(dateChanged(datePicker:)), for: UIControl.Event.valueChanged)
    }
}

extension RandomNumVC{
    
    func storeCache() {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "YYYY-MM-dd"// 自定义时间格式
        let time = dateformatter.string(from: Date())
        CacheManager.setCache(array: dataSource, for: time)
    }
    
    func readCache() {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "YYYY-MM-dd"// 自定义时间格式
        let time = dateformatter.string(from: Date())
        self.dataSource = CacheManager.cacheArray(for: time) ?? [XMAlertVc.randomDataModel]()
        
    }
    
    // MARK: - 日期选择器响应方法
   @objc func dateChanged(datePicker:UIDatePicker)
    {
            lookBack(isShow: false)
            // 更新提醒时间文本框
            let formatter = DateFormatter()
            formatter.dateFormat = "YYYY-MM-dd"
            let date = datePicker.date
            let dateText = formatter.string(from: date)
            self.dataSource = CacheManager.cacheArray(for: dateText) ?? [XMAlertVc.randomDataModel]()
    self.collectionV.reloadData()
    }

    @IBAction func unfoldBtnClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        isUnfold = sender.isSelected
        sender.setTitle(!isUnfold ? "合拢" : "分开", for: .normal)
    }
    
    @IBAction func chooseBtnClicked(_ sender: UIButton) {
        let count: Int = sender.tag
   
        count > 1 ? lookBack() : generateRandom()
        
    }
    
    
    @objc func changeState(notif: Notification) {
        
        guard let result = notif.userInfo else { return  }
        let changedIdx: Int = result["index"] as! Int
        let inputStr: String = result["input"] as! String
        let score: String = result["score"] as! String
        let model = dataSource[changedIdx]
        model.state = 2
        model.inputNum = inputStr
        model.score = score
        storeCache()
    }
    
    func showAlertVc(index: Int) {
        let model = dataSource[index]
        XMAlertVc.default
            .model(model: model)
            .state(state: model.state)
            .font(font: UIFont.systemFont(ofSize: 26))
            .index(index: index)
            .show()
        dataSource[index].state = model.state == 0 ? 1 : dataSource[index].state
    }
    // 查看记录
    func lookBack(isShow: Bool = true) {
        datePicker.isHidden = !isShow
        view.bringSubviewToFront(datePicker)
    }
    
    // 生成数字
    func generateRandom(){
        var result = ""
        for i in 0...59 {
            result += i%2 == 0 ? obtainNum() : obtainNum() + (isUnfold ? " " : "")
        }
        let model = XMAlertVc.randomDataModel.init(originNum: nil, inputNum: nil, score: nil)
        model.originNum = result
        model.state = 0
        dataSource.append(model)
        collectionV.reloadData()
        result += "\n\n"
        showAlertVc(index: dataSource.count - 1)
    }
    
    func obtainNum() -> String{
        let num = arc4random()%100
        return num > 9 ? "\(num)" : "0\(num)"
    }
}

extension RandomNumVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "RandomNumCell", for: indexPath)
        
        cell.backgroundColor = UIColor.lightGray
        if let titleL: UILabel = cell.viewWithTag(10) as? UILabel{
            titleL.text = "\(indexPath.row + 1)"
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        showAlertVc(index: indexPath.row)
        
    }
}



