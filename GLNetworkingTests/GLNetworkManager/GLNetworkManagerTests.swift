//
//  GLNetworkManagerTests.swift
//  GLNetworkingTests
//
//  Created by Lukas Vavrek on 28.7.18.
//  Copyright © 2018 Lukas Vavrek. All rights reserved.
//

import XCTest
@testable import GLNetworking

class GLNetworkManagerTests: XCTestCase {
    var networkManager: GLNetworkManager!
    var reachability: GLReachability!
    
    private class Authenticator : GLRequestAuthenticator {
        func authenticate(request: GLRequest) {}
    }
    
    private class ReachabilityDelegate : GLReachabilityDelegate {
        func dnsCheckRequest(sender: GLReachability) -> GLRequest {
            return GLRequest.create(url: "http://dnstest.com")!
        }
        
        func serviceCheckRequest(sender: GLReachability) -> GLRequest {
            return GLRequest.create(url: "http://servicetest.com")!
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
        
        override init?(url: String) {
            super.init(url: url)
        }
        
        override func send() {
            requestSend = true
        }
    }
    
    override func setUp() {
        super.setUp()
        
        reachability = GLReachability(
            delegate: ReachabilityDelegate(),
            updateInterval: 1,
            connectionStatusProvider: FakeConnectionStatusProvider()
        )
        
        networkManager = GLNetworkManager(
            networkResponseHandler: GLNetworkResponseHandler(),
            requestAuthenticator: Authenticator(),
            reachability: reachability
        )
    }
    
    override func tearDown() {
        networkManager = nil
        reachability = nil
        
        super.tearDown()
    }
    
    func testRequestFailedNoNetwork() {
        reachability.multicastCenter.networkAvailability.setStatus(.notAvailable)

        var error = false
        
        let request = GLRequest.create(url: "http://testing.com")!
        request.error { response in
            error = true
        }
        networkManager.execute(request: request)
        
        XCTAssertTrue(error)
    }
    
    func testRequestSent() {
        reachability.multicastCenter.networkAvailability.setStatus(.available)
        
        let request = FakeRequest(url: "http://testing.com")!
        networkManager.execute(request: request)
        
        XCTAssertTrue(request.requestSend)
    }
}
