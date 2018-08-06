//
//  GLReachability.swift
//  GLNetworking
//
//  Created by Lukas Vavrek on 1.10.17.
//  Copyright © 2017 Lukas Vavrek. All rights reserved.
//

import MulticastDelegateSwift
import SystemConfiguration

/// Used to retrieve informations about the network connectivity.
public class GLReachability {
    /// Multicast center used for registration of the multicast notification callbacks.
    public private(set) var multicastCenter = GLReachabilityMulticastCenter()
    
    private let updateInterval: Int8
    private var delegate: GLReachabilityDelegate
    
    private var timer: Timer?
    
    private let connectionStatusProvider: GLConnectionStatusProvider

    /**
     Creates instance of GLReachability
     
     - Parameter delegate: Delegate used to provide reachability requests.
     - Parameter updateInterval: Reachability check repetition interval in seconds.
     */
    public init(delegate: GLReachabilityDelegate,
                updateInterval: Int8,
                connectionStatusProvider: GLConnectionStatusProvider) {
        self.delegate = delegate
        self.updateInterval = updateInterval
        self.connectionStatusProvider = connectionStatusProvider
        
        setupTimer()
    }
    
    private func setupTimer () {
        timer?.invalidate()
        
        if updateInterval <= 0 { return }

        timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(updateInterval),
                                     repeats: true) { _ in
            self.performReachabilityCheck()
        }
    }
    
    private func performReachabilityCheck() {
        let connectionStatus = connectionStatusProvider.getConnectionStatus()
        multicastCenter.networkConnection.setStatus(connectionStatus)
        
        switch connectionStatus {
        case .connected( _):
            break
        default:
            setOfflineStatus()
            return
        }
        
        testDNS()
    }
    
    private func testDNS() {
        let dnsRequest = delegate.dnsCheckRequest(sender: self)
        
        GLDirectRequest
            .create(glRequest: dnsRequest)
            .success { _ in
                self.multicastCenter.internetAccessibility.setStatus(.online)
            
                self.testServerAPI()
            }
            .error { _ in
                self.setOfflineStatus()
            }
            .send()
    }
    
    private func testServerAPI() {
        let serverRequest = delegate.serviceCheckRequest(sender: self)
        
        GLDirectRequest
            .create(glRequest: serverRequest)
            .success { _ in
                self.multicastCenter.serverAccessibility.setStatus(.accessible)
                self.multicastCenter.networkAvailability.setStatus(.available)
            }
            .error { _ in
                self.multicastCenter.serverAccessibility.setStatus(.notAccessible)
                self.multicastCenter.networkAvailability.setStatus(.notAvailable)
            }
            .send()
    }
    
    private func setOfflineStatus() {
        multicastCenter.internetAccessibility.setStatus(.offline)
        multicastCenter.serverAccessibility.setStatus(.notAccessible)
        multicastCenter.networkAvailability.setStatus(.notAvailable)
    }
}
