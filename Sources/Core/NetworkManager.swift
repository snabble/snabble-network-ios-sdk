//
//  NetworkManager.swift
//  
//
//  Created by Andreas Osberghaus on 2022-12-19.
//

import Combine
import Foundation

public protocol NetworkManagerDelegate: AnyObject {
    func networkManager(_ networkManager: NetworkManager, appUserForConfiguration configuration: Configuration) -> AppUser?
    func networkManager(_ networkManager: NetworkManager, appUserUpdated appUser: AppUser)

    func networkManager(_ networkManager: NetworkManager, projectIdForConfiguration configuration: Configuration) -> String?
}

public class NetworkManager {
    public let configuration: Configuration
    private let authenticator: Authenticator
    public weak var delegate: NetworkManagerDelegate?

    public init(configuration: Configuration, urlSession: URLSession = .shared) {
        self.configuration = configuration
        self.authenticator = Authenticator(urlSession: urlSession)
        self.authenticator.delegate = self
    }

    public var urlSession: URLSession {
        authenticator.urlSession
    }

    public func publisher<Response>(for endpoint: Endpoint<Response>) -> AnyPublisher<Response, Swift.Error> {
        return authenticator.validToken(withConfiguration: configuration)
            .map { [self] token -> Endpoint<Response> in
                var endpoint = endpoint
                endpoint.domain = configuration.domain
                endpoint.token = token
                return endpoint
            }
            .flatMap { [self] endpoint in
                urlSession.dataTaskPublisher(for: endpoint)
            }
            .retryOnce(if: { error in
                if case let HTTPError.invalid(response) = error {
                    let statusCode = response.httpStatusCode
                    return statusCode == .unauthorized || statusCode == .forbidden
                }
                return false
            }, doBefore: { [weak self] in
                self?.authenticator.invalidateToken()
            })
            .handleEvents(receiveOutput: { [weak self] response in
                if let appUser = response as? AppUser {
                    self?.authenticator.updateAppUser(appUser)
                }
            })
            .eraseToAnyPublisher()
    }
}

extension NetworkManager: AuthenticatorDelegate {
    func authenticator(_ authenticator: Authenticator, appUserUpdated appUser: AppUser) {
        delegate?.networkManager(self, appUserUpdated: appUser)
    }
    
    func authenticator(_ authenticator: Authenticator, appUserForConfiguration configuration: Configuration) -> AppUser? {
        delegate?.networkManager(self, appUserForConfiguration: configuration)
    }
    
    func authenticator(_ authenticator: Authenticator, projectIdForConfiguration configuration: Configuration) -> String? {
        delegate?.networkManager(self, projectIdForConfiguration: configuration)
    }
}
