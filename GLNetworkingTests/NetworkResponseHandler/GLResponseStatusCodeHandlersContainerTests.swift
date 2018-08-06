//
//  GLNetworkingTests.swift
//  GLNetworkingTests
//
//  Created by Lukas Vavrek on 22.7.18.
//  Copyright © 2018 Lukas Vavrek. All rights reserved.
//

import XCTest
@testable import GLNetworking

class GLResponseStatusCodeHandlersContainerTests: XCTestCase {
    var handlersContainer: GLResponseStatusCodeHandlersContainer!
    
    override func setUp() {
        super.setUp()
        
        handlersContainer = GLResponseStatusCodeHandlersContainer()
    }
    
    override func tearDown() {
        handlersContainer = nil
        
        super.tearDown()
    }
    
    func testOverlappingGetsFiltered() {
        let serverErrorHandler = GLAsyncResponseStatusCodeHandler(httpStatusCodes: Array(400..<600))
        let authHandler = GLAsyncResponseStatusCodeHandler(httpStatusCode: .Unauthorized)
        
        handlersContainer.add(handler: serverErrorHandler)
        
        XCTAssertEqual(handlersContainer.handlersMap.count, 1)
        XCTAssertTrue(handlersContainer.handlersMap[0].httpStatusCodes.contains(401))
        
        handlersContainer.add(handler: authHandler)
        
        XCTAssertEqual(handlersContainer.handlersMap.count, 2)
        XCTAssertFalse(handlersContainer.handlersMap[0].httpStatusCodes.contains(401))
        XCTAssertTrue(handlersContainer.handlersMap[1].httpStatusCodes.contains(401))
    }
    
    func testOverlappingGetsFilteredAndRemoved() {
        let serverErrorHandler = GLAsyncResponseStatusCodeHandler(httpStatusCode: .Unauthorized)
        let authHandler = GLAsyncResponseStatusCodeHandler(httpStatusCode: .Unauthorized)
        
        handlersContainer.add(handler: serverErrorHandler)
        
        XCTAssertEqual(handlersContainer.handlersMap.count, 1)
        XCTAssertTrue(handlersContainer.handlersMap[0].httpStatusCodes.contains(401))
        
        handlersContainer.add(handler: authHandler)
        
        XCTAssertEqual(handlersContainer.handlersMap.count, 1);
        XCTAssertTrue(handlersContainer.handlersMap[0].httpStatusCodes.contains(401))
    }
    
    func testGettingHandlerExists() {
        let serverErrorHandler = GLAsyncResponseStatusCodeHandler(httpStatusCodes: Array(400..<600))
        let authHandler = GLAsyncResponseStatusCodeHandler(httpStatusCode: .Unauthorized)
        
        handlersContainer.add(handler: serverErrorHandler)
        handlersContainer.add(handler: authHandler)
        
        XCTAssertEqual(handlersContainer.handlersMap.count, 2);
        
        let response = HTTPURLResponse(url: URL(string: "http://testing.com")!, statusCode: 401, httpVersion: nil, headerFields: nil)
        
        let handler = handlersContainer.getHandler(for: response!)
        XCTAssertTrue(handler.httpStatusCodes.contains(401))
    }
    
    func testGettingHandlerDoesntExistsUsingDefaultHandler() {
        let serverErrorHandler = GLAsyncResponseStatusCodeHandler(httpStatusCodes: Array(400..<500))
        let authHandler = GLAsyncResponseStatusCodeHandler(httpStatusCode: .Unauthorized)
        
        handlersContainer.add(handler: serverErrorHandler)
        handlersContainer.add(handler: authHandler)
        
        XCTAssertEqual(handlersContainer.handlersMap.count, 2);
        
        let response = HTTPURLResponse(url: URL(string: "http://testing.com")!, statusCode: 501, httpVersion: nil, headerFields: nil)
        
        let handler = handlersContainer.getHandler(for: response!)
        XCTAssertTrue(handler is GLResponseStatusCodeDefaultHandler)
    }
}
