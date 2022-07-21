//
//  StringTest.swift
//  
//
//  Created by Praanto Samadder on 12/07/2022.
//

import XCTest
@testable import Essentials

class StringTest: XCTestCase {
    // This function tests String.isNotEmpty.
    // Should return false if a string is an empty string (a.k.a "")
    func test_ext_isNotEmpty() throws {
        let stringSetToEmpty = ""
        XCTAssertEqual(stringSetToEmpty.isNotEmpty, false)
        
        let stringSetToValue = "some_value"
        XCTAssertEqual(stringSetToValue.isNotEmpty, true)
        
        let stringStraight = "hello"
        let stringReversed = "olleh"
        XCTAssertEqual(-stringStraight, stringReversed)
    }
}

class OptionalStringTest: XCTestCase {
    // This function tests String?.isNotNilOrEmpty
    // Should return false if a string is set to nil
    // Should return false if a string is empty (a.k.a "")
    func test_ext_isNotNilOrEmpty() throws {
        let optionalStringSetToNil: String? = nil
        XCTAssertEqual(optionalStringSetToNil.isNotNilOrEmpty, false)
        
        let optionalStringSetToEmpty: String? = ""
        XCTAssertEqual(optionalStringSetToEmpty.isNotNilOrEmpty, false)
        
        let optionalStringSetToValue: String? = "some_value"
        XCTAssertEqual(optionalStringSetToValue.isNotNilOrEmpty, true)
    }
}
