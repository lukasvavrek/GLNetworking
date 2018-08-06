//
//  ViewController.swift
//  ReachabilityExample
//
//  Created by Lukas Vavrek on 1.10.17.
//  Copyright © 2017 Lukas Vavrek. All rights reserved.
//

import UIKit
import GLNetworking

class ViewController: UIViewController {

    @IBOutlet weak var networkConnectionStatusLbl: UILabel!
    @IBOutlet weak var internetConnectivityStatusLbl: UILabel!
    @IBOutlet weak var serverAvailabilityStatusLbl: UILabel!
    @IBOutlet weak var networkAvailabilityStatusLbl: UILabel!

    @IBOutlet weak var autoAuthStatusLbl: GLValueLabel!
    @IBOutlet weak var authenticationStatusLbl: GLValueLabel!
    @IBOutlet weak var fetchAuthContentLbl: GLValueLabel!
    
    private var reachability: GLReachability!
    private var networkManager: GLNetworkManager!
    private var networkResponseHandler: GLNetworkResponseHandler!

    private var authToken: String? {
        didSet {
            DispatchQueue.main.async {
                self.setFetchUnknown(forLabel: self.fetchAuthContentLbl)
                
                if self.authToken == nil {
                    self.authenticationStatusLbl.text = "Not authenticated"
                    self.authenticationStatusLbl.textColor = UIColor.red
                } else {
                    self.authenticationStatusLbl.text = "Authenticated"
                    self.authenticationStatusLbl.textColor = UIColor.green
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupGLNetworking(withAutoAuthentication: true)
    }

    private func setupGLNetworking(withAutoAuthentication autoAuth: Bool) {
        let connectionStatusProvider: GLConnectionStatusProvider = SCNetworkReachabilityStatusProvider() ?? GLConnectionStatusDefaultProvider()
        reachability = GLReachability(delegate: self, updateInterval: 1, connectionStatusProvider: connectionStatusProvider)
        networkResponseHandler = GLNetworkResponseHandler()

        if autoAuth {
            autoAuthStatusLbl.text = "Enabled"
            autoAuthStatusLbl.textColor = UIColor.green
            
            let authHandler = GLAuthHandler(
                delegate: self,
                requestAuthenticator: self
            )
            authHandler.setRepetition(3)
            networkResponseHandler.add(handler: authHandler)
        } else {
            autoAuthStatusLbl.text = "Disabled"
            autoAuthStatusLbl.textColor = UIColor.red
        }
        
        let serverErrorHandler = GLAsyncResponseStatusCodeHandler(httpStatusCodes: Array(400..<600))
        serverErrorHandler.setRepetition(3)
        serverErrorHandler.addDelegate(GLResponseStatusCodeHandlerDelegate { print("Server error") })
        networkResponseHandler.add(handler: serverErrorHandler)

        networkManager = GLNetworkManager(
            networkResponseHandler: networkResponseHandler,
            requestAuthenticator: self,
            reachability: reachability
        )

        setupReachabilityDelegates()
        logout()
    }

    private func setupReachabilityDelegates() {
        let networkConnectionDelegate = GLMulticastDelegate<GLConnectionStatus>(queue: DispatchQueue.main) { networkStatus in
            self.networkConnectionStatusLbl.text = String(describing: networkStatus)

            switch networkStatus {
            case .connected(_):
                self.networkConnectionStatusLbl.textColor = UIColor.green
            case .notConnected:
                self.networkConnectionStatusLbl.textColor = UIColor.red
            default:
                self.networkConnectionStatusLbl.textColor = UIColor.gray
            }
        }

        let internetConnectivityDelegate = GLMulticastDelegate<GLInternetStatus> (queue: DispatchQueue.main) { internetConnectivityStatus in
            self.internetConnectivityStatusLbl.text = String(describing: internetConnectivityStatus)

            switch internetConnectivityStatus {
            case .online:
                self.internetConnectivityStatusLbl.textColor = UIColor.green
            case .offline:
                self.internetConnectivityStatusLbl.textColor = UIColor.red
            default:
                self.internetConnectivityStatusLbl.textColor = UIColor.gray
            }
        }

        let serverAvailabilityDelegate = GLMulticastDelegate<GLServiceStatus> (queue: DispatchQueue.main) { serverAvailabilityStatus in
            self.serverAvailabilityStatusLbl.text = String(describing: serverAvailabilityStatus)

            switch serverAvailabilityStatus {
            case .accessible:
                self.serverAvailabilityStatusLbl.textColor = UIColor.green
            case .notAccessible:
                self.serverAvailabilityStatusLbl.textColor = UIColor.red
            default:
                self.serverAvailabilityStatusLbl.textColor = UIColor.gray
            }
        }

        let networkAvailabilityDelegate = GLMulticastDelegate<GLNetworkStatus> (queue: DispatchQueue.main) { networkAvailabilityStatus in
            self.networkAvailabilityStatusLbl.text = String(describing: networkAvailabilityStatus)

            switch networkAvailabilityStatus {
            case .available:
                self.networkAvailabilityStatusLbl.textColor = UIColor.green
            case .notAvailable:
                self.networkAvailabilityStatusLbl.textColor = UIColor.red
            default:
                self.networkAvailabilityStatusLbl.textColor = UIColor.gray
            }
        }

        reachability.multicastCenter.networkConnection.addDelegate(networkConnectionDelegate)
        reachability.multicastCenter.internetAccessibility.addDelegate(internetConnectivityDelegate)
        reachability.multicastCenter.serverAccessibility.addDelegate(serverAvailabilityDelegate)
        reachability.multicastCenter.networkAvailability.addDelegate(networkAvailabilityDelegate)
    }
    
    @IBAction func login(_ sender: UIButton) {
        let request = getLoginRequest()

        networkManager.execute(request: request)
    }
    
    @IBAction func logout(_ sender: UIButton) {
        logout()
    }
    
    @IBAction func turnOnAutoAuthentication(_ sender: UIButton) {
        setupGLNetworking(withAutoAuthentication: true)
    }

    @IBAction func turnOffAutoAuthentication(_ sender: UIButton) {
        setupGLNetworking(withAutoAuthentication: false)
    }

    @IBAction func getAuthorizedContent(_ sender: UIButton) {
        fetchServerTime()
    }

    private func fetchServerTime() {
        let request = GLRequest
            .create(url: URLConstants.serverTimeURL)?
            .success { response in
                self.setFetchSucceeded(
                    forLabel: self.fetchAuthContentLbl,
                    withContent: String(bytes: response.data!, encoding: .utf8) ?? "Unexpected encoding")
            }
            .error { response in
                self.setFetchFailed(forLabel: self.fetchAuthContentLbl)
            }
        
        if let request = request {
            networkManager.execute(request: request)
        }
    }
    
    private func setFetchSucceeded(forLabel label: UILabel, withContent content: String) {
        DispatchQueue.main.async {
            label.text = content
            label.textColor = UIColor.green
        }
    }

    private func setFetchFailed(forLabel label: UILabel) {
        DispatchQueue.main.async {
            self.fetchAuthContentLbl.text = "Request failed"
            self.fetchAuthContentLbl.textColor = UIColor.red
        }
    }
    
    private func setFetchUnknown(forLabel label: UILabel) {
        DispatchQueue.main.async {
            label.text = "Request unknown"
            label.textColor = UIColor.gray
        }
    }

    fileprivate func getLoginRequest() -> GLRequest {
        return GLRequest
                .create(url: URLConstants.loginURL)!
                .httpMethod("post")
                .jsonBody([
                    "username": "",
                    "password": ""
                ])
                .success(loginSuccessful)
                .error { _ in self.logout() }
    }

    private func loginSuccessful(response: GLResponse) {
        do {
            let authResponse = try JSONDecoder().decode(AuthResponse.self, from: response.data!)
            authToken = authResponse.token
        } catch {
            logout()
        }
    }

    private func logout() {
        // token couldn't be revoked, so it's just thrown away
        authToken = nil
    }
}

extension ViewController: GLReachabilityDelegate {
    func dnsCheckRequest(sender: GLReachability) -> GLRequest {
        return GLRequest.create(url: URLConstants.networkAvailabilityURL)!
    }
    
    func serviceCheckRequest(sender: GLReachability) -> GLRequest {
        return GLRequest.create(url: URLConstants.availabilityURL)!
    }
}

extension ViewController: GLAuthDelegate {
    func authenticationRequest(sender: GLAuthHandler) -> GLRequest {
        return getLoginRequest()
    }
}

extension ViewController: GLRequestAuthenticator {
    func authenticate(request: GLRequest) {
        if let token = authToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
    }
}
