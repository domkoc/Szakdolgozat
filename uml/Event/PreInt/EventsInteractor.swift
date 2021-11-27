//
//  EventsInteractor.swift
//  SSSLManager_iOS
//
//  Created by Kocka Dominik Csaba on 2021. 11. 15..
//

import Foundation
import UIKit

struct EventsInteractorSuccess {
    enum Application {
        case applyed
    }
    enum Toggle {
        case toggled
    }
    enum Accept {
        case accepted
    }
    enum Upload {
        case uploaded
    }
}

enum EventsInteractorError: Error {
    case error(String)
}

protocol EventsInteractorInput: AnyObject {
    func getEvents(completion: @escaping (Result<[Event],
                                          EventsInteractorError>) -> Void)
    func createNewEvent(newEvent: NewEvent,
                        completion: @escaping (Result<Event,
                                               EventsInteractorError>) -> Void)
    func getProfileById(id: UUID,
                        completion: @escaping (Result<Profile,
                                               EventsInteractorError>) -> Void)
    func getEventsByUserId(id: UUID,
                           completion: @escaping (Result<[Event],
                                                  EventsInteractorError>) -> Void)
    func getEventApplicationState(event: Event,
                                  completion: @escaping (Result<Bool,
                                                         EventsInteractorError>) -> Void)
    func applyToEvent(event: Event,
                      completion: @escaping (Result<EventsInteractorSuccess.Application,
                                             EventsInteractorError>) -> Void)
    func toggleEventAppliability(event: Event,
                                 completion: @escaping (Result<EventsInteractorSuccess.Toggle,
                                                        EventsInteractorError>) -> Void)
    func getApplicantsByEvent(id: UUID,
                              completion: @escaping (Result<[Profile],
                                                     EventsInteractorError>) -> Void)
    func getWorkersByEvent(id: UUID,
                           completion: @escaping (Result<[Profile],
                                                  EventsInteractorError>) -> Void)
    func acceptApplication(userid: UUID,
                           eventid: UUID,
                           completion: @escaping (Result<EventsInteractorSuccess.Accept,
                                                  EventsInteractorError>) -> Void)
    func getSubEvents(of event: Event,
                      completion: @escaping (Result<[Event],
                                             EventsInteractorError>) -> Void)
    func createNewSubEvent(for parentEvent: Event,
                           newEvent: NewEvent,
                           completion: @escaping (Result<Event,
                                                  EventsInteractorError>) -> Void)
    func uploadEventPicture(_ image: Data,
                            for event: Event,
                            completion: @escaping (Result<EventsInteractorSuccess.Upload,
                                                   EventsInteractorError>) -> Void)
    func getEventImage(of event: Event,
                         completion: @escaping (Result<UIImage,
                                                EventsInteractorError>) -> Void)
}

class EventsInteractor {
    private let eventApi: EventAPIInput
    private let profileApi: ProfileAPIInput
    init(eventApi: EventAPIInput,
         profileApi: ProfileAPIInput) {
        self.eventApi = eventApi
        self.profileApi = profileApi
    }
}

extension EventsInteractor: EventsInteractorInput {
    func getEvents(completion: @escaping (Result<[Event], EventsInteractorError>) -> Void) {
        eventApi.getAllEvent { result in
            switch result {
            case .success(let events):
                completion(.success(events.asEvent()))
            case .error(let message):
                completion(.failure(.error(message)))
            }
        }
    }
    func createNewEvent(newEvent: NewEvent,
                        completion: @escaping (Result<Event,
                                               EventsInteractorError>) -> Void) {
        eventApi.createNewEvent(with: newEvent.dto) { result in
            switch result {
            case .success(let event):
                completion(.success(Event.init(dto: event)))
            case .error(let message):
                completion(.failure(.error(message)))
            }
        }
    }
    func getProfileById(id: UUID,
                        completion: @escaping (Result<Profile,
                                               EventsInteractorError>) -> Void) {
        profileApi.getProfilebyId(with: id) { result in
            switch result {
            case .success(let profile):
                completion(.success(Profile(dto: profile)))
            case .error(let message):
                completion(.failure(.error(message)))
            }
        }
    }
    func getEventsByUserId(id: UUID,
                           completion: @escaping (Result<[Event],
                                                  EventsInteractorError>) -> Void) {
        eventApi.getEventsByUserId(with: id) { result in
            switch result {
            case .success(let events):
                completion(.success(events.asEvent()))
            case .error(let message):
                completion(.failure(.error(message)))
            }
        }
    }
    func getEventApplicationState(event: Event,
                                  completion: @escaping (Result<Bool,
                                                         EventsInteractorError>) -> Void) {
        eventApi.getEventApplicationState(with: event.id) { result in
            switch result {
            case .success(let applicationState):
                completion(.success(applicationState.did_apply))
            case .error(let message):
                completion(.failure(.error(message)))
            }
        }
        
    }
    func applyToEvent(event: Event,
                      completion: @escaping (Result<EventsInteractorSuccess.Application,
                                             EventsInteractorError>) -> Void) {
        eventApi.applyToEvent(with: event.id) { result in
            switch result {
            case .success:
                completion(.success(.applyed))
            case .error(let message):
                completion(.failure(.error(message)))
            }
        }
    }
    func toggleEventAppliability(event: Event,
                                 completion: @escaping (Result<EventsInteractorSuccess.Toggle,
                                                        EventsInteractorError>) -> Void) {
        eventApi.toggleEventAppliability(with: event.id) { result in
            switch result {
            case .success:
                completion(.success(.toggled))
            case .error(let message):
                completion(.failure(.error(message)))
            }
        }
    }
    func getApplicantsByEvent(id: UUID,
                              completion: @escaping (Result<[Profile],
                                                     EventsInteractorError>) -> Void) {
        eventApi.getApplicantsByEvent(with: id) { result in
            switch result {
            case .success(let profileDto):
                completion(.success(profileDto.map({ Profile(dto: $0) })))
            case .error(let message):
                completion(.failure(.error(message)))
            }
        }
    }
    func getWorkersByEvent(id: UUID,
                           completion: @escaping (Result<[Profile],
                                                  EventsInteractorError>) -> Void) {
        eventApi.getWorkersByEvent(with: id) { result in
            switch result {
            case .success(let profileDto):
                completion(.success(profileDto.map({ Profile(dto: $0) })))
            case .error(let message):
                completion(.failure(.error(message)))
            }
        }
    }
    func acceptApplication(userid: UUID,
                           eventid: UUID,
                           completion: @escaping (Result<EventsInteractorSuccess.Accept,
                                                  EventsInteractorError>) -> Void) {
        eventApi.acceptApplicant(userid,
                                 on: eventid) { result in
            switch result {
            case .success:
                completion(.success(.accepted))
            case .error(let message):
                completion(.failure(.error(message)))
            }
            
        }
    }
    func getSubEvents(of event: Event,
                      completion: @escaping (Result<[Event],
                                             EventsInteractorError>) -> Void) {
        eventApi.getSubEvents(of: event.id) { result in
            switch result {
            case .success(let eventsDto):
                completion(.success(eventsDto.map({ Event(dto: $0) })))
            case .error(let message):
                completion(.failure(.error(message)))
            }
        }
    }
    func createNewSubEvent(for parentEvent: Event,
                           newEvent: NewEvent,
                           completion: @escaping (Result<Event,
                                                  EventsInteractorError>) -> Void) {
        eventApi.createNewSubEvent(for: parentEvent.id, with: newEvent.dto) { result in
            switch result {
            case .success(let event):
                completion(.success(Event.init(dto: event)))
            case .error(let message):
                completion(.failure(.error(message)))
            }
        }
    }
    func uploadEventPicture(_ image: Data,
                            for event: Event,
                            completion: @escaping (Result<EventsInteractorSuccess.Upload,
                                                   EventsInteractorError>) -> Void) {
        eventApi.uploadEventPicture(EventPictureUploadDto(image: image),
                                    for: event.id,
                                    progressCompletion: { _ in },
                                    completion: { result in
            switch result {
            case .success:
                completion(.success(.uploaded))
            case .error(let message):
                completion(.failure(.error(message)))
            }
        })
    }
    func getEventImage(of event: Event,
                         completion: @escaping (Result<UIImage,
                                                EventsInteractorError>) -> Void) {
        eventApi.getEventPicture(of: event.id) { result in
            switch result {
            case .success(let image):
                completion(.success(image))
            case .error(let message):
                completion(.failure(.error(message)))
            }
        }
    }
}
