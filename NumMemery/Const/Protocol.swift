//
//  Protocol.swift
//  NumMemery
//
//  Created by rphaeh on 2021/1/22.
//

import UIKit

// MARK: - 从XIB中加载
protocol NibLoadable {}
extension NibLoadable {
    static func loadFromNib() -> Self {
        return Bundle.main.loadNibNamed("\(self)", owner: nil, options: nil)?.first as! Self
    }
}

// MARK: - 注册cell
protocol Registerable {}
extension Registerable {
    static var identifier: String { return "\(self)" }
    static var nib: UINib? { return UINib(nibName: "\(self)", bundle: nil) }
    static var isHasNib: Bool { return Bundle.main.path(forResource: "\(self)", ofType: "nib") != nil }
}

protocol SBLoadable {}
extension SBLoadable {
    static func load(SB: String) -> Self {
        let sb = UIStoryboard(name: SB, bundle: Bundle.main)
        let identifier = "\(self)"
        return sb.instantiateViewController(withIdentifier: identifier) as! Self
    }
    
    static func load(from sb: UIStoryboard) -> Self {
        let identifier = "\(self)"
        return sb.instantiateViewController(withIdentifier: identifier) as! Self
    }
}


// MARK: - 获取当前的控制器
protocol ControllerFindable {}
extension ControllerFindable {
    
    /// 获取当前显示的ViewController
    ///
    /// - Parameter from: 从哪个控制器找，默认当前显示的 root VC
    /// - Returns: 当前正在显示的控制器
    static func visiableVc(from: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        
        if let navigationController = from as? UINavigationController {
            return visiableVc(from: navigationController.visibleViewController)
        }
        if let tabBarController = from as? UITabBarController {
            if let selectedController = tabBarController.selectedViewController {
                return visiableVc(from: selectedController)
            }
        }
        if let presentedController = from?.presentedViewController {
            return visiableVc(from: presentedController)
        }
        return from
    }
    
    /// 获取当前的导航栏控制器
    /// - Parameter from: 从哪个控制器找，默认当前显示的 root VC
    static func visiableNc(from: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UINavigationController? {
        if let navigationController = from as? UINavigationController {
            return navigationController
        }
        if let tabBarController = from as? UITabBarController {
            if let selectedController = tabBarController.selectedViewController {
                return visiableNc(from: selectedController)
            }
        }
        if let presentedController = from?.presentedViewController {
            return visiableNc(from: presentedController)
        }
        return nil
    }
}

// MARK: - Codable 相关
// 扩展 Encodable 协议，添加编码的方法
public extension Encodable {
    
    // 遵守 Codable 协议的对象转 json 字符串
    func toJSONString() -> String? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    // 对象转 jsonObject
    func toJSONObject() -> Any? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
    }
}


