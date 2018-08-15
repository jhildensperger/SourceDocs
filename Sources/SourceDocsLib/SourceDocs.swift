//
//  SourceDocs.swift
//  SourceDocsLib
//
//  Created by Jim Hildensperger on 13/08/2018.
//

import Foundation
import Commandant
import Rainbow

var printer: Printer = ConsolePrinter()

public func run() -> Never {
    let registry = CommandRegistry<SourceDocsError>()
    registry.register(CleanCommand())
    registry.register(GenerateCommand())
    registry.register(VersionCommand())
    registry.register(HelpCommand(registry: registry))

    registry.main(defaultVerb: "help") { error in
        printer.print("\(error.localizedDescription)\n)".red, stderr)
    }
}
