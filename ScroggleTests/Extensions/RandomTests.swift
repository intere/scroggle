//
//  RandomTests.swift
//  ScroggleTests
//
//  Created by Eric Internicola on 6/4/18.
//  Copyright © 2018 Eric Internicola. All rights reserved.
//

@testable import Scroggle
import XCTest

class RandomTests: XCTestCase {
    
    func testRandomMax() {
        for _ in 0..<100 {
            XCTAssertTrue(10.random <= 10)
        }
    }

    func testRandomMin() {
        for _ in 0..<100 {
            XCTAssertTrue(10.random >= 0)
        }
    }
    
}
