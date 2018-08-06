//
//  GLResponse.swift
//  GLNetworking
//
//  Created by Lukas Vavrek on 19.12.17.
//  Copyright © 2017 Lukas Vavrek. All rights reserved.
//

import Foundation

/// HTTP Response representation used in GLNetworking framework.
public class GLResponse {
    /// The data returned by the server.
    public let data: Data?
    /// An object that provides response metadata, such as HTTP headers and status code. If you are making an HTTP or HTTPS request, the returned object is actually an HTTPURLResponse object.
    public let urlResponse: URLResponse?
    /// Instance, if request was using HTTP or HTTPS protocol. `nil` otherwise.
    public var httpUrlResponse: HTTPURLResponse? {
        get {
            return urlResponse as? HTTPURLResponse
        }
    }
    /// An error object that indicates why the request failed, or nil if the request was successful.
    public let error: Error?
    
    /**
     Creates instance of GLResponse
     
     - Parameter data: The data returned by the server.
     - Parameter urlResponse: An object that provides response metadata, such as HTTP headers and status code. If you are making an HTTP or HTTPS request, the returned object is actually an HTTPURLResponse object.
     - Parameter error: An error object that indicates why the request failed, or nil if the request was successful.
     */
    internal init(data: Data?, urlResponse: URLResponse?, error: Error?) {
        self.data = data
        self.urlResponse = urlResponse
        self.error = error
    }
}
