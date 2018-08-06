//
//  GLRequestAuthenticator.swift
//  GLNetworking
//
//  Created by Lukas Vavrek on 19.2.18.
//  Copyright © 2018 Lukas Vavrek. All rights reserved.
//

/**
 Protocol defining an object, which responsibility is to authenticate an existing request.
 */
public protocol GLRequestAuthenticator {
    /**
     Function definition, that is responsible for authenticating a request.
     
     - Parameter request: `GLRequest` that will be authenticated.
     */
    func authenticate(request: GLRequest)
}
