//
//  EventDTOs.swift
//  SSSLManager_iOS
//
//  Created by Kocka Dominik Csaba on 2021. 11. 15..
//

import Foundation

struct EventDownloadDto: Decodable {
    var id: UUID
    var organizer: UUID
    var title: String
    var description: String
    var start_date: Double
    var end_date: Double
    var location: String
    var is_applyable: Bool
    var application_start: Double?
    var application_end: Double?
    var parent_event: UUID?
}

struct NewEventUploadDto: Encodable {
    var title: String
    var description: String
    var startDate: Double
    var endDate: Double
    var location: String
}

struct EventApplicationStateDto: Decodable {
    var did_apply: Bool
}

struct EventPictureUploadDto: Encodable {
    let image: Data
}
