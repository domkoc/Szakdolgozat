//
//  SSSLAuthCredentials.swift
//  SSSLManager_iOS
//
//  Created by Kocka Dominik Csaba on 2021. 11. 05..
//

import Foundation
import Alamofire

struct SSSLAuthCredentials: AuthenticationCredential {
    static let maxMinutesTillExpiration: TimeInterval = 5
    var token: String
    var expiration: Date?
    var requiresRefresh: Bool = false
    internal init(token: String) {
        self.token = token
    }
    mutating func setExpiration(_ expiration: Date) {
        self.expiration = expiration
    }
}
