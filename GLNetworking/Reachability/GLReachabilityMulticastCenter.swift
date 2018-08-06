//
//  GLReachabilityMulticastCenter.swift
//  GLNetworking
//
//  Created by Lukas Vavrek on 1.10.17.
//  Copyright © 2017 Lukas Vavrek. All rights reserved.
//

/// Multicast center that groups all reachability multicasts.
public class GLReachabilityMulticastCenter {
    /// Network connectivity status.
    public let networkConnection = GLMulticast<GLConnectionStatus>(initialState: .unknown)

    /// Internet accessibility status.
    public let internetAccessibility = GLMulticast<GLInternetStatus>(initialState: .unknown)

    /// Server accessibility status.
    public let serverAccessibility = GLMulticast<GLServiceStatus>(initialState: .unknown)

    /// Summary network availability.
    public let networkAvailability = GLMulticast<GLNetworkStatus>(initialState: .unknown)
}
