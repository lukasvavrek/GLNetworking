//
//  GLResponseStatusCodeHandlerDelegate.swift
//  GLNetworking
//
//  Created by Lukas Vavrek on 11.2.18.
//  Copyright © 2018 Lukas Vavrek. All rights reserved.
//

/// Delegate used to subscribe to Code Handler multicast.
public class GLResponseStatusCodeHandlerDelegate {
    public let callback: GLEmptyHandler
    
    /// Creates instance of GLResponseStatusCodeHandlerDelegate.
    public init(callback: @escaping GLEmptyHandler) {
        self.callback = callback
    }
}
