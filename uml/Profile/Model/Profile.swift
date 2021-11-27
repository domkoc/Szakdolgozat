//
//  Profile.swift
//  SSSLManager_iOS
//
//  Created by Kocka Dominik Csaba on 2021. 11. 07..
//

import Foundation

struct Profile {
    let username: String
    let id: UUID
    let fullname: String?
    let nickname: String?
    let schgroup: SCHgroup?
    let roles: [Roles]
    let createdAt: Date?
    let updatedAt: Date?
    init(username: String,
         id: UUID,
         fullname: String?,
         nickname: String?,
         schgroup: SCHgroup?,
         roles: [Roles],
         createdAt: Date?,
         updatedAt: Date?) {
        self.username = username
        self.id = id
        self.fullname = fullname
        self.nickname = nickname
        self.schgroup = schgroup
        self.roles = roles
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    init(dto: ProfileDownloadDto) {
        self.username = dto.username!
        self.id = dto.id!
        self.fullname = dto.fullname
        self.nickname = dto.nickname
        self.schgroup = dto.schgroup
        self.roles = dto.roles
        self.createdAt = dto.created_at != nil ? Date(timeIntervalSince1970: dto.created_at!) : nil
        self.updatedAt = dto.updated_at != nil ? Date(timeIntervalSince1970: dto.updated_at!) : nil
    }
    func getRepresentableValues() -> [UserProfileTableViewCellConfig] {
        var values: [UserProfileTableViewCellConfig] = []
        values.append(UserProfileTableViewCellConfig(title: "Username",
                                                     description: username))
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        if let fullname = fullname {
            values.append(UserProfileTableViewCellConfig(title: "Full Name",
                                                         description: fullname))
        }
        if let nickname = nickname,
           !nickname.isEmpty {
            values.append(UserProfileTableViewCellConfig(title: "Nickname",
                                                         description: nickname))
        }
        if let schgroup = schgroup {
            values.append(UserProfileTableViewCellConfig(title: "SCH Group",
                                                         description: schgroup.stringValue))
        }
        if roles.contains(where: { $0 == .admin }) {
            values.append(UserProfileTableViewCellConfig(title: "Admin role",
                                                         description: "Yes"))
        }
        if let createdAt = createdAt {
            let formatted = dateFormatter.string(from: createdAt)
            values.append(UserProfileTableViewCellConfig(title: "Registration date",
                                                         description: formatted))
        }
        if let updatedAt = updatedAt {
            values.append(UserProfileTableViewCellConfig(title: "Last update date",
                                                         description: dateFormatter.string(from: updatedAt)))
        }
        return values
    }
    func fieldsCount() -> Int {
        var count: Int = 2
        if let _ = fullname {
            count += 1
        }
        if let _ = nickname {
            count += 1
        }
        if let _ = schgroup {
            count += 1
        }
        if roles.count < 1 {
            count += 1
        }
        if let _ = createdAt {
            count += 1
        }
        if let _ = updatedAt {
            count += 1
        }
        return count
    }
}


struct EditedProfileCredentials {
    let id: UUID
    let email: String
    let fullname: String
    let group: SCHgroup?
    let nickname: String?
    var dto: ProfileEditDto {
        ProfileEditDto(id: id,
                       username: email,
                       fullname: fullname,
                       nickname: nickname,
                       schgroup: group)
    }
}
