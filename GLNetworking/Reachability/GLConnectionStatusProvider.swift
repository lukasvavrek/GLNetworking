//
//  GLConnectionStatusProvider.swift
//  GLNetworking
//
//  Created by Lukas Vavrek on 28.7.18.
//  Copyright © 2018 Lukas Vavrek. All rights reserved.
//

import SystemConfiguration

public protocol GLConnectionStatusProvider {
    func getConnectionStatus() -> GLConnectionStatus
}

/// Default `GLConnectionStatusProvider` that should be used intead of `nil`.
public class GLConnectionStatusDefaultProvider: GLConnectionStatusProvider {
    /// Creates instance of GLConnectionStatusDefaultProvider.
    public init() {}
    
    /// Returns unknown connection status.
    public func getConnectionStatus() -> GLConnectionStatus {
        return .unknown
    }
}

// Implementation of `GLConnectionStatusProvider` build on top of `SCNetworkReachability` API.
public class SCNetworkReachabilityStatusProvider : GLConnectionStatusProvider {
    private var reachability: SCNetworkReachability!
    
    /// Creates instance of SCNetworkReachabilityStatusProvider if it succeeds to creates it. `nil` otherwise.
    public init?() {
        guard let reachability = getGeneralReachability() else { return nil }
        
        self.reachability = reachability
    }
    
    private func getGeneralReachability() -> SCNetworkReachability? {
        var address = sockaddr_in()
        address.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        address.sin_family = sa_family_t(AF_INET)
        
        return withUnsafePointer(to: &address, { pointer in
            return pointer.withMemoryRebound(to: sockaddr.self, capacity: MemoryLayout<sockaddr>.size) {
                return SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        })
    }
    
    /// Returns device's network connection status.
    public func getConnectionStatus() -> GLConnectionStatus {
        guard let flags = getConnectionFlags() else { return .unknown }
        guard isConnectedToNetwork(with: flags) else { return .notConnected }
        
        if flags.contains(.isWWAN) { return .connected(.cellular) }
        
        return .connected(.wifi)
    }
    
    private func getConnectionFlags() -> SCNetworkReachabilityFlags? {
        var flags = SCNetworkReachabilityFlags()
        
        if SCNetworkReachabilityGetFlags(reachability, &flags) {
            return flags
        }
        
        return nil
    }
    
    private func isConnectedToNetwork(with flags: SCNetworkReachabilityFlags) -> Bool {
        let isReachable = flags.contains(.reachable)
        let connectionRequired = flags.contains(.connectionRequired)
        let canConnectAutomatically = flags.contains(.connectionOnDemand) || flags.contains(.connectionOnTraffic)
        let canConnectWithoutUserInteraction = canConnectAutomatically && !flags.contains(.interventionRequired)
        
        return isReachable && (!connectionRequired || canConnectWithoutUserInteraction)
    }
}
