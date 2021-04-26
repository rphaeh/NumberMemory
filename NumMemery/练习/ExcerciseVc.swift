//
//  ExcerciseVc.swift
//  NumMemery
//
//  Created by rphaeh on 2021/1/22.
//

import UIKit

class ExcerciseVc: BaseVController {

    @IBOutlet weak var collectionV: UICollectionView!
    
    private var dataSource = ["随机数字","数字桩训练","地点桩训练","卡牌记忆训练","抽象图形记忆训练","每天一卦"]
        
    override func setupUI() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (screenWidth - 50) / 3 , height: (screenWidth - 50) / 3)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        collectionV.setCollectionViewLayout(layout, animated: false)
        collectionV.delegate = self
        collectionV.dataSource = self
        collectionV.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        view.addSubview(collectionV)
        
    }
}

extension ExcerciseVc: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionVCell", for: indexPath)
        let item = dataSource[indexPath.row]
        cell.backgroundColor = UIColor.randomColor()
        if let titleL: UILabel = cell.viewWithTag(10) as? UILabel{
            titleL.text = item
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let vc:RandomNumVC = UIViewController.viewControllerWithIdentifier("RandomNum", storyboardName: "Main") as! RandomNumVC
            self.navigationController?.pushViewController(vc, animated: false)
        }else{
            if indexPath.row == dataSource.count - 1 {
                YiJingShowVc.default.show()
            }
                
        }
        
    }
}

