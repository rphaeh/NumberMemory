//
//  Consts.swift
//  NumMemery
//
//  Created by rphaeh on 2021/1/22.
//

import UIKit

// MARK: - APP 配置
public struct AppConfig {
    /// 屏幕物理宽度
    static let width = UIScreen.main.bounds.width
    /// 屏幕物理高度
    static let height = UIScreen.main.bounds.height
    /// 屏幕缩放比例
    static let scale = UIScreen.main.scale
    /// 屏幕的 Bounds
    static let bounds = UIScreen.main.bounds
    /// 状态栏高度
    static let statusBarHeight = UIApplication.shared.statusBarFrame.height
    /// 导航栏高度
    static let navigationBarHeight: CGFloat = 44
    /// 导航栏底部距离
    static let navigationBarMaxY = statusBarHeight + navigationBarHeight
  
    /// KeyWindow
    static var keyWindow: UIWindow {
        return UIApplication.shared.keyWindow!
    }
    /// Tabbar
    static var tabBarController: UITabBarController {
        return rootController as! UITabBarController
    }
    /// Root view controller
    static var rootController: UIViewController {
        return (UIApplication.shared.keyWindow?.rootViewController!)!
    }
    
    /// 安全区域
    static var safeAreaInset: UIEdgeInsets {
        if #available(iOS 11.0, *) { return keyWindow.safeAreaInsets }
        else { return .zero }
    }
}
