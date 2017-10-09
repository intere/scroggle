//
//  Logging.swift
//  Scroggle
//
//  Created by Eric Internicola on 10/8/17.
//  Copyright © 2017 Eric Internicola. All rights reserved.
//

import Foundation

func DLog(_ msg: @autoclosure () -> String, _ file: String = #file, _ line: Int = #line) {

    let fileString = file as NSString
    let fileLastPathComponent = fileString.lastPathComponent as NSString
    let filename = fileLastPathComponent.deletingPathExtension

    #if DEBUG
        NSLog("[%@:%d] %@\n", filename, line, msg())
    #else
        CLSLogv("[%@:%d] %@\n", getVaList([filename, line, msg()]))
    #endif
}
