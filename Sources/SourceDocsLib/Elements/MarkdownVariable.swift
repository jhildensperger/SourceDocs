//
//  MarkdownVariable.swift
//  SourceDocs
//
//  Created by Eneko Alonso on 11/13/17.
//

import Foundation
import SourceKittenFramework
import MarkdownGenerator

struct MarkdownVariable: SwiftDocDictionaryInitializable, MarkdownConvertible, Documentable {
    let dictionary: SwiftDocDictionary
    let options: MarkdownOptions

    init?(dictionary: SwiftDocDictionary) {
        fatalError("Not supported")
    }

    init?(dictionary: SwiftDocDictionary, options: MarkdownOptions, accessLevel: SwiftAccessLevel) {
        guard dictionary.isAccessible(for: accessLevel) && dictionary.isKind([.varInstance, .varStatic, .varClass, .varParameter]) else {
            return nil
        }
        self.dictionary = dictionary
        self.options = options
    }

    var markdown: String {
        let details = """
        \(declaration)

        \(comment.blockquoted)
        """

        if options.collapsibleBlocks {
            return MarkdownCollapsibleSection(summary: "<code>\(name)</code>", details: details).markdown
        } else {
            return """
            ### `\(name)`

            \(details)
            """
        }
    }
}
