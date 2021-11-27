//
//  SubEventsPresenter.swift
//  SSSLManager_iOS
//
//  Created by Kocka Dominik Csaba on 2021. 11. 22..
//

import Foundation

protocol SubEventsPresenterInput: AnyObject {
    var view: SubEventsView? { get set }
    var interactor: EventsInteractorInput { get set }
    var presentationModel: SubEventsPresentationModel? { get set }
    func loadData()
    func navigateToSubEvent(_ event: Event)
    func navigateToNewSubEvent()
}

class SubEventsPresenter {
    weak var view: SubEventsView?
    var interactor: EventsInteractorInput
    private let coordinator: EventsCoordinatorInput
    private let parentEvent: Event
    var presentationModel: SubEventsPresentationModel?
    init(view: SubEventsView,
         interactor: EventsInteractorInput,
         coordinator: EventsCoordinatorInput,
         parentEvent: Event) {
        self.view = view
        self.interactor = interactor
        self.coordinator = coordinator
        self.parentEvent = parentEvent
        self.presentationModel = SubEventsPresentationModel(subEvents: [])
    }
}

extension SubEventsPresenter: SubEventsPresenterInput {
    func loadData() {
        interactor.getSubEvents(of: self.parentEvent) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let events):
                self.presentationModel?.subEvents = events
                self.view?.loadData()
            case .failure(.error(let message)):
                self.view?.showErrorAlert(message: message, handler: nil)
            }
        }
    }
    func navigateToSubEvent(_ event: Event) {
        coordinator.navigateToEventDetails(with: event)
    }
    func navigateToNewSubEvent() {
        coordinator.navigateToNewEvent(with: self.parentEvent)
    }
}
