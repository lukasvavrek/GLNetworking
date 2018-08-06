//
//  GLQueueTests.swift
//  GLNetworkingTests
//
//  Created by Lukas Vavrek on 25.7.18.
//  Copyright © 2018 Lukas Vavrek. All rights reserved.
//

import XCTest
@testable import GLNetworking

class GLQueueTests: XCTestCase {
    var queue: GLQueue<String>!
    
    override func setUp() {
        super.setUp()
        
        queue = GLQueue<String>()
    }
    
    override func tearDown() {
        queue = nil
        
        super.tearDown()
    }
    
    func testIsEmpty() {
        XCTAssertTrue(queue.isEmpty)
        queue.enqueue("str1")
        XCTAssertFalse(queue.isEmpty)
        let _ = queue.peek()
        XCTAssertFalse(queue.isEmpty)
        let _ = queue.dequeue()
        XCTAssertTrue(queue.isEmpty)
    }
    
    func testPeekEmptyQueueReturnsNil() {
        let item = queue.peek()
        XCTAssertNil(item)
    }
    
    func testDequeueEmptyQueueReturnsNil() {
        let item = queue.dequeue()
        XCTAssertNil(item)
    }
    
    func testEnqueueDequeueReturnsCorrectItems() {
        queue.enqueue("str1")
        queue.enqueue("str2")
        queue.enqueue("str3")
        
        let str1 = queue.dequeue()
        let str2 = queue.dequeue()
        let str3 = queue.dequeue()
        
        XCTAssertEqual(str1, "str1")
        XCTAssertEqual(str2, "str2")
        XCTAssertEqual(str3, "str3")
    }
}
