//
//  SwiftDocDictionary.swift
//  sourcekitten
//
//  Created by Eneko Alonso on 10/3/17.
//

import Foundation
import SourceKittenFramework
import MarkdownGenerator

typealias SwiftDocDictionary = [String: Any]

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

extension Dictionary where Key == String, Value == Any {
    func isAccessible(for level: SwiftAccessLevel) -> Bool {
        guard let accessLevel = SwiftAccessLevel(sourceKitAccessibility: self[.accessibility] ?? "") else {
            return false
        }
        return accessLevel.isGreaterThanOrEqual(to: level)
    }
    
    subscript<T>(_ key: SwiftDocKey) -> T? {
        return self[key.rawValue] as? T
    }

    func isKind(_ kind: SwiftDeclarationKind) -> Bool {
        return SwiftDeclarationKind(rawValue: self[.kind] ?? "") == kind
    }
    
    func isKind(_ kinds: [SwiftDeclarationKind]) -> Bool {
        guard let kind = SwiftDeclarationKind(rawValue: self[.kind] ?? "") else {
            return false
        }
        return kinds.contains(kind)
    }
}

