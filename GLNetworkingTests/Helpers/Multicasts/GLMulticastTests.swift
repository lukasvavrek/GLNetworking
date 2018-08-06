//
//  GLMulticastTests.swift
//  GLNetworkingTests
//
//  Created by Lukas Vavrek on 25.7.18.
//  Copyright © 2018 Lukas Vavrek. All rights reserved.
//

import XCTest
@testable import GLNetworking

class GLMulticastTests: XCTestCase {
    var multicast: GLMulticast<GLNetworkStatus>!
    var delegate: GLMulticastDelegate<GLNetworkStatus>!
    var queueDelegate: GLMulticastDelegate<GLNetworkStatus>!
    var calledCounter: Int = 0
    
    private var queue = DispatchQueue(label: "queue.id")
    
    override func setUp() {
        super.setUp()
        
        multicast = GLMulticast<GLNetworkStatus>(initialState: .unknown)
        delegate = GLMulticastDelegate<GLNetworkStatus> { _ in
            self.queue.sync {
                self.calledCounter += 1
            }
        }
        queueDelegate = GLMulticastDelegate<GLNetworkStatus>(queue: queue) { _ in
            self.calledCounter += 1
        }
        calledCounter = 0
    }
    
    override func tearDown() {
        delegate = nil
        multicast = nil
        
        super.tearDown()
    }
    
    func testInitialValueSet() {
        XCTAssertEqual(multicast.status, .unknown)
    }
    
    func testSetStatusChangedValue() {
        multicast.setStatus(.available)
        XCTAssertEqual(multicast.status, .available)
    }
    
    func testDelegateAddedAndCalled() {
        multicast.addDelegate(queueDelegate)
        multicast.addDelegate(delegate)
        XCTAssertEqual(calledCounter, 0)
        multicast.setStatus(.available)
        queue.sync {}
        XCTAssertEqual(calledCounter, 2)
    }
    
    func testDelegateAddedAndRemovedNotCalled() {
        multicast.addDelegate(delegate)
        multicast.addDelegate(queueDelegate)
        XCTAssertEqual(calledCounter, 0)
        multicast.removeDelegate(delegate)
        multicast.removeDelegate(queueDelegate)
        multicast.setStatus(.available)
        XCTAssertEqual(calledCounter, 0)
    }
}
