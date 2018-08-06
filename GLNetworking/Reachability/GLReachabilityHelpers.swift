//
//  GLReachabilityHelpers.swift
//  GLNetworking
//
//  Created by Lukas Vavrek on 1.10.17.
//  Copyright © 2017 Lukas Vavrek. All rights reserved.
//

/// Network connection status.
public enum GLConnectionStatus: CustomStringConvertible {
    case unknown
    case notConnected
    case connected(GLConnectionType)
    
    public var description: String {
        switch self {
        case .connected(let type):
            return type.description
        case .notConnected:
            return "Not connected"
        case .unknown:
            return "Unknown"
        }
    }
}

extension GLConnectionStatus: Equatable {
    public static func ==(lhs: GLConnectionStatus, rhs: GLConnectionStatus) -> Bool {
        switch (lhs, rhs) {
        case (let .connected(code1), let .connected(code2)):
            return code1 == code2
        case (.unknown, .unknown):
            return true
        case (.notConnected, .notConnected):
            return true
        default:
            return false
        }
    }
}

/// Network connection type.
public enum GLConnectionType: Equatable, CustomStringConvertible {
    case wifi
    case cellular

    public var description: String {
        switch self {
        case .wifi:
            return "WiFi"
        case .cellular:
            return "Cellular"
        }
    }
}

/// Internet availability status.
public enum GLInternetStatus: Equatable, CustomStringConvertible {
    case unknown
    case online
    case offline

    public var description: String {
        switch self {
        case .unknown:
            return "Unknown"
        case .online:
            return "Online"
        case .offline:
            return "Offline"
        }
    }
}

/// Server's availability status.
public enum GLServiceStatus: Equatable, CustomStringConvertible {
    case unknown
    case accessible
    case notAccessible

    public var description: String {
        switch self {
        case .unknown:
            return "Unknown"
        case .accessible:
            return "Accessible"
        case .notAccessible:
            return "Not accessible"
        }
    }
}

/// Network availability status.
public enum GLNetworkStatus: Equatable, CustomStringConvertible {
    case unknown
    case available
    case notAvailable

    public var description: String {
        switch self {
        case .unknown:
            return "Unknown"
        case .available:
            return "Available"
        case .notAvailable:
            return "Not available"
        }
    }
}
