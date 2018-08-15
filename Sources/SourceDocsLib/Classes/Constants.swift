//
//  Constants.swift
//  SourceDocs
//
//  Created by Jim Hildensperger on 13/08/2018.
//

import Foundation

struct Constants {
    static let version = "0.6.0"
    static let defaultOutputDirectory = "Documentation/Reference"
    static let defaultContentsFilename = "README"
    static let defaultStatusFilename = "documentation_status.json"
    static let defaultCoverageSvgFilename = "documentation_coverage.svg"
    static let defaultAccessLevelString = SwiftAccessLevel.public.rawValue
}
