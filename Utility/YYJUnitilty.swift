//
//  YYJUnitilty.swift
//  wakuang-mobile
//
//  Created by Admin on 2020/6/11.
//

import UIKit

let screenWidth = UIScreen.main.bounds.size.width
let screenHeight = UIScreen.main.bounds.size.height
let safeAreaTopHeight: CGFloat = (screenHeight >= 812.0 && UIDevice.current.model == "iPhone" ? 88 : 64)
let safeAreaBottomHeight: CGFloat = (screenHeight >= 812.0 && UIDevice.current.model == "iPhone"  ? 34 : 0)
let BoldLineColor = UIColor.init(r:243, g:243 ,b:243)
let SpaceLineColor = UIColor.init(r:230, g:228 ,b:228)
let AppColor = UIColor(r: 199, g: 11, b: 56)

class YYJUnitilty: NSObject {

    var popLab:UILabel = UILabel()
    
    //声明block
    typealias MyUnitiltyBlock = (_ dic:NSDictionary)->()
    var myUnitiltyblock:MyUnitiltyBlock?
    
    
    //MARK:**********封装基础控件
    //MARK:创建UILable
    func creatLabel(superView:UIView?, place:NSTextAlignment = .left, frame:CGRect = CGRect.zero, textStr:String, size:CGFloat = 14) -> UILabel {
        
        let lab = UILabel.init(frame: frame)
        lab.font = UIFont.init(name: "SimHei", size: size)
        lab.text = textStr
        lab.textAlignment = place
        lab.numberOfLines = 0
        if let superView = superView {
            superView.addSubview(lab)
        }
        
        return lab
    }
    
    /// 创建一个划线的Lable
    func creatLine(frame:CGRect = CGRect.zero,backgroundColor:UIColor,superView:UIView)->Void{
        let lable = UILabel(frame:frame)
        lable.backgroundColor = backgroundColor
        superView.addSubview(lable)
    }
    
    //绘制虚线边框
    func createDashdeBorder(byView view:UIView, color:UIColor,lineWidth width:CGFloat){
        let shapeLayer = CAShapeLayer()
        let size = view.frame.size
        
        let shapeRect = CGRect(x: 10, y: 10, width: size.width-20, height: size.height-20)
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: size.width*0.5, y: size.height*0.5)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = width
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [3,4]
        let path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 5)
        shapeLayer.path = path.cgPath
        view.layer.addSublayer(shapeLayer)
        
    }
    //绘制红蓝相间的虚线
    func createDashdeLine(by view:UIView, color:UIColor = SpaceLineColor){
        let imgV:UIImageView = UIImageView(frame: CGRect(x: 0, y: view.ly_height-5, width: view.ly_width, height: 5))
        view.addSubview(imgV)
        UIGraphicsBeginImageContext(imgV.frame.size)
        
        let context = UIGraphicsGetCurrentContext()
        context?.setLineCap(CGLineCap.square)
        
        let lengths:[CGFloat] = [10,30,]
        context?.setStrokeColor(color.cgColor)
        context?.setLineWidth(2)
        context?.setLineDash(phase: 0, lengths: lengths)
        context?.move(to: CGPoint(x: 0, y: 3))
        context?.addLine(to: CGPoint(x: view.ly_width, y: 3))
        context?.strokePath()
        
        context?.setStrokeColor(color.cgColor)
        context?.setLineWidth(2)
        context?.setLineDash(phase: 0, lengths: lengths)
        context?.move(to: CGPoint(x: 20, y: 3))
        context?.addLine(to: CGPoint(x: view.ly_width, y: 3))
        context?.strokePath()
        imgV.image = UIGraphicsGetImageFromCurrentImageContext()
     //结束
        UIGraphicsEndImageContext()
    }
    // 创建view
    func creatView(frame:CGRect = CGRect.zero, superView: UIView?, color: UIColor = .white)->UIView{
        let view = UILabel(frame:frame)
        view.backgroundColor = color
        
        if let superView = superView {
            superView.addSubview(view)
        }
        return view
    }
    
    func createImageView(frame:CGRect = CGRect.zero,superView: UIView, imageName: String?)->UIImageView{
        let img = UIImageView(frame: frame)
        if let imageName = imageName {
            img.image = UIImage.init(named: imageName)
        }
        
        superView.addSubview(img)
        return img
    }
    
    //创建button
    func creatButton(frame:CGRect = CGRect.zero,title:NSString,titleColor:UIColor,backColor:UIColor, superView:UIView?)->UIButton{
        let btn:UIButton = UIButton(frame:frame)
        btn.setTitle(title as String, for:.normal)
        btn.setTitleColor(titleColor, for: .normal)
        btn.backgroundColor = backColor
        btn.clipsToBounds = true
        superView?.addSubview(btn)
        
        return btn
    }
    //创建button带action
    func creatButtonWithAction(frame:CGRect = CGRect.zero,title:NSString,titleColor:UIColor,backColor:UIColor, superView:UIView,action:@escaping buttonClick)->UIButton{
        let btn:UIButton = UIButton.init{
            action()
        }
        btn.setTitle(title as String, for:.normal)
        btn.setTitleColor(titleColor, for: .normal)
        btn.backgroundColor = backColor
        btn.clipsToBounds = true
        superView.addSubview(btn)
        
        return btn
    }
    func createAlert(title: String, message: String, type: UIAlertController.Style, curVc: UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: type)
        alertController.addAction(UIAlertAction(title: "知道了", style: .default) {  _ in
//            curVc.dismiss(animated: true, completion: nil)
        })
        curVc.present(alertController, animated: true)
    }
    
    func creatCellLab(cell:UITableViewCell,frame:CGRect,textStr:String) -> UILabel {
        
        let lab = UILabel.init(frame: frame)
        lab.font = UIFont.systemFont(ofSize: 16.0)
        lab.text = textStr
        lab.numberOfLines = 0
        cell.contentView.addSubview(lab)
        return lab
    }
    
    func creatCellLab(cell:UITableViewCell,frame:CGRect,textStr:String,placeholder:String) -> UILabel {
        let lab = UILabel.init(frame: frame)
        lab.font = UIFont.init(name: "SimHei", size: 16.0)
        
        //数据为空的时候显示站位字符
        if textStr.isEmpty || textStr == ""{
            lab.text = placeholder
        }else{
            lab.text = textStr
        }
        lab.numberOfLines = 0
        cell.contentView.addSubview(lab)
        return lab
    }
    
    func creatCellTextLab(cell:UITableViewCell,textStr:String) -> UILabel {
        
        let lab = UILabel.init(frame: CGRect.zero)
        lab.font = UIFont.init(name: "SimHei", size: 16.0)
        lab.text = textStr
        lab.numberOfLines = 0
        cell.contentView.addSubview(lab)
        return lab
    }
    
    func creatCellDetailsLab(cell:UITableViewCell,textStr:String,placeholder:String) -> UILabel {
        let lab = UILabel.init(frame: CGRect.zero)
        lab.font = UIFont.init(name: "SimHei", size: 16.0)
        
        //数据为空的时候显示站位字符
        if textStr.isEmpty || textStr == ""{
            lab.text = placeholder
            
        }else{
            lab.text = textStr
            
        }
        lab.numberOfLines = 0
        cell.contentView.addSubview(lab)
        return lab
    }
    
    
    /// 创建单个的右侧导航栏按钮
    ///
    /// - Parameters:
    ///   - title: 标题
    ///   - superCtl: 父控制器
    /// - Returns: 返回一个按钮
    func creatOneRigthBarButtonm(title:String,superCtl:UIViewController) -> UIButton {
        let btn = UIButton(frame:CGRect(x:0,y:0,width:50,height:30))
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        let item = UIBarButtonItem.init(customView: btn)
        superCtl.navigationItem.rightBarButtonItem = item
        return btn
    }
    //MARK:创建tableView的tableFootView
    func creatTabFootViewForSubmit(tableView:UITableView) -> UIButton {
        let tabFootView = UIView.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 60))
        tabFootView.backgroundColor = .lightGray
        
        
        let btn = UIButton.init(frame: CGRect(x: 0, y: 25, width: screenWidth, height: 45))
        btn.setTitle("提交", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        tabFootView.addSubview(btn)
        tableView.tableFooterView = tabFootView
        
        return btn
    }
    
    //MARK:---解析数据
    func objectFromJsonStr(str:String) -> AnyObject{
        if str.isEmpty {
            return "" as AnyObject
        }
        var jsonStr = str
        
        jsonStr = jsonStr.replacingOccurrences(of: "\n", with: "")
        jsonStr = jsonStr.replacingOccurrences(of: "\r", with: "")
        jsonStr = jsonStr.replacingOccurrences(of: "\"\"", with: "\" \"")
        //        jsonStr = [jsonStr stringByReplacingOccurrencesOfString:"\"\"" withString:"\" \""];
        //        if !JSONSerialization.isValidJSONObject(jsonStr) {
        //            print("is not a valid json object")
        //            return
        //        }
        
        let jsonData = jsonStr.data(using: .utf8)
        //错误处理
        //try ? 不需要写do{}catch{} 当有错误或者异常时不会抛出异常，而是直接返回nil
        //try!  不需要写do{}catch{} 这种写法适用确定一定会成功的情况
        //try   需要写do{}catch{}  这个对象没有通过car error:Error创建,在catch的大括号里直接就能拿到
        do{
            //Serialization序列化 Containers容器
            let result:AnyObject = try JSONSerialization.jsonObject(with: jsonData!, options: .mutableContainers) as AnyObject
            return result
        }catch{
            //localized 局部的
            print(error.localizedDescription)
            let result:AnyObject = String() as AnyObject
            return result
        }
    }
    
    //json解析
    func jsonFromObject(dic:Any) -> String {
        do{
            let json:NSData = try JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted) as NSData
            return NSString.init(data: json as Data, encoding: String.Encoding.utf8.rawValue)! as String
            
        }catch{
            print("json parse fail")
            return ""
        }
        
    }
    
    //MARK:---时间
    /// 获取当天的时间(年-月-日 时-分-秒)
    func getNowDate()->NSString{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let date:NSDate = NSDate()
        
        let dateStr:NSString = dateFormatter.string(from: date as Date) as NSString
        
        return dateStr
    }
    /// 返回指定月的天数的数组
    func getDayNumArrFromYearMonth(yearMonth:NSString) -> NSArray {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM"
        
        let date:NSDate = dateFormatter.date(from: yearMonth as String)! as NSDate
        
        let calerdar:NSCalendar = NSCalendar.init(calendarIdentifier: .gregorian)!
        
        
        let range:NSRange = calerdar.range(of: NSCalendar.Unit.day, in: NSCalendar.Unit.month, for: date as Date)
        
        let dayArray:NSMutableArray = NSMutableArray()
        for i in 1...range.length {
            dayArray.add([NSString.strings("%02lu"),i])
        }
        return dayArray
    }
    
    
    func creatAlertCtl(superCtl:UIViewController, title:String?, message:String?, type: UIAlertController.Style) -> Void {
        let ctl = UIAlertController.init(title: title, message: message , preferredStyle: type)
  
        let defaultAction = UIAlertAction.init(title: "确定", style: .default, handler: nil)
        ctl.addAction(defaultAction)
        
        superCtl.present(ctl, animated: true, completion: nil)
    }
    
    //MARK:**********功能
    
    //MARK:创建圆角
    /// 创建视图顶部圆角
    ///
    /// - Parameter cornerRadius: 圆角半径
    func creatViewTopCornerRadius(view:UIView,cornerRadius:CGFloat) -> Void {
        let maskPath1 = UIBezierPath.init(roundedRect: view.bounds, byRoundingCorners:[UIRectCorner.topLeft ,UIRectCorner.topRight], cornerRadii:CGSize(width:8,height:8))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = view.bounds
        maskLayer1.path = maskPath1.cgPath
        view.layer.mask = maskLayer1
    }
    /// 创建视图底部圆角
    ///
    /// - Parameter cornerRadius: 圆角半径
    func creatViewBottomCornerRadius(view:UIView,cornerRadius:CGFloat) -> Void {
        let maskPath1 = UIBezierPath.init(roundedRect: view.bounds, byRoundingCorners:[UIRectCorner.bottomLeft ,UIRectCorner.bottomRight], cornerRadii:CGSize(width:8,height:8))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = view.bounds
        maskLayer1.path = maskPath1.cgPath
        view.layer.mask = maskLayer1
    }
    //MARK:字符串转换
    
    //bool返回值为"1","0"
    func stringFromObject(object:AnyObject) -> String {
        var value = ""
        if let code = object as? Int {
            value = "\(code)"
        }else if let code = object as? CGFloat{
            value = "\(code)"
        }else if object is NSNull{
            value = ""
        }
        return value
    }
    
    func isNilStrReplace(str:AnyObject) -> NSString {
        if str.isKind(of: NSString.self) {
            return str as! NSString
        }else{
            return ""
        }
    }
    func isNilStr(str:NSString) -> Bool {
        if str.isKind(of: NSString.self) {
            if str.length != 0 {
                return true
            }
            return false
        }else{
            return false
        }
    }
    
    func getCGSizeForString(str:String,font:CGFloat,maxSize:CGSize) -> CGSize {
        
        let attribute = NSMutableDictionary()
        attribute.setValue(UIFont.systemFont(ofSize: font), forKey: NSAttributedString.Key.font.rawValue)
        
        let size = str.boundingRect(with: maxSize, options: .usesLineFragmentOrigin , attributes: attribute as? [NSAttributedString.Key : Any] , context: nil).size
        
        return size
    }
    
    func creatAttributedStr(str:String,length:Int,beforeColor:UIColor,beforeFont:CGFloat,afterColor:UIColor,afterFont:CGFloat) -> NSAttributedString {
        let attributedString = NSMutableAttributedString.init(string: str)
        //前半段字体格式
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: beforeColor, range: NSRange.init(location: 0, length: length))
        
        attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: beforeFont), range: NSRange.init(location: 0, length: length))
        
        
        //后半段字体
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: afterColor, range: NSRange.init(location: length, length: str.count - length))
        
        attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont .systemFont(ofSize: afterFont), range: NSRange.init(location: length, length: str.count - length))
        
        return attributedString
    }
    
    //MARK:模型转字典
    func dicFromLoginModel(model:AnyObject) -> NSDictionary {
        let dic = NSMutableDictionary()
        var count:UInt32 = 0
        //获取模型的所有属性数组
        let keyArr = class_copyPropertyList(object_getClass(model), &count)
        for i in 0..<Int(count) {
            let a = keyArr![i]
            //获取属性的名称
            let name = property_getName(a)
            let key = String(utf8String:name)
            //根据属性获取模型的值
            let value = model.value(forKey: key!)
            dic.setValue(value, forKey: key!)
        }
        return dic
    }
    
    
    //MARK:---活动指示器
    func creatActivitySuperView() -> UIActivityIndicatorView {
        let act:UIActivityIndicatorView = UIActivityIndicatorView(frame:CGRect(x:(screenWidth-100)/2,y:(screenHeight-100)/2,width:100,height:100))
        act.style = .whiteLarge
        act.color = UIColor.red
        act.hidesWhenStopped = true
        act.stopAnimating()
        
        let app:UIApplication = UIApplication.shared
        app.keyWindow?.addSubview(act)
        //        view.addSubview(act)
        //        act.bringSubview(toFront: view)
        return act
    }
    func creatPopLable(text:NSString) -> Void {
        
        let app:UIApplication = UIApplication.shared
        
        var isExist = false
        
        for view:UIView in (app.keyWindow?.subviews)! {
            if view.isEqual(popLab){
                isExist = true
            }
        }
        
        let size = getCGSizeForString(str: text as String, font: 17.0, maxSize: CGSize(width: screenWidth-80, height: 40))
        
        if isExist == false {
            popLab = UILabel(frame:CGRect(x:(screenWidth-size.width-10)/2,y:screenHeight-safeAreaBottomHeight-80,width:size.width + 10,height:size.height))
            popLab.font = UIFont.systemFont(ofSize: 16.0)
            popLab.layer.masksToBounds = true
            popLab.textAlignment = NSTextAlignment.center
            popLab.numberOfLines = 0
            popLab.layer.cornerRadius = 4
            popLab.text = text as String
            popLab.textColor =  UIColor.white
            popLab.backgroundColor = UIColor.gray
            
            app.keyWindow?.addSubview(popLab)
            
            Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(deletePopView), userInfo: nil, repeats: false)
        }
    }
    @objc func deletePopView(){
        popLab.removeFromSuperview()
    }
    
}
