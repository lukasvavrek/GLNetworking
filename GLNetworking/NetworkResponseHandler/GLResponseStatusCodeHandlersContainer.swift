//
//  GLResponseStatusCodeHandlersContainer.swift
//  GLNetworking
//
//  Created by Lukas Vavrek on 4.3.18.
//  Copyright © 2018 Lukas Vavrek. All rights reserved.
//

/// Container for `GLResponseStatusCodeHandler` HTTP status code handlers.
public class GLResponseStatusCodeHandlersContainer {
    /// All registered HTTP status codes handlers.
    public private(set) var handlersMap = [GLResponseStatusCodeHandler]()

    /// Register the handler and fix overlapping if needed.
    public func add(handler: GLResponseStatusCodeHandler) {
        filterHandlers(withStatusCodes: handler.httpStatusCodes)
        
        handlersMap.append(handler)
    }

    private func filterHandlers(withStatusCodes statusCodes: [Int]) {
        var handlersToRemove = [GLResponseStatusCodeHandler]()

        for existingHandler in handlersMap {
            if let filteredHandler = try? existingHandler.withStatusCodes(existingHandler.httpStatusCodes.filter { !statusCodes.contains($0)}) {
                
                if filteredHandler.httpStatusCodes.isEmpty {
                    handlersToRemove.append(existingHandler)
                } else if existingHandler.httpStatusCodes.count > filteredHandler.httpStatusCodes.count {
                    if let index = handlersMap.index(where: { $0 === existingHandler }) {
                        handlersMap[index] = filteredHandler
                    }
                }
            }
        }

        handlersMap = handlersMap.filter { handler in
            !handlersToRemove.contains { $0 === handler }
        }
    }

    /// Returns the handler configured for the response's HTTP status code.
    public func getHandler(for httpResponse: HTTPURLResponse) -> GLResponseStatusCodeHandler {
        let concreteHandler = handlersMap.first {
            $0.httpStatusCodes.contains(httpResponse.statusCode)
        }

        return concreteHandler ?? GLResponseStatusCodeDefaultHandler()
    }
}
