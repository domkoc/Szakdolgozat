//
//  SSSLAuthenticator.swift
//  SSSLManager_iOS
//
//  Created by Kocka Dominik Csaba on 2021. 11. 05..
//

import Alamofire
import Foundation

class SSSLAuthenticator: Authenticator {
    private let tokenManager: TokenManager
    var coordinator: AppCoordinator?
    init(tokenManager: TokenManager) {
        self.tokenManager = tokenManager
    }
    func apply(_ credential: SSSLAuthCredentials, to urlRequest: inout URLRequest) {
        urlRequest.headers.add(.authorization(bearerToken: credential.token))
    }
    func refresh(_ credential: SSSLAuthCredentials,
                 for session: Session,
                 completion: @escaping (Result<SSSLAuthCredentials, Error>) -> Void) { }
    private func logInAgain() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            AuthenticationService.shared.clearUserData()
            self.coordinator?.navigateBackToLogin()
        }
    }
    func didRequest(_ urlRequest: URLRequest,
                    with response: HTTPURLResponse,
                    failDueToAuthenticationError error: Error) -> Bool {
        guard response.statusCode != 403 else {
            logInAgain()
            return false
        }
        return true
    }
    func isRequest(_ urlRequest: URLRequest, authenticatedWith credential: SSSLAuthCredentials) -> Bool {
        let bearerToken = HTTPHeader.authorization(bearerToken: credential.token).value
        return urlRequest.headers["Authorization"] == bearerToken
    }
}
