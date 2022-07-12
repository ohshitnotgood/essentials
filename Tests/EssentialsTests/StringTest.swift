//
//  StringTest.swift
//  
//
//  Created by Praanto Samadder on 12/07/2022.
//

import XCTest
@testable import Essentials

class StringTest: XCTestCase {
    func test_ext_isNotEmpty() throws {
        let stringSetToEmpty = ""
        XCTAssertEqual(stringSetToEmpty.isNotEmpty, false)
        
        let stringSetToValue = "some_value"
        XCTAssertEqual(stringSetToValue.isNotEmpty, true)
    }
}

class OptionalStringTest: XCTestCase {
    func test_ext_isNotNilOrEmpty() throws {
        let optionalStringSetToNil: String? = nil
        XCTAssertEqual(optionalStringSetToNil.isNotNilOrEmpty, false)
        
        let optionalStringSetToEmpty: String? = ""
        XCTAssertEqual(optionalStringSetToEmpty.isNotNilOrEmpty, false)
        
        let optionalStringSetToValue: String? = "some_value"
        XCTAssertEqual(optionalStringSetToValue.isNotNilOrEmpty, true)
    }
}
