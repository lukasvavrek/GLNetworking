//
//  GLResponseStatusCodeHandler.swift
//  GLNetworking
//
//  Created by Lukas Vavrek on 11.2.18.
//  Copyright © 2018 Lukas Vavrek. All rights reserved.
//

/// Protocol defining minimal valid HTTP status code handler.
public protocol GLResponseStatusCodeHandler: class {
    /// Number of time a request should be retried.
    var repetition: UInt { get }
    /// Range of serving HTTP status codes.
    var httpStatusCodes: [Int] { get }

    /**
     Handlers main method that process the request.
     
     - Parameter activeRequest: Request that is being processed.
     - Parameter completion: Completion callback, to pass the flow back to the called.
     */
    func notify(activeRequest: GLRequest,
                completion: @escaping () -> Void)
}

/// GLResponseStatusCodeHandler extension methods.
public extension GLResponseStatusCodeHandler {
    /// Returns whether a processing request should be retried.
    public func shouldRetry(request: GLRequest) -> Bool {
        return request.sendCounter < repetition
    }
    
    /// Creates duplicate of existing GLResponseStatusCodeHandler.
    /// Currently it supports only `GLResponseStatusCodeHandler` instances.
    public func withStatusCodes(_ statusCodes: [Int]) throws -> GLResponseStatusCodeHandler {
        switch self {
        case is GLAsyncResponseStatusCodeHandler:
            return GLAsyncResponseStatusCodeHandler(httpStatusCodes: statusCodes)
        case is GLAuthHandler:
            throw GLError.httpStatusCodeHandlerNotSupported
        case is GLResponseStatusCodeDefaultHandler:
            throw GLError.httpStatusCodeHandlerNotSupported
        default:
            throw GLError.httpStatusCodeHandlerNotSupported
        }
    }
}
