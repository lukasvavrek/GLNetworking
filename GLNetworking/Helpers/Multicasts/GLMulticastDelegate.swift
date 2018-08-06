//
//  GLMulticastDelegate.swift
//  GLNetworking
//
//  Created by Lukas Vavrek on 12/16/17.
//  Copyright © 2017 Lukas Vavrek. All rights reserved.
//

/// Delegate used for multicast registration.
public class GLMulticastDelegate<T> {
    /// Callback that gets called when multicast is invoked.
    public let callback: GLMulticastCallback<T>

    /// Queue that should be used for callback invocation.
    public let queue: DispatchQueue?

    /**
     Creates Multicast Delegate instance.
     
     - Parameter queue: DispatchQueue that should be used to invoke callback.
     - Parameter callback: Callback that should be called when delegate gets invoked.
     */
    public init(queue: DispatchQueue, callback: @escaping GLMulticastCallback<T>) {
        self.callback = callback
        self.queue = queue
    }

    /**
     Creates Multicast Delegate instance.
     
     - Parameter callback: Callback that should be called when delegate gets invoked.
     */
    public init(callback: @escaping GLMulticastCallback<T>) {
        self.callback = callback
        self.queue = nil
    }
}
