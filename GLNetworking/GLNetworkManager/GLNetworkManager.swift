//
//  GLNetworkManager.swift
//  GLNetworking
//
//  Created by Lukas Vavrek on 12/17/17.
//  Copyright © 2017 Lukas Vavrek. All rights reserved.
//

import Foundation

/// Network manager for handling HTTP requests.
public class GLNetworkManager {
    
    private let networkResponseHandler: GLNetworkResponseHandler
    private let requestAuthenticator: GLRequestAuthenticator?
    private let reachability: GLReachability?
    
    private var requestQueue = GLQueue<GLRequest>()
    
    private let maxActiveRequests = 4
    private var activeRequests = [GLRequest]()
    
    /**
     Creates new GLNetworkManager instance.
     
     - Parameter networkResponseHandler: Used to process HTTP responses based on the configured policies.
     - Parameter authenticationHandler: Used for authenticating outcoming requests.
     - Parameter reachability: Used for monitoring network connection and server availability.
     */
    public init(networkResponseHandler: GLNetworkResponseHandler,
                requestAuthenticator: GLRequestAuthenticator? = nil,
                reachability: GLReachability? = nil) {
        self.networkResponseHandler = networkResponseHandler
        self.requestAuthenticator = requestAuthenticator
        self.reachability = reachability
    }
    
    /// Add request to the queue to wait for execution.
    public func execute(request: GLRequest) {
        request.networkResponseHandler(networkResponseHandler)
        
        request.success { _ in self.requestFinished(request: request) }
        request.error { _ in self.requestFinished(request: request) }
        
        requestQueue.enqueue(request)
        trySendingRequest()
    }
    
    /// Callback that gets called after the request is finished (with success or error).
    private func requestFinished(request: GLRequest) {
        if let index = activeRequests.index(where: { $0 === request }) {
            activeRequests.remove(at: index)
        }
        
        trySendingRequest()
    }
    
    /// Executes request that is waiting on queue, if it is possible.
    private func trySendingRequest() {
        if activeRequests.count >= maxActiveRequests { return }
        
        if let request = requestQueue.dequeue() {
            activeRequests.append(request)
            
            self.requestAuthenticator?.authenticate(request: request)
            
            if reachability == nil ||
               reachability?.multicastCenter.networkAvailability.status == .available {
                request.send()
            } else {
                request.onError(response: GLResponse(data: nil, urlResponse: nil, error: GLError.networkNotAvailable))
            }
        }
    }
}
