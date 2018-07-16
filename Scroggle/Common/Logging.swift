//
//  Logging.swift
//  Scroggle
//
//  Created by Eric Internicola on 10/8/17.
//  Copyright © 2017 Eric Internicola. All rights reserved.
//

import Foundation
import Crashlytics

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

func recordSystemError(_ error: NSError, _ file: String = #file, _ line: Int = #line) {
    DLog("ERROR: \(error.localizedDescription)", file, line)
    Crashlytics.sharedInstance().recordError(error)
}

func recordSystemError(_ error: Error, _ file: String = #file, _ line: Int = #line) {
    DLog("ERROR: \(error.localizedDescription)", file, line)
    Crashlytics.sharedInstance().recordError(error)
}

func recordFatalError(_ error: NSError) -> Never {
    DLog("FATAL: \(error.localizedDescription)")
    Crashlytics.sharedInstance().recordError(error)
    fatalError(error.localizedDescription)
}

func recordFatalError(_ error: Error) -> Never {
    DLog("FATAL: \(error.localizedDescription)")
    Crashlytics.sharedInstance().recordError(error)
    fatalError(error.localizedDescription)
}

// MARK: - Errors

let scroggleErrorDomain = "ScroggleError"

enum ApplicationError: Error {
    case generalError(message: String)
    case sceneError(message: String)
}
