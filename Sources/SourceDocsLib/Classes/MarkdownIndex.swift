//
//  MarkdownIndex.swift
//  sourcekitten
//
//  Created by Eneko Alonso on 10/4/17.
//  Copyright © 2017 SourceKitten. All rights reserved.
//

import Foundation
import MarkdownGenerator
import Rainbow
import SourceKittenFramework

struct MarkdownOptions {
    var collapsibleBlocks: Bool
    var tableOfContents: Bool
}

class MarkdownIndex: Writeable {
    let basePath: String
    let filePath: String

    private let filename: String
    private let accessLevel: SwiftAccessLevel
    private var structs: [MarkdownObject] = []
    private var classes: [MarkdownObject] = []
    private var extensions: [MarkdownExtension] = []
    private var enums: [MarkdownEnum] = []
    private var protocols: [MarkdownProtocol] = []
    private var typealiases: [MarkdownTypealias] = []

    init?(basePath: String, docs: [SwiftDocs], options: GenerateCommandOptions) {
        self.basePath = basePath
        self.filename = options.contentsFileName
        self.filePath = basePath + "/" + filename
        
        guard let accessLevel = SwiftAccessLevel(rawValue: options.accessLevelString) else {
            return nil
        }
        
        self.accessLevel = accessLevel
        
        let markdownOptions = MarkdownOptions(collapsibleBlocks: options.collapsibleBlocks, tableOfContents: options.tableOfContents)
        let dictionaries = docs.compactMap { $0.docsDictionary.bridge() as? SwiftDocDictionary }
        
        process(dictionaries: dictionaries, markdownOptions: markdownOptions)
    }

    func write() throws {
        let flattenedExtensions = self.flattenedExtensions()
        let documenatables: [[Documentable]] =  [protocols, structs, classes, enums, flattenedExtensions, typealiases]
        
        fputs("Generating Markdown documentation...\n".green, stdout)

        let status = documenatables.compactMap {
            $0.reduce(DocumentationStatus()) { (result, documentable) in
                return result + documentable.getDocumentationStatus()
            }
            }.reduce(DocumentationStatus(), +)
        
        guard status.interfaceCount > 0 else {
            throw NSError(domain: "No interfaces for the access level: ", code: 9999, userInfo: nil)
        }

        let coverage = Int(status.precentage * 100)

        var content: [MarkdownConvertible] = [
            """
            # Reference Documentation
            This Reference Documentation has been generated with
            [SourceDocs v\(Constants.version)](https://github.com/jhildensperger/SourceDocs).

            ![\(coverage)%](\(Constants.defaultCoverageSvgFilename))
            """
        ]

        try content.append(writeAndIndexFiles(items: protocols, to: basePath, collectionTitle: "Protocols"))
        try content.append(writeAndIndexFiles(items: structs, to: basePath, collectionTitle: "Structs"))
        try content.append(writeAndIndexFiles(items: classes, to: basePath, collectionTitle: "Classes"))
        try content.append(writeAndIndexFiles(items: enums, to: basePath, collectionTitle: "Enums"))
        try content.append(writeAndIndexFiles(items: flattenedExtensions, to: basePath, collectionTitle: "Extensions"))
        try content.append(writeAndIndexFiles(items: typealiases, to: basePath, collectionTitle: "Typealiases"))

        try writeFile(file: CoverageBadge(coverage: coverage, basePath: basePath))
        try writeFile(file: MarkdownFile(filename: filename, basePath: basePath, content: content))
        try writeFile(file: DocumentationStatusFile(basePath: basePath, status: status))
        fputs("Done 🎉\n".green, stdout)
    }

    func addItem(from dictionary: SwiftDocDictionary, markdownOptions: MarkdownOptions) {
        if let value: String = dictionary[.kind], let kind = SwiftDeclarationKind(rawValue: value) {
            if kind == .struct, let item = MarkdownObject(dictionary: dictionary, options: markdownOptions, accessLevel: accessLevel) {
                structs.append(item)
            } else if kind == .class, let item = MarkdownObject(dictionary: dictionary, options: markdownOptions, accessLevel: accessLevel) {
                classes.append(item)
            } else if let item = MarkdownExtension(dictionary: dictionary, options: markdownOptions, accessLevel: accessLevel) {
                extensions.append(item)
            } else if let item = MarkdownEnum(dictionary: dictionary, options: markdownOptions, accessLevel: accessLevel) {
                enums.append(item)
            } else if let item = MarkdownProtocol(dictionary: dictionary, options: markdownOptions, accessLevel: accessLevel) {
                protocols.append(item)
            } else if let item = MarkdownTypealias(dictionary: dictionary, options: markdownOptions, accessLevel: accessLevel) {
                typealiases.append(item)
            }
        }
    }

    // MARK: - Private

    private func process(dictionaries: [SwiftDocDictionary], markdownOptions: MarkdownOptions) {
        dictionaries.forEach { process(dictionary: $0, markdownOptions: markdownOptions) }
    }

    private func process(dictionary: SwiftDocDictionary, markdownOptions: MarkdownOptions) {
        addItem(from: dictionary, markdownOptions: markdownOptions)

        if let substructure = dictionary[SwiftDocKey.substructure.rawValue] as? [SwiftDocDictionary] {
            process(dictionaries: substructure, markdownOptions: markdownOptions)
        }
    }

    private func writeAndIndexFiles(items: [MarkdownConvertible & SwiftDocDictionaryInitializable],
                                    to basePath: String, collectionTitle: String) throws -> [MarkdownConvertible] {
        if items.isEmpty {
            return []
        }

        // Make and write files
        let files = makeFiles(with: items, basePath: "\(basePath)/\(collectionTitle)")
        try files.forEach { try writeFile(file: $0) }

        // Make links for index
        let links: [MarkdownLink] = files.map {
            let url = "\(collectionTitle)/\($0.filename)"
            return MarkdownLink(text: $0.filename, url: url)
        }
        return [
            "## \(collectionTitle)",
            MarkdownList(items: links.sorted { $0.text < $1.text })
        ]
    }

    private func writeFile(file: Writeable) throws {
        fputs("  Writing documentation file: \(file.filePath)", stdout)
        do {
            try file.write()
            fputs(" ✔\n".green, stdout)
        } catch let error {
            fputs(" ❌\n", stdout)
            throw error
        }
    }

    private func makeFiles(with items: [MarkdownConvertible & SwiftDocDictionaryInitializable],
                           basePath: String) -> [MarkdownFile] {
        return items.map { MarkdownFile(filename: $0.name, basePath: basePath, content: [$0]) }
    }

    /// While other types can only have one declaration within a Swift module,
    /// there can be multiple extensions for the same type.
    private func flattenedExtensions() -> [MarkdownExtension] {
        let extensionsByType = zip(extensions.map { $0.name }, extensions)
        let groupedByType = Dictionary(extensionsByType) { existing, new -> MarkdownExtension in
            var merged = existing
            merged.methods += new.methods
            merged.properties += new.properties
            return merged
        }
        return Array(groupedByType.values)
    }
}
