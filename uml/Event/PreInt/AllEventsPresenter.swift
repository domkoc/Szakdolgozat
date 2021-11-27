//
//  AllEventsPresenter.swift
//  SSSLManager_iOS
//
//  Created by Kocka Dominik Csaba on 2021. 11. 15..
//

import Foundation

protocol AllEventsPresenterInput: AnyObject {
    var view: AllEventsView? { get set }
    var interactor: EventsInteractorInput { get set }
    var presentationModel: AllEventsPresentationModel? { get set }
    func loadEventsData()
    func navigateToNewEvent()
    func navigateToEvent(index: Int)
    func isUsersEvents() -> Bool
}

class AllEventsPresenter {
    weak var view: AllEventsView?
    var interactor: EventsInteractorInput
    private let coordinator: EventsCoordinatorInput
    var presentationModel: AllEventsPresentationModel?
    private let userid: UUID?
    init(view: AllEventsView,
         interactor: EventsInteractorInput,
         coordinator: EventsCoordinatorInput,
         userid: UUID? = nil) {
        self.view = view
        self.interactor = interactor
        self.coordinator = coordinator
        self.userid = userid
    }
}

extension AllEventsPresenter: AllEventsPresenterInput {
    func loadEventsData() {
        if let userid = userid {
            interactor.getEventsByUserId(id: userid) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let events):
                    let tempPresentationModel = AllEventsPresentationModel(events: events)
                    self.view?.loadEventsData(tempPresentationModel)
                case .failure(.error(let message)):
                    self.view?.showErrorAlert(message: message, handler: nil)
                }
            }
        } else {
            interactor.getEvents { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let events):
                    let tempPresentationModel = AllEventsPresentationModel(events: events)
                    self.view?.loadEventsData(tempPresentationModel)
                case .failure(.error(let message)):
                    self.view?.showErrorAlert(message: message, handler: nil)
                }
            }
        }
    }
    func navigateToNewEvent() {
        coordinator.navigateToNewEvent()
    }
    func navigateToEvent(index: Int) {
        guard let event = presentationModel?.events[index] else {
            return
        }
        coordinator.navigateToEventDetails(with: event)
    }
    func isUsersEvents() -> Bool {
        self.userid != nil
    }
}
