//
//  YiJingShowVc.swift
//  NumMemery
//
//  Created by rphaeh on 2021/1/27.
//

import UIKit
import IBAnimatable

class YiJingShowVc: AnimatableModalViewController {

    @IBOutlet weak var sixShowV: UIView!
    @IBOutlet weak var sixContainerV: UIView!
    
    @IBOutlet weak var fiveShowV: UIView!
    @IBOutlet weak var fiveContainerV: UIView!
    
    @IBOutlet weak var fourShowV: UIView!
    @IBOutlet weak var fourContainerV: UIView!
    
    @IBOutlet weak var threeShowV: UIView!
    @IBOutlet weak var threeContainerV: UIView!
    
    @IBOutlet weak var twoShowV: UIView!
    @IBOutlet weak var twoContainerV: UIView!
    
    @IBOutlet weak var oneShowV: UIView!
    @IBOutlet weak var oneContainerV: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setFrame()
    }
}

extension YiJingShowVc: ControllerFindable {
    static var `default`:  YiJingShowVc
    {
        let vc = YiJingShowVc(nibName: "\(YiJingShowVc.self)", bundle: nil)
        vc.modalPosition = .center
        vc.opacity = 0.3
        vc.cornerRadius = 6
        return vc
    }
}

extension YiJingShowVc {
    func setFrame() {
        modalSize = (.custom(size: Float(AppConfig.width - 60)), .custom(size: Float((AppConfig.height - 240))))
    }
    // 组装2进制 -0为阴 1为阳
    func produceHexagram(){
        var flagArray = [String]()
        var originHexagm: UInt8 = 0b00000000
        let flagOriginArray = ["×","－","＝","○"]
        for i in 0 ..< 6 {
            let perYao = moneyMakeYao()
            flagArray.append(flagOriginArray[perYao])
            let yaoP: UInt8 = 0b00000001 << i
            print("\(perYao)--\(flagOriginArray[perYao])--\(yaoP)\n")
      
            originHexagm |= perYao%2 == 1 ? yaoP : 0b00000000
        }
        //110000
        print(originHexagm)
        showHexagram(originHexagm, flagArray: flagArray)
    }

    // 金钱卦 ○、×、－、＝ 老阳3、老阴0、少阳1、少阴2
    func moneyMakeYao() -> Int{
        // 3枚铜钱正反面
        let num1 = arc4random()%2 == 0
        let num2 = arc4random()%2 == 0
        let num3 = arc4random()%2 == 0
        let and12 = num1&&num2
        let or1 = num1||num2
        let result = and12 ? (num3 ? 3 : 2) : (or1 ? (num3 ? 2 : 1): (num3 ? 1 : 0))
        return result
    }
    
    func showHexagram(_ value: UInt8, flagArray: [String]) {
        let itemContainer = [oneContainerV, twoContainerV, threeContainerV, fourContainerV, fiveContainerV, sixContainerV]
        let itemShowV = [oneShowV, twoShowV, threeShowV, fourShowV, fiveShowV, sixShowV]
        for i in 0 ..< 6 {
            let yaoP: UInt8 = 0b00000001 << i
            itemContainer[i]?.backgroundColor = flagArray[i] == "○" || flagArray[i] == "×" ? .blue : .red
            
            print(value&yaoP == 0)
            itemShowV[i]?.isHidden = !(value&yaoP == 0)
        }
    }
    
    @discardableResult
    func show() -> Self {
        AppConfig.rootController.present(self, animated: true, completion: nil)
        produceHexagram()
        return self
    }
}

extension YiJingShowVc {
    class YiJModel: NSObject{
        // 确定卦
        var originHexagram: UInt8 = 0b00111111
        // 确定变爻
        var changeItem: UInt8 = 0
        // 变卦
        var changedHexagram: UInt8 = 0b0000000
    }
}
