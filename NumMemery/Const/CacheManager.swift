//
//  CacheManager.swift
//  Footy
//
//  Created by crow on 2018/5/27.
//  Copyright © 2018年 小厚鱼. All rights reserved.
//

import Foundation
import ObjectMapper
class CacheManager {
    static let cacheDir = "CacheManagerDir"
    static let finishedKey = "finishedKey"
    
    static func filePath(_ fileName:String) -> URL?{
        let manager = FileManager.default
        guard let cachePath = manager.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let directory = cachePath.appendingPathComponent(cacheDir)
        if !manager.fileExists(atPath: directory.path){
            do{
                try manager.createDirectory(atPath: directory.path, withIntermediateDirectories: true, attributes: nil)
            }catch{
                return nil
            }
        }
        let path = directory.appendingPathComponent(fileName)
        return path
    }
    
    @discardableResult
    static func setCache(object:Mappable, for fileName: String) -> Bool{
        return setCache(json: object.toJSON(), for: fileName)
    }
    static func cache<T: Mappable>(for fileName: String) -> T?{
        guard let jsonDict = cacheJson(for: fileName) as? [String: Any] else {return nil}
        return Mapper<T>().map(JSON: jsonDict)
    }
    
    @discardableResult
    static func setCache(array: [Mappable], for fileName: String) -> Bool{
        return self.setCache(json: array.map({$0.toJSON()}), for: fileName)
    }
    static func cacheArray<T: Mappable>(for fileName: String) -> Array<T>?{
        guard let jsonArray = cacheJson(for: fileName) as? [[String: Any]] else {return nil}
        return Mapper<T>().mapArray(JSONArray: jsonArray)
    }
    
    @discardableResult
    static func setCache(json: Any, for fileName: String) -> Bool{
        guard let filePath = filePath(fileName) else {return false}
        if let array = json as? [Any]{
            let jsonArray = NSArray(array: array)
            return jsonArray.write(to: filePath, atomically: true)
        }else if let dict = json as? [String: Any]{
            let jsonDict = NSDictionary(dictionary: dict)
            return jsonDict.write(to: filePath, atomically: true)
        }else {
            return false
        }
    }
    static func cacheJson(for fileName: String) -> Any?{
        guard let filePath = filePath(fileName) else {return nil}
        if let jsonArray = NSArray(contentsOf: filePath){
            return jsonArray
        }else if let jsonDict = NSDictionary(contentsOf: filePath){
            return jsonDict
        }else{
            return nil
        }
    }
}
