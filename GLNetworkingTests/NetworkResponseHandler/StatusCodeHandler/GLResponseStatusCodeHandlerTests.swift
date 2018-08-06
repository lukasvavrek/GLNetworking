//
//  GLResponseStatusCodeHandlerTests.swift
//  GLNetworkingTests
//
//  Created by Lukas Vavrek on 1.8.18.
//  Copyright © 2018 Lukas Vavrek. All rights reserved.
//

import XCTest
@testable import GLNetworking

public class GLResponseStatusCodeHandlerTests: XCTestCase {
    private class FakeHandler: GLResponseStatusCodeHandler {
        var repetition: UInt
        
        var httpStatusCodes: [Int]
        
        func notify(activeRequest: GLRequest, completion: @escaping () -> Void) {
            
        }
        
        public init(repetition: UInt) {
            self.repetition = repetition
            self.httpStatusCodes = []
        }
    }
    
    private class FakeRequest: GLRequest {
        override func send() {
            sendCounter += 1
        }
    }
    
    func testSentFewerTimesThanAllowed() {
        let request = FakeRequest(url: "http://test.com")!
        request.send()
        
        let handler = FakeHandler(repetition: 2)
        
        XCTAssertTrue(handler.shouldRetry(request: request))
    }
    
    func testSentEqualTimesThanAllowed() {
        let request = FakeRequest(url: "http://test.com")!
        request.send()
        
        let handler = FakeHandler(repetition: 1)
        
        XCTAssertFalse(handler.shouldRetry(request: request))
    }
    
    func testSentMoreTimesThanAllowed() {
        let request = FakeRequest(url: "http://test.com")!
        request.send()
        request.send()
        
        let handler = FakeHandler(repetition: 1)
        
        XCTAssertFalse(handler.shouldRetry(request: request))
    }
}
