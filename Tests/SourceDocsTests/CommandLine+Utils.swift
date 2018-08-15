//
//  CommandLineUtils.swift
//  SourceDocsTests
//
//  Created by Jim Hildensperger on 14/08/2018.
//

import Foundation

extension CommandLine {
    func setArguments(_ arguments: String...) {
        CommandLine.arguments.removeLast(CommandLine.arguments.count - 1)
        CommandLine.arguments.append(contentsOf: arguments)
    }
}
