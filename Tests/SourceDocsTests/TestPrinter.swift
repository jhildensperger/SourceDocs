//
//  SourceDocsTests.swift
//  SourceDocsTests
//
//  Created by Jim Hildensperger on 13/08/2018.
//

import AppKit
@testable import SourceDocsLib

class TestPrinter: Printer {
    var outputs = [String]()
    
    func print(_ cstring: UnsafePointer<Int8>!, _: UnsafeMutablePointer<FILE>!) {
        outputs.append(String(cString: cstring))
    }
}
