//
//  URLNetworkSessionTest.swift
//  
//
//  Created by Praanto Samadder on 13/07/2022.
//

import XCTest
@testable import Essentials


@available(iOS 13.0, *)
class URLNetworkSessionTest: XCTestCase {
    func test_getRequest_status200() throws {
        Task {
            let (status, data) = try await URLNetworkSession(urlString: "https://jsonplaceholder.typicode.com/todos/1")
                .get(MockReceivingJSON_User.self)
            
            XCTAssertEqual(status, 200)
            XCTAssertEqual(data?.userId, 1)
        }
    }
    
    func test_getRequest_status404() throws {
        Task {
            let (status, _) = try await URLNetworkSession(urlString: "https://www.kth.se/wtf")
                .get(MockReceivingJSON_User.self)
            
            XCTAssertEqual(status, 404)
        }
    }
    
    struct MockSendingJSON: Codable {
        
    }
        
    struct MockReceivingJSON_User: Decodable {
        var userId: Int
        var id: Int
        var title: String
        var completed: Bool
    }
    
    func testMeasured() throws {
        self.measure {
            do {
                try test_getRequest_status200()
            } catch {
                print("Test failed")
            }
        }
    }
}
