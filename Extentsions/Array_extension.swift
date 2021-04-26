//
//  Array_extension.swift
//  MajiaAPP
//
//  Created by Admin on 2020/7/9.
//  Copyright © 2020 qeegoo. All rights reserved.
//

import Foundation
extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()

        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }

    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}

