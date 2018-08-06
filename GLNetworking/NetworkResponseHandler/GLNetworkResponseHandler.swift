//
//  GLNetworkResponseHandler.swift
//  GLNetworking
//
//  Created by Lukas Vavrek on 12/12/17.
//  Copyright © 2017 Lukas Vavrek. All rights reserved.
//

import Foundation
import MulticastDelegateSwift

/// Used to handle HTTP responses based on the configured policies.
public class GLNetworkResponseHandler {

    private let httpStatusCodesSuccessRange = (200..<300)
    private let handlersContainer = GLResponseStatusCodeHandlersContainer()
    
    /// Creates instance of GLNetworkResponseHandler.
    public init() {}

    /// Adds new HTTP status code handler.
    public func add(handler: GLResponseStatusCodeHandler) {
        handlersContainer.add(handler: handler)
    }

    /// Handle request's response based on the configured policies.
    public func handle(request: GLRequest, response: GLResponse) {
        guard response.error == nil,
              let httpResponse = response.httpUrlResponse else {
            request.onError(response: response)
            return
        }

        let handler = handlersContainer.getHandler(for: httpResponse)

        if httpStatusCodesSuccessRange.contains(httpResponse.statusCode) {
            request.onSuccess(response: response)
        } else if handler.shouldRetry(request: request) {
            handler.notify(activeRequest: request) {
                request.send()
            }
        } else {
            request.onError(response: response)
        }
    }
}
