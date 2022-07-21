//
//  ArrayTest.swift
//  EssentialsTests
//
//  Created by Praanto Samadder on 12/07/2022.
//

import XCTest
@testable import Essentials


class Array_OfStringTest: XCTestCase {
    func test_trimAllWhiteSpacesNewLines() throws {
        var test_list = ["", " ", "Hello World", " Space Before", "Space After ", " Space Before and After "]
        let expected_list = ["", "", "Hello World", "Space Before", "Space After", "Space Before and After"]
        
        XCTAssertEqual(test_list.trimAll(in: .whitespacesAndNewlines), expected_list)
    }
    
    func test_removeDuplicates() throws {
        var test_list_a = ["Hello World", "Hello World", "hello world", "helloworld"]
        let expected_list_a = ["Hello World", "hello world", "helloworld"]
        
        XCTAssertEqual(test_list_a.removeDuplicates(), expected_list_a)
        
        // TODO: Implement randomly generated test data.
    }
}
