//
//  XMAlertVc.swift
//  NumMemery
//
//  Created by rphaeh on 2021/1/22.
//

import UIKit
import ObjectMapper
import IBAnimatable

class XMAlertVc: AnimatableModalViewController {
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBOutlet weak var groupLb: UILabel!
    
    @IBOutlet weak var contentLb: UILabel!
    
    @IBOutlet weak var inputTxtV: UITextView!
    
    @IBOutlet weak var checkBtn: AnimatableButton!
    
    @IBOutlet weak var lookAgainBtn: UIButton!
    
    @IBOutlet weak var resultContainerV: UIView!
    
    @IBOutlet weak var pointLb: UILabel!
    
    @IBOutlet weak var inputCollectV: UICollectionView! {
        didSet {
            let layout = UICollectionViewFlowLayout()
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            layout.estimatedItemSize = CGSize(width: 44, height: 20)
            layout.scrollDirection = .vertical
            inputCollectV.collectionViewLayout = layout
            inputCollectV.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "inputCell")
            inputCollectV.isScrollEnabled = true
            inputCollectV.dataSource = self
            inputCollectV.delegate = self
        }
    }
    
    @IBOutlet weak var generateLb: UILabel!
    
    private var numModel: randomDataModel?
    var checkState: ((_ state: Int) -> Void)?
    private var alertTitle: String?
    private var alertContent: String?
    private var contentFont: UIFont?
    private var inputStr: String?
    private var inputResult: [String] = [String]()
    private var errorIndex: [Int] = [Int]()
    private var currentIndex: Int = 0
    
    // 0显示原数据 1输入校验 2输出校验结果
    private var state: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let model = numModel else { return }
        groupLb.text = "第\(currentIndex + 1)组"
        contentLb.text = model.originNum
        contentLb.font = contentFont
        changeState()
        setFrame()
        
    }
   
}

extension XMAlertVc: ControllerFindable{
    static var `default`:  XMAlertVc
    {
        let vc = XMAlertVc(nibName: "\(XMAlertVc.self)", bundle: nil)
        vc.modalPosition = .center
        vc.opacity = 0.3
        vc.cornerRadius = 6
        return vc
    }
}

extension XMAlertVc: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return inputResult.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "inputCell", for: indexPath)

        let titleL = UILabel()
        titleL.textColor = errorIndex.contains(indexPath.row) ? .red : .green
        cell.contentView.addSubview(titleL)
        titleL.textAlignment = .center
        titleL.frame = CGRect(x: 0, y: 0, width: cell.frame.size.width, height: cell.frame.size.height)
        titleL.text = inputResult[indexPath.row]
        return cell
    }

}

extension XMAlertVc {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.inputTxtV.endEditing(true)
    }
    
    //控制显示哪些内容
    func changeState(){
        inputTxtV.isHidden = state != 1
        checkBtn.isHidden = inputTxtV.isHidden
        lookAgainBtn.isHidden = inputTxtV.isHidden
        contentLb.isHidden = state != 0
        resultContainerV.isHidden = state != 2
        pointLb.isHidden = resultContainerV.isHidden
        inputCollectV.isHidden = resultContainerV.isHidden
        if state == 2 {
            showResult()
        }
    }
    
    // 提交打分
    @IBAction func checkBtnClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        state = 2
        pointLb.text = "总分0"
        let inputS: String = inputTxtV.text
        numModel?.inputNum = inputS
        checkInput()
        let dic = ["score":"总分90","input":inputS, "index": currentIndex] as [String : Any]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateState"), object: nil, userInfo: dic)
        changeState()
    }
    
    // 再次查看
    @IBAction func againBtnClicked(_ sender: UIButton) {
        state = 0
        changeState()
    }
    
    func showResult() {
        
        guard let inputStr = numModel?.inputNum,
              let originStr = numModel?.originNum,
              let score = numModel?.score,
              let rightCount = numModel?.rightCount
        else { return }
        let inputResult = splitStr(".", str: inputStr)
        let originResult = splitStr(" ", str: originStr)
        self.inputResult = inputResult
        errorIndex = findToDif(inputResult, originArr: originResult)
        pointLb.text = "总分 \(score) /正确个数\(rightCount) "
        generateLb.text = numModel?.originNum
        inputCollectV.reloadData()
    }
    
    func checkInput() {
        
        guard let originGener = numModel?.originNum else { return }
        let inputResult = splitStr(".", str: inputTxtV.text)
        let originResult = splitStr(" ", str: originGener)
        self.inputResult = inputResult
        errorIndex = findToDif(inputResult, originArr: originResult)
        let result = String(format: "%.2f", Float(errorIndex.count / 30) * 100)
        numModel?.score = result
        numModel?.rightCount = inputResult.count-errorIndex.count
        pointLb.text = "总分 \(result) /正确个数\(inputResult.count-errorIndex.count) "
        generateLb.text = numModel?.originNum
        inputCollectV.reloadData()
        
        
    }
    
    func splitStr(_ operators: String, str: String) -> [String]{
        return str.components(separatedBy: operators)
    }
    
    func findToDif(_ mainArr: [String], originArr: [String]) -> [Int] {
        var result = [Int]()
        for (index,item) in mainArr.enumerated() {
            if originArr[index] != item {
                result.append(index)
            }
        }
        return result
    }
    
    func model(model: randomDataModel) -> Self {
        numModel = model
        return self
    }
    
    
    func font(font: UIFont) -> Self {
        contentFont = font
        return self
    }
    
    func index(index: Int) -> Self {
        currentIndex = index
        return self
    }
    
    func state(state: Int) -> Self {
        self.state = state
        return self
    }
    
    func setFrame() {
        modalSize = (.custom(size: Float(AppConfig.width - 60)), .custom(size: Float((AppConfig.height - 240))))
    }
    
    @discardableResult
    func show() -> Self {
        AppConfig.rootController.present(self, animated: true, completion: nil)
        return self
    }
}

extension XMAlertVc{
    class randomDataModel: Mappable{
        required init?(map: Map) {}
        var originNum: String?
        var inputNum: String?
        var score: String?
        // 0显示原数据 1输入校验 2输出校验结果
        var state: Int = 0
        var rightCount: Int = 0
        // 当前组数
        var index: Int = 0
        
        func mapping(map: Map) {
            originNum <- map["originNum"]
            inputNum <- map["inputNum"]
            score <- map["score"]
            state <- map["state"]
            rightCount <- map["rightCount"]
            index <- map["index"]
        }
        
        init(originNum: String?, inputNum: String?, score: String?, state: Int = 0, rightCount: Int = 0, index: Int = 0) {
            self.originNum = originNum
            self.inputNum = inputNum
            self.state = state
            self.score = score
            self.rightCount = rightCount
            self.index = index
        }
        
        
    }
}

/**
 乾，大哉乾元，万物资始，乃统天。云行雨施，品物流形。大明终始，六位时成。时乘六龙以御天。乾道变化，各正性命。保合大和，乃利贞。首出庶物，万国咸宁。
 坤，至哉坤元，万物资生，乃顺承天。坤厚载物，德合无疆。含弘光大，品物咸亨。牝马地类，行地无疆。柔顺利贞，君子。君子攸行，先迷失道，后顺得常。西南得朋，乃与类行，东北丧朋，乃有终也。安贞之吉，地应无疆。
 屯，刚柔始交而难生，动乎险中，大亨贞。雷雨之动满盈，天造草昧，宜寻建侯而不宁。
 蒙，山下有险，险而止，蒙。蒙亨，以亨行，时中也。匪我求童蒙，童蒙求我，志应也。初筮告，以刚中也，再三渎，渎则不告，渎蒙也。蒙以养正，圣功也。
 需，须也，前有险也，刚健而不陷，其义不困穷矣。需有孚，光亨，贞吉。位乎天位，以正中也。利涉大川，往有功也。
 讼，上刚而下险，险而健，讼。有孚窒惕，中吉，刚来而得中也。终凶，讼不可成也。利见大人，尚中正也，不利涉大川，入于渊也。
 师，众也，贞，正也，能以众正，可以王也。刚中而应，行险而顺，以此毒天下，而民从之，吉又何咎矣。
 比，吉也，辅也，下顺从也。原筮元，永贞，无咎，以刚中也。不宁方来，上下应也。后夫凶，其道穷也。
 小畜，柔得位而上下应之，健而巽，以刚中也。故亨，密云不雨，尚往也，自我西郊，施未行也。
 履，柔履刚也，说而应乎乾，是以履虎尾，不咥人。亨，刚中正，履帝位而不疚，光明也。
 泰，小往大来，吉亨，是以天地交而万物通也，上下交而志同也，内阳而外阴，内健而外顺，内君子而外小人，君子道长，小人道消。
 否，否之匪人，不利君子贞，大往小来。是以，天地不交而万物不通也，上下不交而无邦，内阴而外阳也，内柔儿外刚也，内小人而外君子也，小人道长，君子道消。
 同人，柔得位而得中，上下应之。同人，同人于野亨，
 
 
 
 
 */
