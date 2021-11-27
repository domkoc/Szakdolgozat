//
//  EventDetailsPresenter.swift
//  SSSLManager_iOS
//
//  Created by Kocka Dominik Csaba on 2021. 11. 16..
//

import Foundation
import UIKit

protocol EventDetailsPresenterInput: AnyObject {
    var view: EventDetailsView? { get set }
    var interactor: EventsInteractorInput { get set }
    var presentationModel: EventDetailsPresentationModel { get set }
    func loadEventData()
    func navigateToOrganizerProfile()
    func applyToEvent()
    func toggleAppliability()
    func isOrganizer() -> Bool
    func navigateToEventApplications()
    func navigateToSubEvents()
    func uploadEventPicture(_ image: UIImage)
    func loadImage()
}

class EventDetailsPresenter {
    private var errors: [String]
    weak var view: EventDetailsView?
    var interactor: EventsInteractorInput
    private let coordinator: EventsCoordinatorInput
    var presentationModel: EventDetailsPresentationModel
    init(view: EventDetailsView,
         interactor: EventsInteractorInput,
         coordinator: EventsCoordinatorInput,
         presentationModel: EventDetailsPresentationModel) {
        self.errors = []
        self.view = view
        self.interactor = interactor
        self.coordinator = coordinator
        self.presentationModel = presentationModel
    }
}

extension EventDetailsPresenter: EventDetailsPresenterInput {
    func loadEventData() {
        let group = DispatchGroup()
        loadOrganizer(group)
        loadApplicationState(group)
        group.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            if !self.errors.isEmpty {
                self.errors = self.errors.withoutDuplicates
                self.view?.showErrorAlert(message: self.errors.joinedWithNewLine, handler: nil)
            } else {
                self.view?.loadData(self.presentationModel)
            }
            self.errors = []
        }
    }
    private func loadOrganizer(_ group: DispatchGroup) {
        group.enter()
        interactor.getProfileById(id: presentationModel.event.organizerID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let profile):
                self.presentationModel.organizer = profile
                self.view?.loadData(self.presentationModel)
            case .failure(.error(let message)):
                self.view?.showErrorAlert(message: message, handler: nil)
                self.errors.append(message)
            }
            group.leave()
        }
    }
    private func loadApplicationState(_ group: DispatchGroup) {
        group.enter()
        interactor.getEventApplicationState(event: presentationModel.event) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let applicationState):
                self.presentationModel.didApplyToEvent = applicationState
                self.view?.loadData(self.presentationModel)
            case .failure(.error(let message)):
                self.errors.append(message)
            }
            group.leave()
        }
    }
    func navigateToOrganizerProfile() {
        guard let profile = presentationModel.organizer else { return }
        coordinator.navigateToProfile(of: profile)
    }
    func applyToEvent() {
        interactor.applyToEvent(event: presentationModel.event) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.presentationModel.didApplyToEvent?.toggle()
                self.view?.toggleApplyButtonState(didApply: self.presentationModel.didApplyToEvent ?? false)
            case .failure(.error(let message)):
                self.view?.showErrorAlert(message: message, handler: nil)
            }
        }
    }
    func toggleAppliability() {
        interactor.toggleEventAppliability(event: presentationModel.event) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.presentationModel.event.isApplyable.toggle()
                self.view?.toggleAppliabilityState(appliable: self.presentationModel.event.isApplyable)
            case .failure(.error(let message)):
                self.view?.showErrorAlert(message: message, handler: nil)
            }
        }
    }
    func isOrganizer() -> Bool {
        return presentationModel.event.organizerID == UserService.shared.currentUser?.id
    }
    func navigateToEventApplications() {
        coordinator.navigateToApplicants(of: presentationModel.event)
    }
    func navigateToSubEvents() {
        coordinator.navigateToSubEvents(of: presentationModel.event)
    }
    func uploadEventPicture(_ image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
        interactor.uploadEventPicture(imageData, for: presentationModel.event) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.view?.updateImage(image)
            case .failure(.error(let message)):
                self.view?.showErrorAlert(message: message, handler: nil)
            }
        }
    }
    func loadImage() {
        interactor.getEventImage(of: presentationModel.event) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let image):
                self.view?.updateImage(image)
            case .failure(.error(let message)):
                self.view?.showErrorAlert(message: message, handler: nil)
            }
        }
    }
}
