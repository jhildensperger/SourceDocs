//
//  Documentable.swift
//  SourceDocs
//
//  Created by Jim Hildensperger on 18/07/2018.
//

import Foundation

protocol Documentable {
    func getDocumentationStatus() -> DocumentationStatus
}

extension Documentable where Self: SwiftDocDictionaryInitializable {
    func getDocumentationStatus() -> DocumentationStatus {
        return DocumentationStatus(self)
    }
}
