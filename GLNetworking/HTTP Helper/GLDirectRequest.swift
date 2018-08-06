//
//  GLDirectRequest.swift
//  GLNetworking
//
//  Created by Lukas Vavrek on 24.12.17.
//  Copyright © 2017 Lukas Vavrek. All rights reserved.
//

import Foundation

/**
 Direct HTTP Request representation used in GLNetworking framework.
 Default GLStatusCodesHandler is provided to achieve direct request functionality.
 */
internal class GLDirectRequest {
    /**
     Creates new instance of GLRequest with direct support.
     
     - Parameter url: URL of the destination.
     */
    public static func create(url: String) -> GLRequest? {
        return GLRequest.create(url: url)?.networkResponseHandler(GLNetworkResponseHandler())
    }
    
    /**
     Creates new instance of GLRequest with direct support.
     
     - Parameter urlRequest: URLRequest to start configuration with.
     */
    public static func create(urlRequest: URLRequest) -> GLRequest {
        return GLRequest.create(urlRequest: urlRequest).networkResponseHandler(GLNetworkResponseHandler())
    }
    
    /**
     Creates new instance of GLRequest with direct support.
     
     - Parameter glRequest: GLRequest to configure.
     */
    public static func create(glRequest: GLRequest) -> GLRequest {
        return glRequest.networkResponseHandler(GLNetworkResponseHandler())
    }
}
