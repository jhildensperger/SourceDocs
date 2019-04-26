//
//  SourceDocs.swift
//  SourceDocs
//
//  Created by Eneko Alonso on 10/5/17.
//

import Foundation
import Commandant
import Rainbow

struct SourceDocs {
    static let version = "0.6.2"
    static let defaultOutputDirectory = "Documentation/Reference"
    static let defaultContentsFilename = "README"
    static let defaultStatusFilename = "documentation_status.json"
    static let defaultCoverageSvgFilename = "documentation_coverage.svg"

    func run() {
        let registry = CommandRegistry<SourceDocsError>()
        registry.register(CleanCommand())
        registry.register(GenerateCommand())
        registry.register(VersionCommand())
        registry.register(HelpCommand(registry: registry))

        registry.main(defaultVerb: "help") { error in
            fputs("\(error.localizedDescription)\n)".red, stderr)
        }
    }

}
