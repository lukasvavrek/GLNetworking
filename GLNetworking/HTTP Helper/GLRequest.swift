//
//  GLRequest.swift
//  GLNetworking
//
//  Created by Lukas Vavrek on 11/16/17.
//  Copyright © 2017 Lukas Vavrek. All rights reserved.
//

import Foundation

/// Callback definition - that is called when HTTP Request is completed.
public typealias GLRequestCompletedCallback = (GLResponse) -> ()

/// HTTP Request representation used in GLNetworking framework.
public class GLRequest {
    /**
     Creates new instance of GLRequest.
 
     - Parameter url: URL of the destination.
     */
    public static func create(url: String) -> GLRequest? {
        return GLRequest(url: url)
    }
    
    /**
     Creates new instance of GLRequest.
     
     - Parameter urlRequest: URLRequest to start configuration with.
     */
    public static func create(urlRequest: URLRequest) -> GLRequest {
        return GLRequest(urlRequest: urlRequest)
    }
    
    /// Counts how many times was request already sent.
    internal var sendCounter = 0

    private var successCallbacks = [GLRequestCompletedCallback]()
    private var errorCallbacks = [GLRequestCompletedCallback]()
    
    /// Registered status codes handler.
    internal private(set) var networkResponseHandler: GLNetworkResponseHandler?
    
    private var request: URLRequest

    internal init? (url: String) {
        guard let urlAddress = URL(string: url) else { return nil }
        
        self.request = URLRequest(url: urlAddress,
                                  cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                  timeoutInterval: TimeInterval(5))
    }
    
    internal init (urlRequest: URLRequest) {
        self.request = urlRequest
    }
    
    /// Register success callback. Existing callbacks will be preserved.
    @discardableResult public func success(_ callback: @escaping GLRequestCompletedCallback) -> GLRequest {
        self.successCallbacks.append(callback)
        return self
    }

    /// Register error callback. Existing callbacks will be preserved.
    @discardableResult public func error(_ callback: @escaping GLRequestCompletedCallback) -> GLRequest {
        self.errorCallbacks.append(callback)
        return self
    }

    /// Register GLStatusCodesHandler for the request.
    @discardableResult internal func networkResponseHandler(_ networkResponseHandler: GLNetworkResponseHandler) -> GLRequest {
        self.networkResponseHandler = networkResponseHandler
        return self
    }
    
    /// Executes request.
    internal func send() {
        guard networkResponseHandler != nil else {
            onError(response: GLResponse(data: nil, urlResponse: nil, error: nil))
            return
        }

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            self.sendCounter += 1
            
            let glResponse = GLResponse(data: data, urlResponse: response, error: error)
            self.networkResponseHandler!.handle(request: self, response: glResponse)
        }
        task.resume()
    }
    
    /// Executes all registered success callbacks.
    internal func onSuccess(response: GLResponse) {
        for success in successCallbacks {
            success(response)
        }
    }
    
    /// Executes all registered error callbacks.
    internal func onError(response: GLResponse) {
        for error in errorCallbacks {
            error(response)
        }
    }
}

public extension GLRequest {
    /// Adds a dictionary data to the requests body and sets the content type header
    @discardableResult public func jsonBody(_ data: [String: Any]) -> GLRequest {
        self.request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        self.request.httpBody = try! JSONSerialization.data(withJSONObject: data, options: [])
        return self
    }
}

// Accessing Request Components
public extension GLRequest {
    /// Sets the HTTP request method.
    @discardableResult public func httpMethod(_ httpMethod: String?) -> GLRequest {
        self.request.httpMethod = httpMethod
        return self
    }
    
    /// Sets the data sent as the message body of the request, such as for an HTTP POST request.
    @discardableResult public func httpBody(_ httpBody: Data?) -> GLRequest {
        self.request.httpBody = httpBody
        return self
    }
    
    /// Sets the request's HTTP body stream.
    @discardableResult public func httpBodyStream(_ httpBodyStream: InputStream?) -> GLRequest {
        self.request.httpBodyStream = httpBodyStream
        return self
    }
    
    /// Sets the main document URL associated with this request.
    @discardableResult public func mainDocumentURL(_ mainDocumentURL: URL?) -> GLRequest {
        self.request.mainDocumentURL = mainDocumentURL
        return self
    }
}

// Accessing Header Fields
public extension GLRequest {
    /// Adds one value to the header field.
    @discardableResult internal func addValue(_ value: String, forHTTPHeaderField httpHeaderField: String) -> GLRequest {
        self.request.addValue(value, forHTTPHeaderField: httpHeaderField)
        return self
    }
    

    /// Sets a value for a header field.
    @discardableResult public func setValue(_ value: String?, forHTTPHeaderField httpHeaderField: String) -> GLRequest {
        self.request.setValue(value, forHTTPHeaderField: httpHeaderField)
        return self
    }
}

// Controlling Request Behavior
public extension GLRequest {
    /// Sets the timeout interval of the request.
    @discardableResult public func setTimeoutInterval(_ timeoutInterval: TimeInterval) -> GLRequest {
        self.request.timeoutInterval = timeoutInterval
        return self
    }
}
