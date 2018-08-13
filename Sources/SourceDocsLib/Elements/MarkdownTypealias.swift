//
//  MarkdownTypealias.swift
//  SourceDocs
//
//  Created by Eneko Alonso on 11/13/17.
//

import Foundation
import SourceKittenFramework
import MarkdownGenerator

struct MarkdownTypealias: SwiftDocDictionaryInitializable, MarkdownConvertible, Documentable {
    let dictionary: SwiftDocDictionary
    let options: MarkdownOptions

    init?(dictionary: SwiftDocDictionary) {
        fatalError("Not supported")
    }

    init?(dictionary: SwiftDocDictionary, options: MarkdownOptions, accessLevel: SwiftAccessLevel) {
        guard dictionary.isAccessible(for: accessLevel) && dictionary.isKind([.protocol, .class, .enum, .struct, .typealias]) else {
            return nil
        }
        self.dictionary = dictionary
        self.options = options
    }

    var markdown: String {
        return """
        **TYPEALIAS**

        # `\(name)`

        \(declaration)

        \(comment.blockquoted)
        """
    }
}
