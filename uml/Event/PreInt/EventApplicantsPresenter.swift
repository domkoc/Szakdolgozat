
//  EventApplicantsPresenter.swift
//  SSSLManager_iOS
//
//  Created by Kocka Dominik Csaba on 2021. 11. 21..
//

import Foundation

protocol EventApplicantsPresenterInput: AnyObject {
    var view: EventApplicantsView? { get set }
    var interactor: EventsInteractorInput { get set }
    var presentationModel: EventApplicantsPresentationModel? { get set }
    func loadData()
    func navigateToProfile(of profile: Profile)
    func acceptApplicant(_ profile: Profile)
    func isOrganizer() -> Bool
}

class EventApplicantsPresenter {
    private var errors: [String]
    weak var view: EventApplicantsView?
    var interactor: EventsInteractorInput
    private let coordinator: EventsCoordinatorInput
    private let event: Event
    var presentationModel: EventApplicantsPresentationModel?
    init(view: EventApplicantsView,
         interactor: EventsInteractorInput,
         coordinator: EventsCoordinatorInput,
         event: Event) {
        self.errors = []
        self.view = view
        self.interactor = interactor
        self.coordinator = coordinator
        self.event = event
        self.presentationModel = EventApplicantsPresentationModel(applicants: [], workers: [])
    }
}

extension EventApplicantsPresenter: EventApplicantsPresenterInput {
    func loadData() {
        let group = DispatchGroup()
        loadApplicants(group)
        loadWorkers(group)
        group.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            if !self.errors.isEmpty {
                self.errors = self.errors.withoutDuplicates
                self.view?.showErrorAlert(message: self.errors.joinedWithNewLine, handler: nil)
            } else {
                self.view?.loadData()
            }
            self.errors = []
        }
        
    }
    private func loadApplicants(_ group: DispatchGroup) {
        group.enter()
        interactor.getApplicantsByEvent(id: event.id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let applicants):
                self.presentationModel?.applicants = applicants
            case .failure(.error(let message)):
                self.errors.append(message)
            }
            group.leave()
        }
    }
    private func loadWorkers(_ group: DispatchGroup) {
        group.enter()
        interactor.getWorkersByEvent(id: event.id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let workers):
                self.presentationModel?.workers = workers
            case .failure(.error(let message)):
                self.errors.append(message)
            }
            group.leave()
        }
    }
    func navigateToProfile(of profile: Profile) {
        coordinator.navigateToProfile(of: profile)
    }
    func acceptApplicant(_ profile: Profile) {
        interactor.acceptApplication(userid: profile.id, eventid: event.id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.presentationModel?.applicants.removeAll(where: { $0.id == profile.id })
                self.presentationModel?.workers.append(profile)
                self.view?.loadData()
            case .failure(.error(let message)):
                self.errors.append(message)
            }
        }
    }
    func isOrganizer() -> Bool {
        event.organizerID == UserService.shared.currentUser?.id
    }
}

