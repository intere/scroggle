//
//  ScroggleTests.swift
//  ScroggleTests
//
//  Created by Eric Internicola on 10/8/17.
//  Copyright © 2017 Eric Internicola. All rights reserved.
//

import XCTest
@testable import Scroggle

class ScroggleTests: XCTestCase {

    func testDimensions() {
        guard let screen = UIApplication.shared.keyWindow?.screen else {
            return XCTFail("Failed to get the screen")
        }

        print("Screen Size: \(screen.bounds)")
    }
    
}
