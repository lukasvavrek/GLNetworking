//
//  GLReachabilityDelegate.swift
//  GLNetworking
//
//  Created by Lukas Vavrek on 11/13/17.
//  Copyright © 2017 Lukas Vavrek. All rights reserved.
//

/// Delegate used to provide information from application code to the GLReachability module.
public protocol GLReachabilityDelegate: class {
    /// Returns `GLRequest` that should be used as DNS check.
    func dnsCheckRequest(sender: GLReachability) -> GLRequest

    /// Returns `GLRequest` that should be used to check if server is available.
    func serviceCheckRequest(sender: GLReachability) -> GLRequest
}
