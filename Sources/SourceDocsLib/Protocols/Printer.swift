//
//  Printer.swift
//  SourceDocs
//
//  Created by Jim Hildensperger on 14/08/2018.
//

import Foundation

public protocol Printer {
    func print(_ cstring: UnsafePointer<Int8>!, _ stream: UnsafeMutablePointer<FILE>!)
}
