//
//  GLMulticast.swift
//  GLNetworking
//
//  Created by Lukas Vavrek on 1.10.17.
//  Copyright © 2017 Lukas Vavrek. All rights reserved.
//

import MulticastDelegateSwift

/// Generic multicast implementation.
/// It invokes registered delegates whenever `status` changes.
public class GLMulticast<T: Equatable> {
    private let delegates = MulticastDelegate<GLMulticastDelegate<T>>(strongReferences: true)

    /// Current status.
    public private(set) var status: T

    /// Creates `GLMulticast` with initial state.
    internal init(initialState: T) {
        status = initialState
    }

    // Sets new multicast status and notifies delegates about it.
    internal func setStatus(_ newStatus: T) {
        if (newStatus != status) {
            status = newStatus

            self.delegates |> { delegate in
                invokeDelegate(delegate)
            }
        }
    }

    private func invokeDelegate(_ delegate: GLMulticastDelegate<T>) {
        if let queue = delegate.queue {
            queue.async {
                delegate.callback(self.status)
            }
        } else {
            delegate.callback(self.status)
        }
    }

    /// Registers new delegate, that will be notified about status changes.
    public func addDelegate(_ delegate: GLMulticastDelegate<T>) {
        delegates += delegate
    }

    /// Removes existing delegate.
    public func removeDelegate(_ delegate: GLMulticastDelegate<T>) {
        delegates -= delegate
    }
}
