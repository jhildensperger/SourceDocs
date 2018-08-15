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

