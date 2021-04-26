//
//  Button_extension.swift
//  wakuang-mobile
//
//  Created by Admin on 2020/6/11.
//
import UIKit

typealias buttonClick = (()->()) // 定义数据类型(其实就是设置别名)
extension UIButton{
    // 改进写法【推荐】
    private struct RuntimeKey {
        static let actionBlock = UnsafeRawPointer.init(bitPattern: "actionBlock".hashValue)
        /// ...其他Key声明
    }
    /// 运行时关联
    private var actionBlock: buttonClick? {
        set {
            objc_setAssociatedObject(self, UIButton.RuntimeKey.actionBlock!, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return  objc_getAssociatedObject(self, UIButton.RuntimeKey.actionBlock!) as? buttonClick
        }
    }
     /// 点击回调
    @objc func tapped(button:UIButton){
        if self.actionBlock != nil {
            self.actionBlock!()
        }
    }
    /// 快速创建
    convenience init(action:@escaping buttonClick){
        self.init()
        self.addTarget(self, action:#selector(tapped(button:)) , for:.touchUpInside)
        self.actionBlock = action
        self.sizeToFit()
    }
    /// 快速创建
    convenience init(setImage:String, action:@escaping buttonClick){
        self.init()
        self.frame = frame
        self.setImage(UIImage(named:setImage), for: .normal)
        self.addTarget(self, action:#selector(tapped(button:)) , for:.touchUpInside)
        self.actionBlock = action
        self.sizeToFit()
    }
    /// 快速创建按钮 setImage: 图片名 frame:frame action:点击事件的回调
    convenience init(setImage:String, frame:CGRect, action: @escaping buttonClick){
        self.init( setImage: setImage, action: action)
        self.frame = frame
    }
 
    /// 快速创建
    convenience init(frame:CGRect = CGRect.zero,title:NSString,titleColor:UIColor,backColor:UIColor, action:@escaping buttonClick){
        self.init()
        self.frame = frame
        self.setTitle(title as String, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.backgroundColor = backColor
        self.addTarget(self, action:#selector(tapped(button:)) , for:.touchUpInside)
        self.actionBlock = action
    }
}
