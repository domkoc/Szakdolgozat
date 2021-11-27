//
//  AuthenticationDTOs.swift
//  SSSLManager_iOS
//
//  Created by Kocka Dominik Csaba on 2021. 11. 05..
//

import Foundation

struct LoginDTO: Codable {
    let email: String
    let password: String
}

struct UserCredentialsDto: Decodable {
    var token: String?
    var user: ProfileDownloadDto
    let expiration: Double?
}
