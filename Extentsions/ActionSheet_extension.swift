//
//  ActionSheet_extension.swift
//  wakuang-mobile
//
//  Created by Admin on 2020/6/13.
//

import UIKit

typealias actionClick = ((_ choice:String)->()) // 定义数据类型(其实就是设置别名)
extension UIAlertController {
    // 改进写法【推荐】
    private struct RuntimeKey {
        static let actionBlock = UnsafeRawPointer.init(bitPattern: "actionBlock".hashValue)
        /// ...其他Key声明
    }
    /// 运行时关联
    private var actionBlock: actionClick? {
        set {
            objc_setAssociatedObject(self, UIAlertController.RuntimeKey.actionBlock!, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return  objc_getAssociatedObject(self, UIAlertController.RuntimeKey.actionBlock!) as? actionClick
        }
    }
    convenience init(action:@escaping actionClick) {
        self.init()
    }
    
    convenience init(superCtl:UIViewController, title:String?, message:String?, actions:[String]?, type: UIAlertController.Style, sheetAction:@escaping actionClick) {
        self.init(title: title, message: message, preferredStyle: type)
        self.actionBlock = sheetAction
        if let actions = actions {
            for actionContent in actions {
                let action = UIAlertAction.init(title: actionContent, style: .default) { (action) in
                    if self.actionBlock != nil {
                        self.actionBlock!(actionContent)
                    }
                }
                self.addAction(action)
            }
        }
        self.title = title
        self.message = message
        let defaultAction = UIAlertAction.init(title: "确定", style: .default, handler: nil)
        self.addAction(defaultAction)
        
        superCtl.present(self, animated: true, completion: nil)
    }
}
