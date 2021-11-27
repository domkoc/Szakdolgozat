//
//  Event.swift
//  SSSLManager_iOS
//
//  Created by Kocka Dominik Csaba on 2021. 11. 15..
//

import Foundation
import LocationPicker
import CoreLocation

struct Event {
    var id: UUID
    var organizerID: UUID
    var title: String
    var description: String
    var startDate: Date
    var endDate: Date
    var location: CLLocation
    var isApplyable: Bool
    var applicationStart: Date?
    var applicationEnd: Date?
    var parentEventID: UUID?
    init(id: UUID,
         organizerID: UUID,
         title: String,
         description: String,
         startDate: Date,
         endDate: Date,
         location: CLLocation,
         isApplyable: Bool,
         applicationStart: Date? = nil,
         applicationEnd: Date? = nil,
         parentEventID: UUID? = nil) {
        self.id = id
        self.organizerID = organizerID
        self.title = title
        self.description = description
        self.startDate = startDate
        self.endDate = endDate
        self.location = location
        self.isApplyable = isApplyable
        self.applicationStart = applicationStart
        self.applicationEnd = applicationEnd
        self.parentEventID = parentEventID
    }
    init(dto: EventDownloadDto) {
        self.id = dto.id
        self.organizerID = dto.organizer
        self.title = dto.title
        self.description = dto.description
        self.startDate = Date(timeIntervalSince1970: dto.start_date)
        self.endDate = Date(timeIntervalSince1970: dto.end_date)
        if let latitude: Double = Double(dto.location.split(separator: ":")[0]),
           let longitude: Double = Double(dto.location.split(separator: ":")[1]) {
            self.location = CLLocation(latitude: latitude,
                                       longitude: longitude)
        } else {
            self.location = CLLocation()
        }
        self.isApplyable = dto.is_applyable
        self.applicationStart = dto.application_start != nil ? Date(timeIntervalSince1970: dto.application_start!) : nil
        self.applicationEnd = dto.application_end != nil ? Date(timeIntervalSince1970: dto.application_end!) : nil
        self.parentEventID = dto.parent_event
    }
}

struct NewEvent {
    var title: String
    var description: String
    var startDate: Date
    var endDate: Date
    var location: Location
    var dto: NewEventUploadDto {
        NewEventUploadDto(title: title,
                          description: description,
                          startDate: startDate.timeIntervalSince1970,
                          endDate: endDate.timeIntervalSince1970,
                          location: "\(location.coordinate.latitude):\(location.coordinate.longitude)")
    }
}
