//
//  GLReachabilityTests.swift
//  GLNetworkingTests
//
//  Created by Lukas Vavrek on 28.7.18.
//  Copyright © 2018 Lukas Vavrek. All rights reserved.
//

import XCTest
@testable import GLNetworking

class GLReachabilityTests : XCTestCase {
    
    private var reachability: GLReachability!
    private var connectionStatusProvider: FakeConnectionStatusProvider!
    
    private var networkStatusDelegate: GLMulticastDelegate<GLNetworkStatus>!
    private var connectionStatusDelegate: GLMulticastDelegate<GLConnectionStatus>!
    private var internetStatusDelegate: GLMulticastDelegate<GLInternetStatus>!
    private var serviceStatusDelegate: GLMulticastDelegate<GLServiceStatus>!
    
    private var networkStatus: GLNetworkStatus!
    private var connectionStatus: GLConnectionStatus!
    private var internetStatus: GLInternetStatus!
    private var serviceStatus: GLServiceStatus!
    
    private var expectation: XCTestExpectation!
    
    private var dnsRequest: FakeRequest!
    private var serverRequest: FakeRequest!
    
    private class FakeDelegate : GLReachabilityDelegate {
        private var dnsRequest: GLRequest
        private var serverRequest: GLRequest
        
        init(dnsRequest: GLRequest, serverRequest: GLRequest) {
            self.dnsRequest = dnsRequest
            self.serverRequest = serverRequest
        }
        
        func dnsCheckRequest(sender: GLReachability) -> GLRequest {
            return self.dnsRequest
        }
        
        func serviceCheckRequest(sender: GLReachability) -> GLRequest {
            return self.serverRequest
        }
    }
    
    private class FakeConnectionStatusProvider : GLConnectionStatusProvider {
        var connectionStatus: GLConnectionStatus = GLConnectionStatus.unknown
        
        func getConnectionStatus() -> GLConnectionStatus {
            return connectionStatus
        }
    }
    
    private class FakeRequest : GLRequest {
        public var requestSend = false
        public var shouldSucceed = true
        
        override init?(url: String) {
            super.init(url: url)
        }
        
        override func send() {
            requestSend = true
            
            if shouldSucceed {
                onSuccess(response: GLResponse(data: nil, urlResponse: nil, error: nil))
            } else {
                onError(response: GLResponse(data: nil, urlResponse: nil, error: nil))
            }
        }
    }
    
    override func setUp() {
        super.setUp()
    
        expectation = self.expectation(description: "Notification from Reachability")
        
        networkStatus = .unknown
        connectionStatus = .unknown
        internetStatus = .unknown
        serviceStatus = .unknown
        
        dnsRequest = FakeRequest(url: "http://dns.com")!
        serverRequest = FakeRequest(url: "http://server.com")!
        
        networkStatusDelegate = GLMulticastDelegate<GLNetworkStatus>() { networkStatus in
            self.networkStatus = networkStatus
            self.expectation.fulfill()
        }
        
        connectionStatusDelegate = GLMulticastDelegate<GLConnectionStatus>() { connectionStatus in
            self.connectionStatus = connectionStatus
        }
        
        internetStatusDelegate = GLMulticastDelegate<GLInternetStatus>() { internetStatus in
            self.internetStatus = internetStatus
        }
        
        serviceStatusDelegate = GLMulticastDelegate<GLServiceStatus>() { serviceStatus in
            self.serviceStatus = serviceStatus
        }
        
        connectionStatusProvider = FakeConnectionStatusProvider()
        
        reachability = GLReachability(
            delegate: FakeDelegate(dnsRequest: dnsRequest, serverRequest: serverRequest),
            updateInterval: 1,
            connectionStatusProvider: connectionStatusProvider
        )
        
        reachability.multicastCenter.networkAvailability.addDelegate(networkStatusDelegate)
        reachability.multicastCenter.internetAccessibility.addDelegate(internetStatusDelegate)
        reachability.multicastCenter.networkConnection.addDelegate(connectionStatusDelegate)
        reachability.multicastCenter.serverAccessibility.addDelegate(serviceStatusDelegate)
    }
    
    override func tearDown() {
        reachability = nil
        connectionStatusProvider = nil
        
        super.tearDown()
    }
    
    func testNoConnectionOfflineStatus() {

        connectionStatusProvider.connectionStatus = .notConnected

        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertEqual(networkStatus, .notAvailable)
        XCTAssertEqual(connectionStatus, .notConnected)
        XCTAssertEqual(internetStatus, .offline)
        XCTAssertEqual(serviceStatus, .notAccessible)
    }
    
    func testConnectionDnsCheckPerformedAndFailed() {
        dnsRequest.shouldSucceed = false
        connectionStatusProvider.connectionStatus = .connected(.wifi)
        
        waitForExpectations(timeout: 5, handler: nil)
        
        if case let .connected(connectionType) = connectionStatus! {
            XCTAssertEqual(connectionType, .wifi)
        } else {
            XCTAssert(false)
        }
        
        XCTAssertEqual(networkStatus, .notAvailable)
        XCTAssertTrue(dnsRequest.requestSend)
        XCTAssertEqual(internetStatus, .offline)
        XCTAssertEqual(serviceStatus, .notAccessible)
    }
    
    func testConnectionDnsCheckPerformedWithSuccessServerCheckPerformedAndFailed() {
        dnsRequest.shouldSucceed = true
        serverRequest.shouldSucceed = false
        connectionStatusProvider.connectionStatus = .connected(.wifi)
        
        waitForExpectations(timeout: 5, handler: nil)
        
        if case let .connected(connectionType) = connectionStatus! {
            XCTAssertEqual(connectionType, .wifi)
        } else {
            XCTAssert(false)
        }
        
        XCTAssertEqual(networkStatus, .notAvailable)
        XCTAssertTrue(dnsRequest.requestSend)
        XCTAssertEqual(internetStatus, .online)
        XCTAssertTrue(serverRequest.requestSend)
        XCTAssertEqual(serviceStatus, .notAccessible)
    }
    
    func testConnectionDnsCheckPerformedWithSuccessServerCheckPerformedWithSuccess() {
        dnsRequest.shouldSucceed = true
        serverRequest.shouldSucceed = true
        connectionStatusProvider.connectionStatus = .connected(.wifi)
        
        waitForExpectations(timeout: 5, handler: nil)
        
        if case let .connected(connectionType) = connectionStatus! {
            XCTAssertEqual(connectionType, .wifi)
        } else {
            XCTAssert(false)
        }
        
        XCTAssertEqual(networkStatus, .available)
        XCTAssertTrue(dnsRequest.requestSend)
        XCTAssertEqual(internetStatus, .online)
        XCTAssertTrue(serverRequest.requestSend)
        XCTAssertEqual(serviceStatus, .accessible)
    }
}
