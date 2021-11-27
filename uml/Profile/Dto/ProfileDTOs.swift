//
//  ProfileDTOs.swift
//  SSSLManager_iOS
//
//  Created by Kocka Dominik Csaba on 2021. 11. 05..
//

import Foundation

enum SCHgroup: String, Codable, CaseIterable {
    case sir
    case nyuszi
    case ttny
    case drwu
    case fekete
    var stringValue: String {
        switch self {
        case .sir:
            return "SIR"
        case .nyuszi:
            return "Nyuszi"
        case .ttny:
            return "TTNY"
        case .drwu:
            return "Dr. Wu"
        case .fekete:
            return "Fekete"
        }
    }
}

enum Roles: String, Decodable {
    case user
    case admin
}

struct ProfileDownloadDto: Decodable {
    let username: String?
    let id: UUID?
    let fullname: String
    let nickname: String?
    let schgroup: SCHgroup?
    let roles: [Roles]
    let created_at: Double?
    let updated_at: Double?
}

struct ProfileUploadDto: Encodable {
    let username: String
    let password: String
    let fullname: String
    let nickname: String?
    let schgroup: SCHgroup?
}

struct ProfilePictureUploadDto: Encodable {
    let image: Data
}
