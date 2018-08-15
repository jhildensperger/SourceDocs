//
//  ConsolePrinter.swift
//  SourceDocs
//
//  Created by Jim Hildensperger on 14/08/2018.
//

import Foundation

struct ConsolePrinter: Printer {
    func print(_ cstring: UnsafePointer<Int8>!, _ stream: UnsafeMutablePointer<FILE>!) {
        fputs(cstring, stream)
    }
}
