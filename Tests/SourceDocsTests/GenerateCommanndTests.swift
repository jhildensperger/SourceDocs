//
//  GenerateCommanndTests.swift
//  SourceDocsTests
//
//  Created by Jim Hildensperger on 14/08/2018.
//

import Foundation
import XCTest
@testable import SourceDocsLib

let tmpOutputDirectory = "tmp/test/"

class GenerateCommandTests: XCTestCase {
    override func setUp() {
        try? FileManager.default.removeItem(atPath: tmpOutputDirectory)
        
        XCTAssertFalse(FileManager.default.fileExists(atPath: tmpOutputDirectory))
    }
    
    func testGenerateOutput() {
        printer = TestPrinter()
        
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
        
        switch result {
        case .success: XCTAssert(true)
        case .failure: XCTAssert(false)
        }
        
        let testPrinter = printer as! TestPrinter
        
        XCTAssertEqual(testPrinter.outputs.count, 26)
        XCTAssert(FileManager.default.fileExists(atPath: tmpOutputDirectory))
    }
}
