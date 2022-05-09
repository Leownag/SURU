//
//  Array+.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/5/6.
//

import Foundation

extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}
