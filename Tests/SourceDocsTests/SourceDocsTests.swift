//
//  SourceDocsTests.swift
//  SourceDocsTests
//
//  Created by Jim Hildensperger on 13/08/2018.
//

import XCTest
@testable import SourceDocsLib

let tmpOutputDirectory = "tmp/test/"

func setCommandLineArguments(_ arguments: String...) {
    CommandLine.arguments.removeLast(CommandLine.arguments.count - 1)
    CommandLine.arguments.append(contentsOf: arguments)
}

class GenerateCommandTests: XCTestCase {
    override func setUp() {
        try? FileManager.default.removeItem(atPath: tmpOutputDirectory)
        
        XCTAssertFalse(FileManager.default.fileExists(atPath: tmpOutputDirectory))
    }
    
    func testGenerateOutput() {
        let options = GenerateCommandOptions(spmModule: "SourceDocsDemo",
                                             moduleName: nil,
                                             outputDirectory: tmpOutputDirectory,
                                             sourceDirectory: "../../../",
                                             contentsFileName: "README",
                                             accessLevelString: "public",
                                             includeModuleNameInPath: false,
                                             clean: false,
                                             collapsibleBlocks: true,
                                             tableOfContents: true,
                                             xcodeArguments: [])
        
        let result = GenerateCommand().run(options)
        
        XCTAssert(FileManager.default.fileExists(atPath: tmpOutputDirectory))
        XCTAssertNil(result.error)
    }
}

class SourceDocsTests: XCTestCase {

}
