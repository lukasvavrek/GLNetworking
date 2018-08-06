//
//  GLResponseStatusCodeDefaultHandler.swift
//  GLNetworking
//
//  Created by Lukas Vavrek on 3.3.18.
//  Copyright © 2018 Lukas Vavrek. All rights reserved.
//

/**
 Default HTTP status codes handler.
 It gets invoked, when no custom handler was provided by the application.
 */
public class GLResponseStatusCodeDefaultHandler: GLResponseStatusCodeHandler {
    /// Number of time a request should be retried.
    public private(set) var repetition: UInt = 0
    /// Range of serving HTTP status codes.
    public private(set) var httpStatusCodes: [Int] = []
    
    /**
     Handlers main method that process the request.
     
     - Parameter activeRequest: Request that is being processed.
     - Parameter completion: Completion callback, to pass the flow back to the called.
     */
    public func notify(activeRequest: GLRequest,
                       completion: @escaping () -> Void) {
        completion()
    }
}
