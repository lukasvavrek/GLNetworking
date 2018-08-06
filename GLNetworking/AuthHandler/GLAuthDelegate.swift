//
//  GLAuthDelegate.swift
//  GLNetworking
//
//  Created by Lukas Vavrek on 11.2.18.
//  Copyright © 2018 Lukas Vavrek. All rights reserved.
//

/// Definition of a delegate, that is responsible for providing an authentication request.
public protocol GLAuthDelegate {
    /// Returns `GLRequest` that should be used as an authentication request.
    func authenticationRequest(sender: GLAuthHandler) -> GLRequest
}
