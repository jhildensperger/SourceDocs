//
//  MarkdownExtension.swift
//  SourceDocs
//
//  Created by Eneko Alonso on 11/13/17.
//

import Foundation
import SourceKittenFramework
import MarkdownGenerator

struct MarkdownExtension: SwiftDocDictionaryInitializable, MarkdownConvertible, Documentable {
    let dictionary: SwiftDocDictionary
    let options: MarkdownOptions

    var properties: [MarkdownVariable]
    var methods: [MarkdownMethod]

    init?(dictionary: SwiftDocDictionary) {
        fatalError("Not supported")
    }

    init?(dictionary: SwiftDocDictionary, options: MarkdownOptions, accessLevel: SwiftAccessLevel) {
        let extensions: [SwiftDeclarationKind] = [
            .extension, .extensionEnum, .extensionClass, .extensionStruct, .extensionProtocol
        ]
        guard dictionary.isKind(extensions) else {
            return nil
        }
        self.dictionary = dictionary
        self.options = options

        if let structure: [SwiftDocDictionary] = dictionary[.substructure] {
            properties = structure.compactMap { MarkdownVariable(dictionary: $0, options: options, accessLevel: accessLevel) }
            methods = structure.compactMap { MarkdownMethod(dictionary: $0, options: options, accessLevel: accessLevel) }
        } else {
            properties = []
            methods = []
        }

        // Extensions ACL is defined by their properties and methods
        if properties.isEmpty && methods.isEmpty {
            return nil
        }
    }

    var markdown: String {
        let properties = collectionOutput(title: "## Properties", collection: self.properties)
        let methods = collectionOutput(title: "## Methods", collection: self.methods)
        return """
        **EXTENSION**

        # `\(name)`

        \(properties)

        \(methods)
        """
    }

    func getDocumentationStatus() -> DocumentationStatus {
        var status = DocumentationStatus(self)

        status = properties.reduce(DocumentationStatus(), { (status: DocumentationStatus, documentable) in
            return status + documentable.getDocumentationStatus()
        })

        status += methods.reduce(DocumentationStatus(), { (status: DocumentationStatus, documentable) in
            return status + documentable.getDocumentationStatus()
        })

        return status
    }
}
