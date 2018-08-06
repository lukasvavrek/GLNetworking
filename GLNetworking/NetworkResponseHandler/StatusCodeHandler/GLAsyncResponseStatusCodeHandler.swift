//
//  GLAsyncResponseStatusCodeHandler.swift
//  GLNetworking
//
//  Created by Lukas Vavrek on 19.12.17.
//  Copyright © 2017 Lukas Vavrek. All rights reserved.
//

import MulticastDelegateSwift

/// Implementation of async HTTP status code handler.
public class GLAsyncResponseStatusCodeHandler: GLResponseStatusCodeHandler {
    /// Number of time a request should be retried.
    public private(set) var repetition: UInt = 0
    /// Range of serving HTTP status codes.
    public private(set) var httpStatusCodes: [Int] = []

    private let delegates = MulticastDelegate<GLResponseStatusCodeHandlerDelegate>(strongReferences: true)

    /**
     Creates instance of GLAsyncResponseStatusCodeHandler.
     
     - Parameter httpStatusCode: HTTP status code, that will be handled.
     */
    public init(httpStatusCode: GLHTTPStatusCode) {
        httpStatusCodes.append(httpStatusCode.rawValue)
    }

    /**
     Creates instance of GLAsyncResponseStatusCodeHandler.
     
     - Parameter httpStatusCode: A range of HTTP status codes, that will be handled.
     */
    public init(httpStatusCodes: [Int]) {
        self.httpStatusCodes.append(contentsOf: httpStatusCodes)
    }

    /**
     Creates instance of GLAsyncResponseStatusCodeHandler.
     
     - Parameter httpStatusCode: A range of HTTP status codes, that will be handled.
     */
    public convenience init(httpStatusCodes: [GLHTTPStatusCode]) {
        self.init(httpStatusCodes: httpStatusCodes.map { $0.rawValue })
    }

    /// Sets the repetition.
    public func setRepetition(_ repetition: UInt) {
        self.repetition = repetition
    }

    /// Adds a delegate, that will be notified when a handler will be invoked.
    public func addDelegate(_ delegate: GLResponseStatusCodeHandlerDelegate) {
        delegates += delegate
    }

    /// Removed the registered delegate.
    public func removeDelegate(_ delegate: GLResponseStatusCodeHandlerDelegate) {
        delegates -= delegate
    }

    /**
     Handlers main method that process the request.
     
     - Parameter activeRequest: Request that is being processed.
     - Parameter completion: Completion callback, to pass the flow back to the called.
     */
    public func notify(activeRequest: GLRequest,
                       completion: @escaping () -> Void) {

        delegates |> { $0.callback() }

        completion()
    }
}
