//
//  GLAuthHandler.swift
//  GLNetworking
//
//  Created by Lukas Vavrek on 11.2.18.
//  Copyright © 2018 Lukas Vavrek. All rights reserved.
//

/**
 Implementation of HTTP status code handler, that is triggered by 401 Unauthorized.
 It sends an authentication request to the server and if it succeeds,
 it will automatically retry the failed outcoming request.
 */
public class GLAuthHandler: GLResponseStatusCodeHandler {
    /// Number of times a request should be retried.
    public private(set) var repetition: UInt = 3
    /// Range of serving HTTP status codes.
    public private(set) var httpStatusCodes: [Int] = [
        GLHTTPStatusCode.Unauthorized.rawValue
    ]

    private let authDelegate: GLAuthDelegate
    private let requestAuthenticator: GLRequestAuthenticator
    
    /**
     Creates instance of GLAuthHandler.
     
     - Parameter delegate: A range of HTTP status codes, that will be handled.
     - Parameter requestAuthenticator: Authenticator instance responsible for an authentication of an outcoming requests.
     */
    public init (delegate: GLAuthDelegate,
                 requestAuthenticator: GLRequestAuthenticator) {
        self.authDelegate = delegate
        self.requestAuthenticator = requestAuthenticator
    }

    /// Sets the repetition of how many times a request should be retried.
    public func setRepetition(_ repetition: UInt) {
        self.repetition = repetition
    }
    
    /**
     Process the request, by sending an authentication request to the server.
     When it succeeds, it'll authenticate the original failed request and retry it.
     
     - Parameter activeRequest: Request that is being processed.
     - Parameter completion: Completion callback, to pass the flow back to the called.
     */
    public func notify(activeRequest: GLRequest,
                       completion: @escaping () -> Void) {
        let request = authDelegate.authenticationRequest(sender: self)
        
        let requestCompleted: GLRequestCompletedCallback = { _ in
            self.requestAuthenticator.authenticate(request: activeRequest)

            completion()
        }
        
        GLDirectRequest
            .create(glRequest: request)
            .success(requestCompleted)
            .error { _ in
                completion()
            }
            .send()
    }
}
