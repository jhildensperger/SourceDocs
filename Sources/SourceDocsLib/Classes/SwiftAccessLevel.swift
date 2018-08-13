//
//  SwiftAccessLevel.swift
//  SourceDocs
//
//  Created by Jim Hildensperger on 13/08/2018.
//

import Foundation

enum SwiftAccessLevel: String {
    case `open`
    case `public`
    case `internal`
    case `fileprivate`
    case `private`
    
    init?(sourceKitAccessibility: String) {
        let rawValue = sourceKitAccessibility.replacingOccurrences(of: "source.lang.swift.accessibility.", with: "")
        self.init(rawValue: rawValue)
    }
    
    func isGreaterThanOrEqual(to level: SwiftAccessLevel) -> Bool {
        switch self {
        case .open: return true
        case .public: return level != .open
        case .internal: return level != .open && level != .public
        case .fileprivate: return level != .open && level != .public && level != .internal
        case .private: return level != .open && level != .public && level != .internal && level != .fileprivate
        }
    }
}
