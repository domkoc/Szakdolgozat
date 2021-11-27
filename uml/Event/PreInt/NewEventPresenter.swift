//
//  NewEventPresenter.swift
//  SSSLManager_iOS
//
//  Created by Kocka Dominik Csaba on 2021. 11. 16..
//

import Foundation

protocol NewEventPresenterInput: AnyObject {
    var view: NewEventView? { get set }
    var interactor: EventsInteractorInput { get set }
    var presentationModel: NewEventPresentationModel? { get set }
    func saveNewEvent(_ event: NewEvent)
}

class NewEventPresenter {
    weak var view: NewEventView?
    var interactor: EventsInteractorInput
    private let coordinator: EventsCoordinatorInput
    var presentationModel: NewEventPresentationModel?
    private let mainEvent: Event?
    init(view: NewEventView,
         interactor: EventsInteractorInput,
         coordinator: EventsCoordinatorInput,
         mainEvent: Event? = nil) {
        self.view = view
        self.interactor = interactor
        self.coordinator = coordinator
        self.mainEvent = mainEvent
    }
}

extension NewEventPresenter: NewEventPresenterInput {
    func saveNewEvent(_ event: NewEvent) {
        if let parentEvent = self.mainEvent {
            interactor.createNewSubEvent(for: parentEvent,
                                            newEvent: event) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let event):
                    self.coordinator.navigateBack()
                    self.coordinator.navigateToEventDetails(with: event)
                case .failure(.error(let message)):
                    self.view?.showErrorAlert(message: message) { _ in
                        self.view?.enableDoneButton()
                    }
                }
            }
        } else {
            interactor.createNewEvent(newEvent: event) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let event):
                    self.coordinator.navigateBack()
                    self.coordinator.navigateToEventDetails(with: event)
                case .failure(.error(let message)):
                    self.view?.showErrorAlert(message: message) { _ in
                        self.view?.enableDoneButton()
                    }
                }
            }
        }
    }
}
