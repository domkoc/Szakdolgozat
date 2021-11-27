//
//  TokenManager.swift
//  SSSLManager_iOS
//
//  Created by Kocka Dominik Csaba on 2021. 11. 05..
//

import Foundation

import KeychainAccess

protocol TokenManager {
    func save(token: String?)
    func get() -> String?
}

class KeyChainTokenManager: TokenManager {
    static let shared = KeyChainTokenManager()
    private let keychain = Keychain(server: Constants.Network.webBaseUrl + Constants.Network.serverDomain,
                                    protocolType: .https)
    private init() { }
    func save(token: String?) {
        keychain[Constants.Token.tokenKey] = token
    }
    func get() -> String? {
        keychain[Constants.Token.tokenKey]
    }
}

class UserDefaultsTokenManager: TokenManager {
    static let shared = UserDefaultsTokenManager()
    private let userDefaults = UserDefaults.standard
    private init() { }
    func save(token: String?) {
        userDefaults.set(token, forKey: Constants.Token.tokenKey)
    }
    func get() -> String? {
        userDefaults.string(forKey: Constants.Token.tokenKey)
    }
}
