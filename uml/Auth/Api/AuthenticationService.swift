//
//  AuthenticationService.swift
//  SSSLManager_iOS
//
//  Created by Kocka Dominik Csaba on 2021. 11. 05..
//

import Foundation

enum AuthenticationServiceSuccess {
    enum Login {
        case loggedIn
    }
    enum Logout {
        case loggedOut
    }
}

enum AuthenticationServiceError: Error {
    case error(String)
}

class AuthenticationService {
    static let shared = AuthenticationService()
    private let authenticationApi: AuthenticationAPIInput = AuthenticationAPI()
    private init() { }
    var hasValidAccessToken: Bool {
        UserService.shared.currentUser != nil &&
        NetworkConfigurator.shared.tokenManager.get() != nil
    }
    func loginWithCredentials(credentials: Login,
                              completion: @escaping (Result<AuthenticationServiceSuccess.Login,
                                                     AuthenticationServiceError>) -> Void) {
        let dto = LoginDTO(email: credentials.email,
                           password: credentials.password)
        authenticationApi.login(with: dto) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let loginDto):
                guard self.saveLoginData(loginDto) else {
                    completion(.failure(.error("Ismeretlen hiba történt!")))
                    return
                }
                completion(.success(.loggedIn))
            case .error(let message):
                completion(.failure(.error(message)))
            }
        }
    }
    private func saveLoginData(_ loginDto: UserCredentialsDto) -> Bool {
        guard let token = loginDto.token,
              let userId = loginDto.user.id,
              let userName = loginDto.user.username else {
                  return false
              }
        self.saveToken(token, expiration: Date.init(timeIntervalSince1970: loginDto.expiration ?? 0.0))
        self.saveUser(id: userId,
                      userName: userName)
        return true
    }
    private func saveUser(id: UUID, userName: String) {
        UserService.shared.currentUser = UserService.User(id: id,
                                                          username: userName)
    }
    func clearUserData() {
        NetworkConfigurator.shared.interceptor.credential = nil
        NetworkConfigurator.shared.tokenManager.save(token: nil)
        UserService.shared.currentUser = nil
    }
    private func saveToken(_ token: String, expiration: Date) {
        NetworkConfigurator.shared.tokenManager.save(token: token)
        var credential = SSSLAuthCredentials(token: token)
        credential.setExpiration(expiration)
        NetworkConfigurator.shared.interceptor.credential = credential
    }
    func logout(completion: @escaping (Result<AuthenticationServiceSuccess.Logout,
                                       AuthenticationServiceError>) -> Void) {
        self.clearUserData()
        completion(.success(.loggedOut))
    }
}
